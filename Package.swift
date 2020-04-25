// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Osprey",
    products: [
        .library(
            name: "Osprey",
            targets: ["Osprey"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JuanjoArreola/ShallowPromises", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "Osprey",
            dependencies: ["ShallowPromises"]),
        .testTarget(
            name: "OspreyTests",
            dependencies: ["Osprey"]),
    ]
)
