//
//  AudioRecorder.swift
//  AudioAnimation2
//
//  Created by Sailor on 12/29/23.


import AVFoundation

class AudioRecorder {

    var audioEngine: AVAudioEngine?
    var audioFile: AVAudioFile?
    var isRecording = false
    var samples: [Float] = []

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
        print("start 1")
        guard let audioEngine = audioEngine, !isRecording, let audioFile = audioFile else { return }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            do {
                try audioFile.write(from: buffer)
                self.extractSamples(from: buffer)
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

        for channel in 0..<channelCount {
            for sampleIndex in 0..<length {
                let rawSample = floatChannelData[channel][sampleIndex]

                // Convert the raw sample to a decibel-like value
                let linearSample = 1 - pow(10, rawSample / 20)

                // Add the computed sample to the samples array
                samples.append(linearSample)
                
            }
        }
    }
}
