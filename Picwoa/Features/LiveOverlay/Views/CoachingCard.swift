import SwiftUI

struct CoachingCard: View {
    let message: String
    let direction: Direction?
    let isReady: Bool
    let eyebrow: String
    let onTap: () -> Void

    init(
        message: String,
        direction: Direction?,
        isReady: Bool,
        eyebrow: String? = nil,
        onTap: @escaping () -> Void = {}
    ) {
        self.message = message
        self.direction = direction
        self.isReady = isReady
        self.eyebrow = eyebrow ?? (isReady ? "Sẵn sàng chụp" : "Bước tiếp theo")
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.s) {
            if let direction {
                DirectionArrow(direction: direction)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(eyebrow)
                    .font(.picCaption)
                    .foregroundStyle(isReady ? Color.picSuccess : Color.picTextSecondary)
                Text(message)
                    .font(.picCoaching)
                    .foregroundStyle(isReady ? Color.picSuccess : Color.picTextPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }

                Spacer(minLength: Spacing.m)

                if !isReady {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.picAccent)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Circle())
                        .accessibilityLabel("Gợi ý AI")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(RoundedRectangle(cornerRadius: Radius.xl))
        }
        .padding(.horizontal, Spacing.l)
        .padding(.vertical, Spacing.m)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
        .buttonStyle(.plain)
    }
}
