// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Osprey",
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Osprey",
            targets: ["Osprey"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Osprey"
        ),
        .testTarget(
            name: "OspreyTests",
            dependencies: ["Osprey"]),
    ],
    swiftLanguageVersions: [.v5]
)
