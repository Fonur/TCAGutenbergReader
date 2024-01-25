//
//  AppFeature.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 19.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    struct State: Equatable {
        var homeTab = HomeFeature.State()
        var settingsTab = SettingsFeature.State()
        var searchTab = SearchFeature.State(books: [])
    }

    enum Action {
        case saveUserDefaults(Void)
        case homeTab(HomeFeature.Action)
        case searchTab(SearchFeature.Action)
        case settingsTab(SettingsFeature.Action)
    }

    @Dependency(\.appStorage) var appStorage

    var body: some ReducerOf<Self> {
        Scope(state: \.homeTab, action: \.homeTab) {
            HomeFeature()
        }
        Scope(state: \.searchTab, action: \.searchTab) {
            SearchFeature()
        }
        Scope(state: \.settingsTab, action: \.settingsTab) {
            SettingsFeature()
        }
        Reduce { state, action in
            switch action {
            case .saveUserDefaults():
                return .none
            case .searchTab(_):
                return .none
            case .settingsTab(_):
                return .none
            case .homeTab(_):
                return .none
            }
        }
    }
}
