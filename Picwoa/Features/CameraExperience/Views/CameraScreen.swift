import SwiftUI

struct CameraScreen: View {
    @State private var viewModel: CameraViewModel
    @State private var overlayViewModel: OverlayViewModel
    @State private var capturedImage: UIImage?
    @State private var coachingResponse: AICoachingResponse?
    @State private var showReview = false

    init(
        viewModel: CameraViewModel = CameraViewModel(),
        overlayViewModel: OverlayViewModel = OverlayViewModel(),
        onRequestCoachingRefinement: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: viewModel)
        _overlayViewModel = State(initialValue: overlayViewModel)
        self.onRequestCoachingRefinement = onRequestCoachingRefinement
    }

    private let onRequestCoachingRefinement: () -> Void

    var body: some View {
        ZStack {
            // Camera preview
            CameraPreviewView(previewLayer: viewModel.previewLayer)
                .ignoresSafeArea()

            // Skeleton pose overlay (user's actual detected pose)
            SkeletonOverlay(pose: overlayViewModel.currentPose)
                .ignoresSafeArea()

            // Reference guide overlay (selected target pose)
            PoseGuideOverlay(
                activePose: overlayViewModel.activePose,
                coachingCue: overlayViewModel.personDetected ? overlayViewModel.currentResponse?.mainCue : nil,
                hintIndex: overlayViewModel.poseHintIndex
            )

            // Coaching overlay
            CoachingOverlay(
                viewModel: overlayViewModel,
                onRequestRefinement: onRequestCoachingRefinement
            )

            // Bottom toolbar + pose suggestion strip
            VStack(spacing: 0) {
                Spacer()
                if !overlayViewModel.suggestedPoses.isEmpty {
                    PoseSuggestionStrip(
                        poses: overlayViewModel.suggestedPoses,
                        activePose: overlayViewModel.activePose,
                        onSelect: overlayViewModel.selectPose
                    )
                }
                BottomToolbar(
                    isCapturing: viewModel.isCapturing,
                    isReadyToCapture: overlayViewModel.isReadyToCapture,
                    onCapture: handleCapture
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

    private func handleCapture() {
        Task {
            if let image = await viewModel.capture() {
                capturedImage = image
                coachingResponse = overlayViewModel.lastResponse ?? .placeholder
                showReview = true
            }
        }
    }
}
