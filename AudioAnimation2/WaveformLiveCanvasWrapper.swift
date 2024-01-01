//
//  WaveformLiveCanvasWrapper.swift
//  AudioAnimation2
//
//  Created by Sailor on 12/30/23.
//

import Foundation
import SwiftUI
import DSWaveformImage
import DSWaveformImageViews

struct WaveformLiveCanvasWrapper: View {
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    let configuration: Waveform.Configuration
    let renderer: CircularWaveformRenderer
    let shouldDrawSilencePadding: Bool

    var body: some View {
        WaveformLiveCanvas(
            samples: audioRecorder.samples,
            configuration: configuration,
            renderer: renderer,
            shouldDrawSilencePadding: shouldDrawSilencePadding
        )
        // You may add additional modifiers or logic here if needed
    }
    
    func recordTapped() {
        if audioRecorder.isRecording {
            audioRecorder.stopRecording()
        } else {
            audioRecorder.startRecording()
        }
    }
}
