//
//  AudioRecorder.swift
//  AudioAnimation2
//
//  Created by Sailor on 12/29/23.

import SCAudioManager
import SwiftUI

@available(iOS 13.0, *)
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

    func audioManager(_ manager: SCAudioManager!, didUpdateRecordProgress progress: CGFloat) {
//        print(manager.lastAveragePower())
        let linear = 1 - pow(10, manager.lastAveragePower() / 60)

//        recordingTime = audioManager.currentRecordingTime
        print("linear: \(linear)")
        samples += [linear]
    }
}
