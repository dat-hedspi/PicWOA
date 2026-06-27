import XCTest
@testable import Picwoa

final class RuleEngineTests: XCTestCase {

    let engine = RuleEngine()

    func testNoPersonInFrame() {
        let result = engine.evaluate(pose: .empty, scene: .outdoor)
        XCTAssertFalse(result.readyToCapture)
        XCTAssertTrue(result.issues.contains { $0.id == "no_person" })
    }

    func testChinDownRule() {
        let pose = PoseObservation(
            head: CGPoint(x: 0.5, y: 0.5),
            neck: CGPoint(x: 0.5, y: 0.62),
            leftShoulder: CGPoint(x: 0.35, y: 0.65),
            rightShoulder: CGPoint(x: 0.65, y: 0.65),
            hip: nil, leftKnee: nil, rightKnee: nil,
            leftFoot: nil, rightFoot: nil,
            confidence: 0.9, timestamp: 0
        )
        let result = engine.evaluate(pose: pose, scene: .outdoor)
        XCTAssertTrue(result.issues.contains { $0.id == "chin_down" })
    }

    func testReadyToCaptureWhenNoIssues() {
        let pose = PoseObservation(
            head: CGPoint(x: 0.5, y: 0.55),
            neck: CGPoint(x: 0.5, y: 0.60),
            leftShoulder: CGPoint(x: 0.38, y: 0.65),
            rightShoulder: CGPoint(x: 0.62, y: 0.65),
            hip: CGPoint(x: 0.5, y: 0.8),
            leftKnee: nil, rightKnee: nil,
            leftFoot: nil, rightFoot: nil,
            confidence: 0.95, timestamp: 0
        )
        let result = engine.evaluate(pose: pose, scene: .outdoor)
        XCTAssertTrue(result.readyToCapture, "Expected readyToCapture but got issues: \(result.issues.map(\.id))")
        XCTAssertEqual(result.framePosition, "center")
    }

    func testLeftShoulderLowRule() {
        let pose = PoseObservation(
            head: CGPoint(x: 0.5, y: 0.55),
            neck: CGPoint(x: 0.5, y: 0.60),
            leftShoulder: CGPoint(x: 0.35, y: 0.72),   // left lower
            rightShoulder: CGPoint(x: 0.65, y: 0.65),
            hip: nil, leftKnee: nil, rightKnee: nil,
            leftFoot: nil, rightFoot: nil,
            confidence: 0.9, timestamp: 0
        )
        let result = engine.evaluate(pose: pose, scene: .outdoor)
        XCTAssertTrue(result.issues.contains { $0.id == "left_shoulder_low" })
    }

    func testRightShoulderLowRule() {
        let result = engine.evaluate(
            pose: PoseAnalysisResult(chinAngle: 0, shoulderDelta: -0.08, torsoWidth: 0.24, frameCenterX: 0.5),
            scene: .outdoor
        )

        XCTAssertTrue(result.issues.contains { $0.id == "right_shoulder_low" })
    }

    func testTorsoFacingCameraRule() {
        let result = engine.evaluate(
            pose: PoseAnalysisResult(chinAngle: 0, shoulderDelta: 0, torsoWidth: 0.32, frameCenterX: 0.5),
            scene: .outdoor
        )

        XCTAssertTrue(result.issues.contains { $0.id == "torso_facing" })
    }

    func testBodyOffCenterRule() {
        let result = engine.evaluate(
            pose: PoseAnalysisResult(chinAngle: 0, shoulderDelta: 0, torsoWidth: 0.24, frameCenterX: 0.72),
            scene: .outdoor
        )

        XCTAssertTrue(result.issues.contains { $0.id == "off_center_left" })
        XCTAssertEqual(result.framePosition, "right")
    }

    func testTooFarRule() {
        let result = engine.evaluate(
            pose: PoseAnalysisResult(chinAngle: 0, shoulderDelta: 0, torsoWidth: 0.08, frameCenterX: 0.5),
            scene: .outdoor
        )

        XCTAssertTrue(result.issues.contains { $0.id == "too_far" })
    }

    func testTooCloseRule() {
        let result = engine.evaluate(
            pose: PoseAnalysisResult(chinAngle: 0, shoulderDelta: 0, torsoWidth: 0.56, frameCenterX: 0.5),
            scene: .outdoor
        )

        XCTAssertTrue(result.issues.contains { $0.id == "too_close" })
    }

    func testRulesPrioritized() {
        let pose = PoseObservation(
            head: CGPoint(x: 0.5, y: 0.5),   // chin down
            neck: CGPoint(x: 0.5, y: 0.62),
            leftShoulder: CGPoint(x: 0.35, y: 0.72),   // also left shoulder low
            rightShoulder: CGPoint(x: 0.65, y: 0.65),
            hip: nil, leftKnee: nil, rightKnee: nil,
            leftFoot: nil, rightFoot: nil,
            confidence: 0.9, timestamp: 0
        )
        let result = engine.evaluate(pose: pose, scene: .outdoor)
        XCTAssertGreaterThan(result.issues.count, 1)
        // First issue should have lower priority number (higher priority)
        let priorities = result.issues.map(\.priority)
        XCTAssertEqual(priorities, priorities.sorted())
    }
}
