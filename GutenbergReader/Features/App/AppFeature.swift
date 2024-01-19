//
//  AppFeature.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 19.01.2024.
//

import Foundation
import ComposableArchitecture

enum AppTab {
    case recentlyAdded
    case bookmarks
}

@Reducer
struct AppFeature {
    struct State: Equatable {
        var appTab: AppTab = .recentlyAdded
        var recentlyAddedTab = BooksListFeature.State(parameters: "?sort=descending")
        var bookmarksTab = BooksListFeature.State()
    }

    enum Action {
        case changeTab(AppTab)
        case recentlyAddedTab(BooksListFeature.Action)
        case bookmarksTab(BooksListFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.recentlyAddedTab, action: \.recentlyAddedTab) {
            BooksListFeature()
        }
        Scope(state: \.bookmarksTab, action: \.bookmarksTab) {
            BooksListFeature()
        }
        Reduce { state, action in
            switch action {
            case let .changeTab(selectedTab):
                state.appTab = selectedTab
                return .none
            case .recentlyAddedTab(_):
                return .none
            case .bookmarksTab(_):
                state.bookmarksTab = BooksListFeature.State(parameters: "")
                return .none
            }
        }
    }
}
