import Foundation
import CoreGraphics

struct PoseSuggestion: Identifiable, Sendable {
    let id: String
    let name: String
    let scene: SceneContext
    let referencePoints: PoseObservation
    let coachingHints: [String]

    static func poses(for scene: SceneContext) -> [PoseSuggestion] {
        switch scene {
        case .outdoor: return outdoorPoses
        case .indoor:  return indoorPoses
        case .unknown: return outdoorPoses + indoorPoses
        }
    }
}

// MARK: - Outdoor poses

private let outdoorPoses: [PoseSuggestion] = [sCurve, powerPose, ruleOfThirds]

private let sCurve = PoseSuggestion(
    id: "s_curve",
    name: "S-Curve",
    scene: .outdoor,
    referencePoints: PoseObservation(
        head:          CGPoint(x: 0.52, y: 0.08),
        neck:          CGPoint(x: 0.52, y: 0.17),
        leftShoulder:  CGPoint(x: 0.40, y: 0.28),
        rightShoulder: CGPoint(x: 0.64, y: 0.26),
        hip:           CGPoint(x: 0.46, y: 0.52),
        leftKnee:      CGPoint(x: 0.40, y: 0.70),
        rightKnee:     CGPoint(x: 0.58, y: 0.72),
        leftFoot:      CGPoint(x: 0.36, y: 0.90),
        rightFoot:     CGPoint(x: 0.60, y: 0.90),
        confidence: 1, timestamp: 0
    ),
    coachingHints: [
        "Dồn trọng lượng lên một chân",
        "Đẩy hông sang một bên nhẹ",
        "Thả lỏng vai, đừng cứng"
    ]
)

private let powerPose = PoseSuggestion(
    id: "power_pose",
    name: "Power Pose",
    scene: .outdoor,
    referencePoints: PoseObservation(
        head:          CGPoint(x: 0.50, y: 0.07),
        neck:          CGPoint(x: 0.50, y: 0.16),
        leftShoulder:  CGPoint(x: 0.34, y: 0.28),
        rightShoulder: CGPoint(x: 0.66, y: 0.28),
        hip:           CGPoint(x: 0.50, y: 0.50),
        leftKnee:      CGPoint(x: 0.38, y: 0.70),
        rightKnee:     CGPoint(x: 0.62, y: 0.70),
        leftFoot:      CGPoint(x: 0.30, y: 0.90),
        rightFoot:     CGPoint(x: 0.70, y: 0.90),
        confidence: 1, timestamp: 0
    ),
    coachingHints: [
        "Hai chân mở rộng ngang vai",
        "Ngẩng đầu, mắt nhìn thẳng",
        "Vai mở, ngực hướng về camera"
    ]
)

private let ruleOfThirds = PoseSuggestion(
    id: "rule_of_thirds",
    name: "Rule of 1/3",
    scene: .outdoor,
    referencePoints: PoseObservation(
        head:          CGPoint(x: 0.62, y: 0.08),
        neck:          CGPoint(x: 0.62, y: 0.17),
        leftShoulder:  CGPoint(x: 0.50, y: 0.28),
        rightShoulder: CGPoint(x: 0.74, y: 0.28),
        hip:           CGPoint(x: 0.62, y: 0.52),
        leftKnee:      CGPoint(x: 0.56, y: 0.70),
        rightKnee:     CGPoint(x: 0.68, y: 0.70),
        leftFoot:      CGPoint(x: 0.52, y: 0.90),
        rightFoot:     CGPoint(x: 0.70, y: 0.90),
        confidence: 1, timestamp: 0
    ),
    coachingHints: [
        "Đứng lệch sang 1/3 khung hình",
        "Để không gian trống phía trước mặt",
        "Nhìn vào điểm xa ngoài khung"
    ]
)

// MARK: - Indoor poses

private let indoorPoses: [PoseSuggestion] = [portraitClose, seatedRelaxed, overShoulder]

private let portraitClose = PoseSuggestion(
    id: "portrait_close",
    name: "Portrait",
    scene: .indoor,
    referencePoints: PoseObservation(
        head:          CGPoint(x: 0.50, y: 0.14),
        neck:          CGPoint(x: 0.50, y: 0.28),
        leftShoulder:  CGPoint(x: 0.30, y: 0.50),
        rightShoulder: CGPoint(x: 0.70, y: 0.50),
        hip:           nil,
        leftKnee:      nil,
        rightKnee:     nil,
        leftFoot:      nil,
        rightFoot:     nil,
        confidence: 1, timestamp: 0
    ),
    coachingHints: [
        "Hơi nghiêng đầu một chút",
        "Nhìn thẳng vào camera",
        "Giữ cằm hơi cúi xuống nhẹ"
    ]
)

private let seatedRelaxed = PoseSuggestion(
    id: "seated_relaxed",
    name: "Seated",
    scene: .indoor,
    referencePoints: PoseObservation(
        head:          CGPoint(x: 0.50, y: 0.10),
        neck:          CGPoint(x: 0.50, y: 0.20),
        leftShoulder:  CGPoint(x: 0.36, y: 0.32),
        rightShoulder: CGPoint(x: 0.64, y: 0.32),
        hip:           CGPoint(x: 0.50, y: 0.58),
        leftKnee:      CGPoint(x: 0.36, y: 0.72),
        rightKnee:     CGPoint(x: 0.64, y: 0.72),
        leftFoot:      CGPoint(x: 0.30, y: 0.90),
        rightFoot:     CGPoint(x: 0.70, y: 0.90),
        confidence: 1, timestamp: 0
    ),
    coachingHints: [
        "Ngồi thẳng lưng, không khom",
        "Đặt tay tự nhiên lên đùi",
        "Để chân chéo nhẹ hoặc song song"
    ]
)

private let overShoulder = PoseSuggestion(
    id: "over_shoulder",
    name: "Over Shoulder",
    scene: .indoor,
    referencePoints: PoseObservation(
        head:          CGPoint(x: 0.56, y: 0.09),
        neck:          CGPoint(x: 0.53, y: 0.19),
        leftShoulder:  CGPoint(x: 0.36, y: 0.30),
        rightShoulder: CGPoint(x: 0.64, y: 0.28),
        hip:           CGPoint(x: 0.48, y: 0.54),
        leftKnee:      CGPoint(x: 0.42, y: 0.72),
        rightKnee:     CGPoint(x: 0.58, y: 0.72),
        leftFoot:      CGPoint(x: 0.38, y: 0.90),
        rightFoot:     CGPoint(x: 0.60, y: 0.90),
        confidence: 1, timestamp: 0
    ),
    coachingHints: [
        "Quay lưng về camera, đầu ngoái lại",
        "Mắt nhìn qua vai về phía camera",
        "Giữ vai thả lỏng, không co rút"
    ]
)
