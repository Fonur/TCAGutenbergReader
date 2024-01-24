//
//  AppFeatureTests.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 19.01.2024.
//

import XCTest
import ComposableArchitecture
@testable import GutenbergReader

@MainActor
final class AppFeatureTests: XCTestCase {
    var store: TestStore<AppFeature.State, AppFeature.Action>!
    override func setUpWithError() throws {
        self.store = TestStore(initialState: AppFeature.State(), reducer: {
            AppFeature()
        })
    }

    override func tearDownWithError() throws {
        self.store = nil
    }
}
