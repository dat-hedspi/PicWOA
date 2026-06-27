import SwiftUI

struct CoachingOverlay: View {
    let viewModel: OverlayViewModel
    let onRequestRefinement: () -> Void

    init(
        viewModel: OverlayViewModel,
        onRequestRefinement: @escaping () -> Void = {}
    ) {
        self.viewModel = viewModel
        self.onRequestRefinement = onRequestRefinement
    }

    var body: some View {
        VStack {
            Spacer()
            if !viewModel.personDetected {
                CoachingCard(
                    message: "Bước vào khung hình",
                    direction: nil,
                    isReady: false,
                    eyebrow: "Vào khung hình"
                )
                .padding(.bottom, 100)
            } else if viewModel.showOverlay, let response = viewModel.currentResponse {
                CoachingCard(
                    message: response.mainCue,
                    direction: response.primaryDirection,
                    isReady: viewModel.isReadyToCapture,
                    onTap: onRequestRefinement
                )
                .padding(.horizontal, Spacing.m)
                .padding(.bottom, 100)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(Anim.normal, value: viewModel.currentResponse?.mainCue)
    }
}
