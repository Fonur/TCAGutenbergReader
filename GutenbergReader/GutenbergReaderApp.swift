//
//  GutenbergReaderApp.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 15.01.2024.
//

import SwiftUI
import ComposableArchitecture
@main
struct GutenbergReaderApp: App {
    @AppStorage("settings") var settings: Settings = Settings(themeMode: .defaultTheme)

    var appearanceSwitch: ColorScheme? {
        if settings.themeMode == .lightTheme {
            return .light
        }
        else if settings.themeMode == .darkTheme {
            return .dark
        }
        else {
            return .none
        }
    }
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            AppFeatureView(store: GutenbergReaderApp.store)
                .preferredColorScheme(appearanceSwitch)
        }
    }
}
