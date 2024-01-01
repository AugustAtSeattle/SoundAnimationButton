//
//  ViewController.swift
//  AudioAnimation2
//
//  Created by Sailor on 12/29/23.
//
import UIKit
import SwiftUI
import DSWaveformImage
import DSWaveformImageViews
class ViewController: UIViewController {
    var audioRecorder = AudioRecorder()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioAnimationView()
    }

    func setupAudioAnimationView() {
        let configuration = Waveform.Configuration(
            style: .striped(.init(color: .green, width: 2, spacing: 1))
        )
        let renderer = CircularWaveformRenderer(kind: .ring(0.7))

        let audioView = AudioAnimationView(
            audioRecorder: audioRecorder,
            configuration: configuration,
            renderer: renderer
        )

        let hostingController = UIHostingController(rootView: audioView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hostingController.view.widthAnchor.constraint(equalToConstant: 200),
            hostingController.view.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
