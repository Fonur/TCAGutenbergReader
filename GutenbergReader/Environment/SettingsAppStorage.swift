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
            if let settingsData = userDefaults.value(forKey: "settings") as? Data {
                let settings = try JSONDecoder().decode(Settings.self, from: settingsData)
                return settings
            }
            return Settings(isDarkMode: false)
        },
        saveSettings: { settings in
            let userDefaults = UserDefaults.standard
            if let settingsData = try? JSONEncoder().encode(settings) {
                userDefaults.set(settingsData, forKey: "settings")
            }
        }
    )

    static let testValue = Self(
        loadSettings: {
            return Settings(isDarkMode: true)
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
