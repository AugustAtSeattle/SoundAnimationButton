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
    let button = UIButton(type: .system)
    var canvas : WaveformLiveCanvasWrapper?
    
    private var liveConfiguration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .green, width: 2, spacing: 1)))


    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupAnimationView()
    }
    
    // setup button function
    func setupButton() {
        
        button.setTitle("Record", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.center = view.center
        button.backgroundColor = .red
        // set button round
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        // set button shadow
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 5, height: 5)
//        button.layer.shadowRadius = 5
//        button.layer.shadowOpacity = 1.0
        button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func setupAnimationView() {

        canvas = WaveformLiveCanvasWrapper(
            configuration: liveConfiguration,
            renderer: CircularWaveformRenderer(kind: .ring(0.7)),
            shouldDrawSilencePadding: true
        )

        let hostingController = UIHostingController(rootView: canvas)
        guard let viewToAdd = hostingController.view else { return }
        viewToAdd.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewToAdd)

        // Set constraints for viewToAdd
        NSLayoutConstraint.activate([
            viewToAdd.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            viewToAdd.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            viewToAdd.widthAnchor.constraint(equalToConstant: 100),
            viewToAdd.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Set the canvas view to be round
        viewToAdd.layer.cornerRadius = 50 // Half of the width and height
        viewToAdd.clipsToBounds = true
        view.bringSubviewToFront(button)
    }


    
    @objc func recordTapped() {
        guard let canvas = canvas else {
            return
        }
        canvas.recordTapped()
    }
    
}

