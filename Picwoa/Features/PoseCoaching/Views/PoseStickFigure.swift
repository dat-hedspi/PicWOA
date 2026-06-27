import SwiftUI

struct PoseStickFigure: View {
    let pose: PoseObservation
    var lineColor: Color = .white.opacity(0.7)
    var jointColor: Color = .white
    var lineWidth: CGFloat = 2
    var jointRadius: CGFloat = 3

    var body: some View {
        Canvas { context, size in
            drawBones(in: context, size: size)
            drawJoints(in: context, size: size)
        }
    }

    private func drawBones(in context: GraphicsContext, size: CGSize) {
        let connections: [(CGPoint?, CGPoint?)] = [
            (pose.head, pose.neck),
            (pose.neck, pose.leftShoulder),
            (pose.neck, pose.rightShoulder),
            (pose.leftShoulder, pose.hip),
            (pose.rightShoulder, pose.hip),
            (pose.hip, pose.leftKnee),
            (pose.hip, pose.rightKnee),
            (pose.leftKnee, pose.leftFoot),
            (pose.rightKnee, pose.rightFoot),
        ]
        var path = Path()
        for (a, b) in connections {
            guard let a, let b else { continue }
            path.move(to: pt(a, size))
            path.addLine(to: pt(b, size))
        }
        context.stroke(path, with: .color(lineColor), lineWidth: lineWidth)
    }

    private func drawJoints(in context: GraphicsContext, size: CGSize) {
        let joints: [CGPoint?] = [
            pose.head, pose.neck,
            pose.leftShoulder, pose.rightShoulder,
            pose.hip, pose.leftKnee, pose.rightKnee,
            pose.leftFoot, pose.rightFoot,
        ]
        for joint in joints.compactMap({ $0 }) {
            let center = pt(joint, size)
            let rect = CGRect(
                x: center.x - jointRadius, y: center.y - jointRadius,
                width: jointRadius * 2, height: jointRadius * 2
            )
            context.fill(Path(ellipseIn: rect), with: .color(jointColor))
        }
    }

    private func pt(_ point: CGPoint, _ size: CGSize) -> CGPoint {
        CGPoint(x: point.x * size.width, y: point.y * size.height)
    }
}
