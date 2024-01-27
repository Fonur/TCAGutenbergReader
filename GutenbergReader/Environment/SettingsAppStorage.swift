//
//  SettingsAppStorage.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 21.01.2024.
//

import Foundation
import ComposableArchitecture

struct SettingsAppStorage {
    var loadSettings: () async throws -> Settings
    var saveSettings: (Settings) async throws -> Void
}

extension SettingsAppStorage: DependencyKey {
    static let liveValue = Self(
        loadSettings: {
            let userDefaults = UserDefaults.standard
            if let settingsString = userDefaults.string(forKey: "settings"),
               let settings = Settings(rawValue: settingsString) {
                return settings
            }
            return Settings(themeMode: .defaultTheme)
        },
        saveSettings: { settings in
            let settingsString = settings.rawValue
            UserDefaults.standard.set(settingsString, forKey: "settings")
        }
    )

    static let testValue = Self(
        loadSettings: {
            return Settings(themeMode: .darkTheme)
        },
        saveSettings: { settings in

        }
    )
}

extension DependencyValues {
    var settingsAppStorage: SettingsAppStorage {
        get { self[SettingsAppStorage.self] }
        set { self[SettingsAppStorage.self] = newValue }
    }
}
