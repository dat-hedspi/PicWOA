import Vision
import AVFoundation

actor VisionEngine: PoseProvider {
    static let shared = VisionEngine()

    nonisolated let poseStream: AsyncStream<PoseObservation?>
    nonisolated let personDetectedStream: AsyncStream<Bool>

    private let poseContinuation: AsyncStream<PoseObservation?>.Continuation
    private let personContinuation: AsyncStream<Bool>.Continuation

    init() {
        var poseContinuation: AsyncStream<PoseObservation?>.Continuation!
        self.poseStream = AsyncStream { continuation in
            poseContinuation = continuation
        }
        self.poseContinuation = poseContinuation

        var personContinuation: AsyncStream<Bool>.Continuation!
        self.personDetectedStream = AsyncStream { continuation in
            personContinuation = continuation
        }
        self.personContinuation = personContinuation
    }

    func process(sampleBuffer: CMSampleBuffer) {
        let pose = PoseDetector.detect(in: sampleBuffer)
        poseContinuation.yield(pose)

        if pose != nil {
            personContinuation.yield(true)
        } else {
            personContinuation.yield(PersonDetector.detect(in: sampleBuffer))
        }
    }
}
