//
//  AudioRecorder.swift
//  AudioAnimation2
//
//  Created by Sailor on 12/29/23.
class AudioRecorder: NSObject, ObservableObject, RecordingDelegate {
    @Published var samples: [Float] = []
    @Published var recordingTime: TimeInterval = 0
    @Published var isRecording: Bool = false {
        didSet {
            guard oldValue != isRecording else { return }
            isRecording ? startRecording() : stopRecording()
        }
    }

    private let audioManager: SCAudioManager

    override init() {
        audioManager = SCAudioManager()

        super.init()

        audioManager.prepareAudioRecording()
        audioManager.recordingDelegate = self
    }

    func startRecording() {
        samples = []
        audioManager.startRecording()
        isRecording = true
    }

    func stopRecording() {
        audioManager.stopRecording()
        isRecording = false
    }

    // MARK: - RecordingDelegate

    func audioManager(_ manager: SCAudioManager!, didAllowRecording flag: Bool) {}

    func audioManager(_ manager: SCAudioManager!, didFinishRecordingSuccessfully flag: Bool) {}

    let scaleFactor: CGFloat = 2.0
    func audioManager(_ manager: SCAudioManager!, didUpdateRecordProgress progress: CGFloat) {
        let power = manager.lastAveragePower() // Float
        let linear = 1 - pow(10, power / 20) // Result is Float
        let scaleFactor: Float = 2.0 // Convert scaleFactor to Float
        let scaledLinear = linear * scaleFactor
        samples.append(scaledLinear)
    }

    func audioManager2(_ manager: SCAudioManager!, didUpdateRecordProgress progress: CGFloat) {
        let linear = 1 - pow(10, manager.lastAveragePower() / 20)

        
//        let scaledLinear = (1 - pow(10, manager.lastAveragePower() / 20)) * scaleFactor // Experiment with scaleFactor
//        samples += [scaledLinear, scaledLinear, scaledLinear]

        
        // Here we add the same sample 3 times to speed up the animation.
        // Usually you'd just add the sample once.
        recordingTime = audioManager.currentRecordingTime
        print("linear: \(linear)")
        samples.append(linear)
//        samples += [linear, linear, linear]
    }
}
