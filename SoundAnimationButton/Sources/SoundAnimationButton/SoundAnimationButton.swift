import UIKit
import SwiftUI
import DSWaveformImage
//import DSWaveformImageViews

public class SoundAnimationButton: UIView {
    // Configuration struct for customizing the button
    public struct Configuration {
        let color: UIColor
        let width: CGFloat
        let height: CGFloat
        let xOffset: CGFloat
        let yOffset: CGFloat

        // Default configuration
        public static let defaultConfig = Configuration(
            color: .red,
            width: 200,
            height: 200,
            xOffset: 300,
            yOffset: 500
        )

        public init(color: UIColor, width: CGFloat, height: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
            self.color = color
            self.width = width
            self.height = height
            self.xOffset = xOffset
            self.yOffset = yOffset
        }
    }

    private let config: Configuration
    weak var parentViewController: UIViewController?

    public init(parentViewController: UIViewController, configuration: Configuration = Configuration.defaultConfig) {
        self.parentViewController = parentViewController
        self.config = configuration
        super.init(frame: .zero)
        setupAudioAnimationView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAudioAnimationView() {
        guard let parentVC = parentViewController else { return }
        
        let configuration = Waveform.Configuration(
            style: .striped(.init(color: .red, width: 2, spacing: 1))
        )
        let renderer = CircularWaveformRenderer(kind: .ring(0.7))
        let audioView = AudioAnimationView(
            audioRecorder: AudioRecorder(),
            configuration: configuration,
            renderer: renderer
        )
        
        // Embedding the SwiftUI view directly
        let hostingController = UIHostingController(rootView: audioView)
        parentVC.addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        parentVC.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: parentVC)

        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: parentVC.view.centerXAnchor, constant: config.xOffset),
            hostingController.view.centerYAnchor.constraint(equalTo: parentVC.view.centerYAnchor, constant: config.yOffset),
            hostingController.view.widthAnchor.constraint(equalToConstant: config.width),
            hostingController.view.heightAnchor.constraint(equalToConstant: config.height)
        ])
    }
}
