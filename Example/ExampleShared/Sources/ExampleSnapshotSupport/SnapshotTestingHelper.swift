//
//  SnapshotTestingHelper.swift
//  SnapshotTests
//
//  Created by Tatsuzo Araki on 2026/02/21.
//

import SwiftUI
import Testing
import ExampleShared
import SnapshotTesting

public enum SnapshotTestingHelper {
    public static let recordMode: SnapshotTestingConfiguration.Record = .missing
    public static let standardPrecision: Float = 1
    public static let perceptualPrecision: Float = 0.95
}

@MainActor
public func assertPreviewSnapshots<Provider: PreviewProvider>(
    _ target: Provider.Type,
    isRequiredToPass: Bool = true,
    precision: Float = SnapshotTestingHelper.standardPrecision,
    perceptualPrecision: Float = SnapshotTestingHelper.perceptualPrecision,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) throws {
    for preview in Provider._allPreviews {
        let customName = [
            String(describing: target),
            preview.displayName,
            currentDeviceModel()
        ]
        .compactMap { $0 }
        .joined(separator: "_")

        #if os(iOS) || os(tvOS)
        let errorDescription = verifySnapshot(
            of: preview.content,
            as: .image(
                precision: precision,
                perceptualPrecision: perceptualPrecision,
                layout: .init(preview: preview),
                traits: .init(userInterfaceStyle: .light)
            ),
            named: customName,
            file: file,
            testName: testName,
            line: line
        )
        #else
        let errorDescription = verifySnapshot(
            of: preview.content,
            as: sanitizedDescriptionSnapshot(),
            named: customName,
            file: file,
            testName: testName,
            line: line
        )
        #endif

        if let errorDescription, isRequiredToPass || SnapshotTestingHelper.recordMode == .all {
            Issue.record(.init(rawValue: errorDescription))
        }
    }
}

@MainActor
private func currentDeviceModel() -> String {
    #if os(macOS)
    "Mac"
    #elseif os(tvOS)
    "TV"
    #elseif os(watchOS)
    "Watch"
    #elseif os(visionOS)
    "Vision"
    #elseif os(iOS)
    UIDevice.current.userInterfaceIdiom == .phone ? "iPhone" : "iPad"
    #endif
}

private func sanitizedDescriptionSnapshot() -> Snapshotting<AnyView, String> {
    let sanitizers: [(pattern: String, replacement: String)] = [
        (#"0x[0-9A-Fa-f]{6,}"#, "0xADDR"),
        (#"(view|time|phase|transaction|modifier): #\d+"#, "$1: #ID"),
        (#"\$[0-9A-Fa-f]+"#, "$CTX")
    ]
    return Snapshotting(
        pathExtension: "txt",
        diffing: .lines
    ) { value in
        sanitizers.reduce(String(describing: value)) { output, sanitizer in
            output.replacingOccurrences(
                of: sanitizer.pattern,
                with: sanitizer.replacement,
                options: .regularExpression
            )
        }
    }
}

extension SwiftUISnapshotLayout {
    @MainActor
    init(preview: _Preview) {
        self = switch preview.layout {
        case let .fixed(width, height): .fixed(width: width, height: height)
        default: .fixed(width: 1000, height: 1000)
        }
    }
}
