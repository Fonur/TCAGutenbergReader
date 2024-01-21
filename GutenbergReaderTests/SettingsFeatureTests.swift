//
//  SettingsFeatureTests.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 21.01.2024.
//

import XCTest
@testable import GutenbergReader
import ComposableArchitecture

@MainActor
final class SettingsFeatureTests: XCTestCase {
    var store: TestStore<SettingsFeature.State, SettingsFeature.Action>!
    override func setUpWithError() throws {
        store = TestStore(initialState: SettingsFeature.State(), reducer: {
            SettingsFeature()
        })
    }

    func testToggleThemeMode() async {
        store.exhaustivity = .off
        await self.store.send(.toggleThemeModeTapped(true)) { state in
            state.isDarkMode = true
        }
        await self.store.skipReceivedActions()
        await self.store.send(.toggleThemeModeTapped(false)) { state in
            state.isDarkMode = false
        }
        await self.store.skipReceivedActions()
    }

    func testSaveSettings() async {
        store.exhaustivity = .off
        await self.store.send(.toggleThemeModeTapped(true)) { state in
            state.isDarkMode = true
        }

        await self.store.receive(\.saveSettings) { _ in }

        await self.store.send(.toggleThemeModeTapped(false)) { state in
            state.isDarkMode = false
        }

        await self.store.receive(\.saveSettings) { _ in }
    }

    func testLoadSettings() async {
        store.exhaustivity = .off
        await self.store.send(.onAppear)
        await self.store.receive(\.loadSettings)

        self.store.assert { state in
            state.isDarkMode = true
        }
    }

    func testShowingAboutApp() async {
        await self.store.send(.showingAboutInfo(true)) { state in
            state.showingAboutInfo = true
        }

        await self.store.send(.showingAboutInfo(false)) { state in
            state.showingAboutInfo = false
        }
    }
}
