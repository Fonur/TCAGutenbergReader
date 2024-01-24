//
//  AppFeatureView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 19.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct AppFeatureView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            TabView {
                HomeView(store: self.store.scope(state: \.homeTab, action: \.homeTab))
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                SearchFeatureView(store: self.store.scope(state: \.searchTab, action: \.searchTab))
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                SettingsFeatureView(store: self.store.scope(state: \.settingsTab, action: \.settingsTab))
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

#Preview {
    AppFeatureView(store: GutenbergReaderApp.store)
}
