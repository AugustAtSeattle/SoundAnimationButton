//
//  ViewController.swift
//  AudioAnimation2
//
//  Created by Sailor on 12/29/23.
//

import UIKit
import DSWaveformImage
import DSWaveformImageViews
import SwiftUI

class ViewController: UIViewController {
    let audioRecorder = AudioRecorder()
    // move button init here
    let button = UIButton(type: .system)
    
    private var liveConfiguration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .green, width: 2, spacing: 1)))


    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecorder.setupRecorder()
        setupButton()
        setupAnimationView()
    }
    
    // setup button function
    func setupButton() {
        button.setTitle("Record", for: .normal)
        button.sizeToFit()
        button.center = view.center
        
        button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func setupAnimationView() {

        let canvas = WaveformLiveCanvasWrapper(
            audioRecorder: audioRecorder,
            configuration: liveConfiguration,
            renderer: CircularWaveformRenderer(kind: .ring(0.8)),
            shouldDrawSilencePadding: true
        )

        let hostingController = UIHostingController(rootView: canvas)
        guard let viewToAdd = hostingController.view else { return }
        viewToAdd.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewToAdd)

        // Set constraints for viewToAdd
        NSLayoutConstraint.activate([
            viewToAdd.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            viewToAdd.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            viewToAdd.widthAnchor.constraint(equalToConstant: 100),
            viewToAdd.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Set the canvas view to be round
        viewToAdd.layer.cornerRadius = 50 // Half of the width and height
        viewToAdd.clipsToBounds = true
    }


    
    @objc func recordTapped() {
        audioRecorder.startRecording()
    }
    
}

