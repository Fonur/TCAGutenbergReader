//
//  HomeFeature.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 24.01.2024.
//

import Foundation
import ComposableArchitecture

enum AppTab {
    case recentlyAdded
    case downloads
}

@Reducer
struct HomeFeature {
    struct State: Equatable {
        var path = StackState<Path.State>()
        var appTab: AppTab = .recentlyAdded
        var recentlyAddedTab = BooksListFeature.State(parameters: "?sort=descending")
        var downloadsTab = BooksListFeature.State()
    }

    enum Action {
        case changeTab(AppTab)
        case path(StackAction<Path.State, Path.Action>)
        case recentlyAddedTab(BooksListFeature.Action)
        case downloadsTab(BooksListFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.recentlyAddedTab, action: \.recentlyAddedTab) {
            BooksListFeature()
        }
        Scope(state: \.downloadsTab, action: \.downloadsTab) {
            BooksListFeature()
        }
        Reduce { state, action in
            switch action {
            case let .changeTab(tab):
                state.appTab = tab
                return .none
            case .path(_):
                return .none
            case .recentlyAddedTab(_):
                return .none
            case .downloadsTab(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}
