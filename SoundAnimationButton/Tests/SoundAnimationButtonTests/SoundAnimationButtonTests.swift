import XCTest
@testable import SoundAnimationButton
@testable import DSWaveformImage
//@testable import SCAudioManager

final class SoundAnimationButtonTests: XCTestCase {
    
    func testSoundAnimationButtonInitialization() throws {
        // Mock a view controller to pass to SoundAnimationButton
        let mockViewController = UIViewController()
        
        // Initialize SoundAnimationButton
        let button = SoundAnimationButton(parentViewController: mockViewController)
        
        // Test initial properties
        XCTAssertEqual(button.frame.size.width, 200, "Width should be initialized to 200")
        XCTAssertEqual(button.frame.size.height, 200, "Height should be initialized to 200")
        
        // Add more tests as needed...
    }

    // Add more test functions as required for different aspects of SoundAnimationButton
}
