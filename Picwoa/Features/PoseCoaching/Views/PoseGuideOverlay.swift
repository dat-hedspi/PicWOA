import SwiftUI

struct PoseGuideOverlay: View {
    let activePose: PoseSuggestion?
    let coachingCue: String?    // from AICoachingResponse if available
    let hintIndex: Int          // cycles through pose.coachingHints

    var body: some View {
        if let pose = activePose {
            ZStack {
                // Full-screen bounding box guide
                PersonBoundingBox(
                    pose: pose.referencePoints,
                    borderColor: Color.picAccent.opacity(0.7),
                    borderWidth: 2,
                    cornerRadius: 20,
                    showGlow: true,
                    dashed: true
                )
                .ignoresSafeArea()

                // Hint banner pinned to top
                VStack {
                    PoseHintBanner(
                        poseName: pose.name,
                        hint: effectiveHint(for: pose)
                    )
                    .padding(.top, 60)
                    .padding(.horizontal, Spacing.m)
                    Spacer()
                }
            }
            .transition(.opacity)
            .animation(Anim.normal, value: pose.id)
        }
    }

    // AI coaching cue takes precedence; fall back to pose's built-in hints
    private func effectiveHint(for pose: PoseSuggestion) -> String {
        if let cue = coachingCue { return cue }
        guard !pose.coachingHints.isEmpty else { return "" }
        return pose.coachingHints[hintIndex % pose.coachingHints.count]
    }
}

private struct PoseHintBanner: View {
    let poseName: String
    let hint: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "figure.stand")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.picAccent)

            VStack(alignment: .leading, spacing: 1) {
                Text(poseName)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.picAccent)
                if !hint.isEmpty {
                    Text(hint)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.picTextPrimary)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().stroke(Color.picAccent.opacity(0.4), lineWidth: 1))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PoseGuideOverlay(
            activePose: PoseSuggestion.poses(for: .outdoor).first,
            coachingCue: nil,
            hintIndex: 0
        )
    }
}
