import Foundation

@MainActor
@Observable
final class AppCoordinator {
    let cameraEngine: CameraEngine
    let visionEngine: VisionEngine
    let ruleEngine: RuleEngine
    let orchestrator: AIOrchestrator
    let overlayViewModel: OverlayViewModel
    let cameraViewModel: CameraViewModel

    private var tasks: [Task<Void, Never>] = []
    private var hasStarted = false
    // Latest classified scene, fed into the AI prompt (updated ~1×/sec from the camera buffer).
    private var latestScene: SceneContext = .outdoor

    init(
        cameraEngine: CameraEngine = .shared,
        visionEngine: VisionEngine = .shared,
        ruleEngine: RuleEngine = RuleEngine(),
        // Honor Config.plist: real OpenAI when a key is set, otherwise safe MockAIClient.
        aiBackend: any AIBackendProtocol = AIConfig.makeBackend()
    ) {
        self.cameraEngine = cameraEngine
        self.visionEngine = visionEngine
        self.ruleEngine = ruleEngine
        self.orchestrator = AIOrchestrator(backend: aiBackend, ruleEngine: ruleEngine)
        self.overlayViewModel = OverlayViewModel()
        self.cameraViewModel = CameraViewModel(
            cameraEngine: cameraEngine,
            captureService: CaptureService(cameraEngine: cameraEngine)
        )
    }

    func start() {
        guard !hasStarted else { return }
        hasStarted = true

        tasks.append(Task { [cameraEngine, visionEngine, weak self] in
            let classifier = SceneClassifierService()
            var frame = 0
            for await buffer in cameraEngine.makeSampleBufferStream() {
                // Classify scene ~once/sec BEFORE handing the buffer to the Vision actor
                // (after the actor call the buffer is "sent" and can't be touched again).
                frame += 1
                if frame % 30 == 0 {
                    let scene = classifier.classifySynchronously(buffer)
                    await MainActor.run { self?.latestScene = scene }
                }
                await visionEngine.process(sampleBuffer: buffer)
            }
        })

        tasks.append(Task { [visionEngine, orchestrator, weak self] in
            for await pose in visionEngine.poseStream {
                guard let pose else { continue }
                let scene = await MainActor.run { self?.latestScene ?? .outdoor }
                await orchestrator.process(pose: pose, scene: scene)
            }
        })

        tasks.append(Task { [orchestrator, overlayViewModel] in
            for await coaching in orchestrator.coachingStream {
                await MainActor.run {
                    overlayViewModel.update(with: coaching)
                }
            }
        })

        tasks.append(Task { [visionEngine, overlayViewModel] in
            for await detected in visionEngine.personDetectedStream {
                await MainActor.run {
                    overlayViewModel.updatePersonDetected(detected)
                }
            }
        })
    }

    func stop() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
        hasStarted = false
        cameraEngine.stopSession()
    }
}
