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
            style: .striped(.init(color: .red, width: 2, spacing: 1))
        )
        let renderer = CircularWaveformRenderer(kind: .ring(0.7))

        let audioView = AudioAnimationView(
            audioRecorder: AudioRecorder(),
            configuration: configuration,
            renderer: renderer
        )

        // Use the reusable method to embed the SwiftUI view
        embedSwiftUIView(audioView, width: 200, height: 300)
    }
}

extension UIViewController {
    func embedSwiftUIView<T: View>(_ swiftUIView: T, width: CGFloat = 200, height: CGFloat = 200) {
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hostingController.view.widthAnchor.constraint(equalToConstant: width),
            hostingController.view.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
