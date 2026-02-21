//
//  SnapshotTests.swift
//  SnapshotTests
//
//  Created by Tatsuzo Araki on 2026/02/21.
//

import SwiftUI
import Testing
import ExampleShared
import SnapshotTesting
import ExampleSnapshotSupport

@Suite(.snapshots(record: SnapshotTestingHelper.recordMode))
struct SnapshotTests {
    @Test func fairFlagPreviews() async throws {
        try await assertPreviewSnapshots(FairFlag_Previews.self)
    }
}
