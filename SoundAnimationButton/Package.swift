// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SoundAnimationButton",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SoundAnimationButton",
            targets: ["SoundAnimationButton"]),
    ],
    dependencies: [
        .package(url: "https://github.com/dmrschmidt/DSWaveformImage.git", from: "14.2.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SoundAnimationButton",
            dependencies: ["SCAudioManager","DSWaveformImage"]),
        .systemLibrary(
            name: "SCAudioManager",
            path: "Sources/SCAudioManager",
            pkgConfig: "sc_audio_manager"
        ),
        .testTarget(
            name: "SoundAnimationButtonTests",
            dependencies: ["SoundAnimationButton"]),
    ]
)
