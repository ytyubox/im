// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "im",
    products: [
        .library(name: "ImCore", targets: ["ImCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "im",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"),
            ]),
        .target(
            name: "ImCore"),
        .testTarget(
            name: "ImCoreTests",
            dependencies: ["ImCore"]),
        .testTarget(
            name: "ImTests",
            dependencies: ["im"]),
    ]
)
