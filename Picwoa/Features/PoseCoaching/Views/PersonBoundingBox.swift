import SwiftUI

struct PersonBoundingBox: View {
    let pose: PoseObservation
    var borderColor: Color = Color.picAccent
    var borderWidth: CGFloat = 2
    var cornerRadius: CGFloat = 16
    var showGlow: Bool = false
    var dashed: Bool = false

    var body: some View {
        GeometryReader { geo in
            if let rect = boundingRect(in: geo.size) {
                let shape = RoundedRectangle(cornerRadius: cornerRadius)
                    .path(in: rect)

                Canvas { context, _ in
                    if showGlow {
                        // Outer glow
                        context.addFilter(.blur(radius: 8))
                        context.stroke(shape, with: .color(borderColor.opacity(0.45)), lineWidth: borderWidth + 4)
                    }

                    if dashed {
                        context.stroke(
                            shape,
                            with: .color(borderColor),
                            style: StrokeStyle(lineWidth: borderWidth, dash: [10, 6])
                        )
                    } else {
                        context.stroke(shape, with: .color(borderColor), lineWidth: borderWidth)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    // Returns CGRect in view coordinates from keypoints, with padding
    private func boundingRect(in size: CGSize) -> CGRect? {
        let pts: [CGPoint] = [
            pose.head, pose.neck,
            pose.leftShoulder, pose.rightShoulder,
            pose.hip,
            pose.leftKnee, pose.rightKnee,
            pose.leftFoot, pose.rightFoot,
        ].compactMap { $0 }

        guard !pts.isEmpty else { return nil }

        let xs = pts.map { $0.x }
        let ys = pts.map { $0.y }
        let minX = xs.min()!, maxX = xs.max()!
        let minY = ys.min()!, maxY = ys.max()!

        // 8% horizontal padding, 4% vertical padding
        let padX: CGFloat = 0.08
        let padY: CGFloat = 0.04

        let left   = max(0, (minX - padX)) * size.width
        let top    = max(0, (minY - padY)) * size.height
        let right  = min(1, (maxX + padX)) * size.width
        let bottom = min(1, (maxY + padY)) * size.height

        guard right > left, bottom > top else { return nil }
        return CGRect(x: left, y: top, width: right - left, height: bottom - top)
    }
}
