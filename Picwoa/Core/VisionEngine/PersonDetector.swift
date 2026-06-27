import Vision
import AVFoundation
import ImageIO

struct PersonDetector {
    private static let orientations: [CGImagePropertyOrientation] = [.right, .up, .left]

    static func detect(in sampleBuffer: CMSampleBuffer) -> Bool {
        for orientation in orientations where detect(in: sampleBuffer, orientation: orientation) {
            return true
        }
        return PoseDetector.detect(in: sampleBuffer) != nil
    }

    private static func detect(
        in sampleBuffer: CMSampleBuffer,
        orientation: CGImagePropertyOrientation
    ) -> Bool {
        let request = VNDetectHumanRectanglesRequest()
        request.upperBodyOnly = false
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: orientation)

        do {
            try handler.perform([request])
        } catch {
            return false
        }

        return request.results?.contains { $0.confidence >= 0.35 } ?? false
    }
}
