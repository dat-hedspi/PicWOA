import SwiftUI

struct PoseSuggestionStrip: View {
    let poses: [PoseSuggestion]
    let activePose: PoseSuggestion?
    let onSelect: (PoseSuggestion) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(poses) { pose in
                    PoseThumbnailCard(
                        pose: pose,
                        isSelected: activePose?.id == pose.id
                    )
                    .onTapGesture { onSelect(pose) }
                }
            }
            .padding(.horizontal, Spacing.m)
            .padding(.vertical, 6)
        }
    }
}

private struct PoseThumbnailCard: View {
    let pose: PoseSuggestion
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.picSurface.opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isSelected ? Color.picAccent : Color.white.opacity(0.15),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )

                PersonBoundingBox(
                    pose: pose.referencePoints,
                    borderColor: isSelected ? Color.picAccent : Color.white.opacity(0.5),
                    borderWidth: 1.5,
                    cornerRadius: 8,
                    showGlow: false,
                    dashed: isSelected
                )
                .padding(8)
            }
            .frame(width: 62, height: 78)

            Text(pose.name)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(isSelected ? .picAccent : .picTextSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 62)
        }
        .animation(Anim.normal, value: isSelected)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            Spacer()
            PoseSuggestionStrip(
                poses: PoseSuggestion.poses(for: .outdoor),
                activePose: PoseSuggestion.poses(for: .outdoor).first,
                onSelect: { _ in }
            )
        }
    }
}
