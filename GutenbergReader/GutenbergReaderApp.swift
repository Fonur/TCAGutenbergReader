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
    @AppStorage("settings") var settings: Settings? = nil

    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            AppFeatureView(store: GutenbergReaderApp.store)
                .environment(\.colorScheme, settings?.isDarkMode ?? false ? .dark : .light)
        }
    }
}
