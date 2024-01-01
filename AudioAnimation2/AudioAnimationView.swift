//
//  AudioAnimationView.swift
//  AudioAnimation2
//
//  Created by Sailor on 1/1/24.
//
import SwiftUI
import DSWaveformImage
import DSWaveformImageViews

struct AudioAnimationView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    let configuration: Waveform.Configuration
    let renderer: CircularWaveformRenderer
    var width: CGFloat
    var height: CGFloat
    var recordImageName: String
    var stopImageName: String

    init(audioRecorder: AudioRecorder,
         configuration: Waveform.Configuration,
         renderer: CircularWaveformRenderer,
         width: CGFloat = 100,
         height: CGFloat = 100,
         recordImageName: String = "record.circle.fill",
         stopImageName: String = "stop.circle.fill") {
        self.audioRecorder = audioRecorder
        self.configuration = configuration
        self.renderer = renderer
        self.width = width
        self.height = height
        self.recordImageName = recordImageName
        self.stopImageName = stopImageName
    }

    var body: some View {
        ZStack {
            WaveformLiveCanvas(
                samples: audioRecorder.samples,
                configuration: configuration,
                renderer: renderer
            )
            .frame(width: width, height: height)

            Button(action: toggleRecording) {
                 Image(systemName: audioRecorder.isRecording ? stopImageName : recordImageName)
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .foregroundColor(.white)
                     .padding(2)
                     .background(Circle().fill(Color.red))
             }
             .frame(width: width * 0.6, height: height * 0.6)
        }
    }

    private func toggleRecording() {
        if audioRecorder.isRecording {
            audioRecorder.stopRecording()
        } else {
            audioRecorder.startRecording()
        }
    }
}
