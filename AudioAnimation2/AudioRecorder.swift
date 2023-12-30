//
//  AudioRecorder.swift
//  AudioAnimation2
//
//  Created by Sailor on 12/29/23.

import AVFoundation
import Combine

class AudioRecorder: ObservableObject {
    var audioEngine: AVAudioEngine?
    var audioFile: AVAudioFile?
    var isRecording = false
    @Published var samples: [Float] = []

    func setupRecorder() {
        audioEngine = AVAudioEngine()

        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return }

        let audioFilename = documentDirectory.appendingPathComponent("recording.m4a")

        do {
            audioFile = try AVAudioFile(forWriting: audioFilename, settings: audioEngine!.inputNode.outputFormat(forBus: 0).settings)
        } catch {
            print("Audio File setup failed: \(error)")
        }
    }

    func startRecording() {
        guard let audioEngine = audioEngine, !isRecording, let audioFile = audioFile else { return }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { [weak self] (buffer, _) in
            do {
                try audioFile.write(from: buffer)
                self?.extractSamples(from: buffer)
            } catch {
                print("Error writing to audio file: \(error)")
            }
        }

        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Audio Engine couldn't start: \(error)")
        }
    }

    func stopRecording() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        isRecording = false
    }
    
    private func extractSamples(from buffer: AVAudioPCMBuffer) {
        guard let floatChannelData = buffer.floatChannelData else { return }

        let channelCount = Int(buffer.format.channelCount)
        let length = Int(buffer.frameLength)

        var maxSample: Float = 0.01 // To avoid division by zero
        let noiseThreshold: Float = 0.1 // Define a threshold for environmental noise

        // Calculate the maximum sample value for normalization
        for channel in 0..<channelCount {
            for sampleIndex in 0..<length {
                maxSample = max(maxSample, abs(floatChannelData[channel][sampleIndex]))
            }
        }

        // Process each sample and adjust based on the noise threshold
        for channel in 0..<channelCount {
            for sampleIndex in 0..<length {
                let rawSample = floatChannelData[channel][sampleIndex]
                let normalizedSample = abs(rawSample) / maxSample

                // Dampen the animation for environmental noise
                let adjustedSample = normalizedSample < noiseThreshold ? 0 : normalizedSample
                let invertedSample = 1.0 - adjustedSample

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.samples.append(invertedSample)
                    if self.samples.count > 400 {
                        self.samples.removeFirst()
                    }
                }
            }
        }
    }
}
