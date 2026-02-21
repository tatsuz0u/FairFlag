// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "FairFlag",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
        .macOS(.v10_15),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FairFlag", targets: ["FairFlag"])
    ],
    targets: [
        .target(
            name: "FairFlag",
            resources: [.process("Asset.xcassets")]
        )
    ]
)
