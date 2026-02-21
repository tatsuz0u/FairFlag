// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ExampleShared",
    platforms: [
        .iOS(.v14),
        .watchOS(.v7),
        .tvOS(.v14),
        .macOS(.v11),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "ExampleShared",
            targets: ["ExampleShared"]
        ),
        .library(
            name: "ExampleSnapshotSupport",
            targets: ["ExampleSnapshotSupport"]
        ),
    ],
    dependencies: [
        .package(path: "../../"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.18.9"),
    ],
    targets: [
        .target(
            name: "ExampleShared",
            dependencies: [
                .product(name: "FairFlag", package: "FairFlag"),
            ]
        ),
        .target(
            name: "ExampleSnapshotSupport",
            dependencies: [
                "ExampleShared",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ]
)
