import SwiftUI
import OSLog

private let cameraScreenLogger = Logger(subsystem: "com.picwoa.app", category: "CameraScreen")

struct CameraScreen: View {
    @State private var viewModel: CameraViewModel
    @State private var overlayViewModel: OverlayViewModel
    @State private var poseSuggestionViewModel: PoseSuggestionViewModel
    @State private var capturedImage: UIImage?
    @State private var coachingResponse: AICoachingResponse?
    @State private var showReview = false
    @State private var isRequestingAI = false

    /// Fired when the user taps the AI button — wired to `AppCoordinator.requestAICoaching()`.
    private let onRequestAICoaching: () async -> Void

    init(
        viewModel: CameraViewModel = CameraViewModel(),
        overlayViewModel: OverlayViewModel = OverlayViewModel(),
        poseSuggestionViewModel: PoseSuggestionViewModel = PoseSuggestionViewModel(),
        onRequestAICoaching: @escaping () async -> Void = {}
    ) {
        _viewModel = State(initialValue: viewModel)
        _overlayViewModel = State(initialValue: overlayViewModel)
        _poseSuggestionViewModel = State(initialValue: poseSuggestionViewModel)
        self.onRequestAICoaching = onRequestAICoaching
    }

    var body: some View {
        ZStack {
            // Camera preview
            CameraPreviewView(previewLayer: viewModel.previewLayer)
                .ignoresSafeArea()

            // Skeleton pose overlay
            SkeletonOverlay(pose: overlayViewModel.currentPose)
                .ignoresSafeArea()

            // Coaching overlay
            CoachingOverlay(viewModel: overlayViewModel)

            // Pose suggestion — top-left reference dáng that fits the scene
            VStack {
                HStack {
                    PoseSuggestionCard(viewModel: poseSuggestionViewModel)
                    Spacer()
                }
                Spacer()
            }
            .padding(Spacing.m)

            // Bottom toolbar
            VStack {
                Spacer()
                BottomToolbar(
                    isCapturing: viewModel.isCapturing,
                    isReadyToCapture: overlayViewModel.isReadyToCapture,
                    isRequestingAI: isRequestingAI,
                    onCapture: handleCapture,
                    onRequestAI: handleRequestAI
                )
            }
        }
        .task { await viewModel.onAppear() }
        .sheet(isPresented: $showReview) {
            if let image = capturedImage, let coaching = coachingResponse {
                ReviewScreen(originalImage: image, coaching: coaching)
            }
        }
        .overlay {
            if viewModel.permissionStatus == .denied {
                PermissionView(type: .camera, onOpenSettings: viewModel.openSettings)
            }
        }
        .alert(
            "Camera error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private func handleRequestAI() {
        guard !isRequestingAI else { return }
        Task {
            isRequestingAI = true
            await onRequestAICoaching()
            isRequestingAI = false
        }
    }

    private func handleCapture() {
        Task {
            if let image = await viewModel.capture() {
                let response = overlayViewModel.lastResponse ?? .placeholder
                let source = overlayViewModel.lastResponse == nil ? "placeholder" : "lastResponse"
                cameraScreenLogger.info(
                    "handleCapture coachingResponse source=\(source, privacy: .public) mainCue=\(response.mainCue, privacy: .public) score=\(response.score) ready=\(response.isReadyToCapture) overlayCount=\(response.overlay.count)"
                )
                #if DEBUG
                print("[CameraScreen] handleCapture coachingResponse source=\(source) mainCue=\"\(response.mainCue)\" score=\(response.score) ready=\(response.isReadyToCapture) overlayCount=\(response.overlay.count)")
                #endif
                capturedImage = image
                coachingResponse = response
                showReview = true
            }
        }
    }
}
