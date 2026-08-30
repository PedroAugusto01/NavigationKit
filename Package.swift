// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NavigationKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "NavigationKitCore", targets: ["NavigationKitCore"]),
        .library(name: "NavigationKit", targets: ["NavigationKit"]),
        .library(name: "NavigationKitMock", targets: ["NavigationKitMock"]),
    ],
    targets: [
        .target(name: "NavigationKitCore"),
        .target(name: "NavigationKit"),
        .target(name: "NavigationKitMock", dependencies: ["NavigationKit"]),
        .testTarget(name: "NavigationKitCoreTests", dependencies: ["NavigationKitCore"]),
        .testTarget(name: "NavigationKitTests", dependencies: ["NavigationKit", "NavigationKitMock"]),
    ]
)
