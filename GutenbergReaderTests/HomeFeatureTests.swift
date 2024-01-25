//
//  HomeFeatureTests.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 24.01.2024.
//

import XCTest
@testable import GutenbergReader
import ComposableArchitecture

@MainActor
final class HomeFeatureTests: XCTestCase {
    var store: TestStore<HomeFeature.State, HomeFeature.Action>!
    override func setUpWithError() throws {
        self.store = TestStore(initialState: HomeFeature.State(), reducer: {
            HomeFeature()
        })
    }

    func testChangeTab() async {
        await store.send(.changeTab(.downloads)) { state in
            state.appTab = .downloads
        }

        await store.send(.changeTab(.recentlyAdded)) { state in
            state.appTab = .recentlyAdded
        }
    }
}
