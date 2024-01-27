//
//  SettingsFeature.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 21.01.2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI



@Reducer
struct SettingsFeature {
    struct State: Equatable {
        var themeMode: ThemeMode = .defaultTheme
        var showingAboutInfo = false
    }

    enum Action {
        case toggleThemeModeTapped(ThemeMode)
        case loadSettings(Settings)
        case saveSettings
        case onAppear
        case showingAboutInfo(Bool)
    }

    @Dependency(\.settingsAppStorage) var settingsAppStorage

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .toggleThemeModeTapped(themeMode):
                state.themeMode = themeMode
                return .run { send in
                    await send(.saveSettings)
                }
            case .saveSettings:
                let settings = Settings(themeMode: state.themeMode)
                return .run { send in
                    try await settingsAppStorage.saveSettings(settings)
                }
            case .onAppear:
                return .run { send in
                    try await send(.loadSettings(settingsAppStorage.loadSettings()))
                }
            case let .loadSettings(settings):
                state.themeMode = settings.themeMode
                return .none
            case let .showingAboutInfo(isShowing):
                state.showingAboutInfo = isShowing
                return .none
            }
        }
    }
}
