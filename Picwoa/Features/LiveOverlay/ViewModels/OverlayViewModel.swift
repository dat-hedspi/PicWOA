import SwiftUI

@MainActor
@Observable
final class OverlayViewModel {

    var currentResponse: AICoachingResponse?
    var personDetected: Bool = false
    var currentPose: PoseObservation?

    // Pose suggestion state
    var suggestedPoses: [PoseSuggestion] = []
    var activePose: PoseSuggestion?
    var poseHintIndex: Int = 0
    private var currentScene: SceneContext = .unknown
    private var hintCycleTask: Task<Void, Never>?

    private(set) var lastResponse: AICoachingResponse?
    private var pendingResponse: AICoachingResponse?
    private var pendingTask: Task<Void, Never>?
    private var personLostTask: Task<Void, Never>?
    private var lastVisibleUpdateAt: Date = .distantPast
    private let minimumVisibleDuration: TimeInterval = 1.4
    private let stabilityDelay: TimeInterval = 0.65
    private let personLossDelay: TimeInterval = 1.2

    var showOverlay: Bool { personDetected && currentResponse != nil }
    var isReadyToCapture: Bool { currentResponse?.isReadyToCapture == true }

    func update(with response: AICoachingResponse) {
        guard let currentResponse else {
            apply(response)
            return
        }

        if currentResponse.mainCue == response.mainCue {
            apply(response)
            return
        }

        pendingResponse = response
        pendingTask?.cancel()

        let elapsed = Date().timeIntervalSince(lastVisibleUpdateAt)
        let delay = max(stabilityDelay, minimumVisibleDuration - elapsed)
        pendingTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                guard let self, let pendingResponse = self.pendingResponse else { return }
                self.apply(pendingResponse)
                self.pendingResponse = nil
            }
        }
    }

    private func apply(_ response: AICoachingResponse) {
        currentResponse = response
        lastResponse = response
        lastVisibleUpdateAt = Date()
    }

    func updatePersonDetected(_ detected: Bool) {
        if detected {
            personLostTask?.cancel()
            personLostTask = nil
            personDetected = true
            return
        }

        personLostTask?.cancel()
        let delay = personLossDelay
        personLostTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                guard let self else { return }
                self.personDetected = false
                self.pendingTask?.cancel()
                self.pendingResponse = nil
                self.currentResponse = nil
                self.currentPose = nil
            }
        }
    }

    func updatePose(_ pose: PoseObservation?) {
        currentPose = pose
    }

    // MARK: - Pose suggestion

    func updateScene(_ scene: SceneContext) {
        guard scene != currentScene else { return }
        currentScene = scene
        let poses = PoseSuggestion.poses(for: scene)
        suggestedPoses = poses
        // Keep active pose if it still applies, otherwise default to first
        if let active = activePose, poses.contains(where: { $0.id == active.id }) { return }
        activePose = poses.first
        startHintCycle()
    }

    func selectPose(_ pose: PoseSuggestion) {
        if activePose?.id == pose.id {
            activePose = nil
            hintCycleTask?.cancel()
        } else {
            activePose = pose
            poseHintIndex = 0
            startHintCycle()
        }
    }

    private func startHintCycle() {
        hintCycleTask?.cancel()
        hintCycleTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                guard !Task.isCancelled else { return }
                await MainActor.run { self?.poseHintIndex += 1 }
            }
        }
    }
}
