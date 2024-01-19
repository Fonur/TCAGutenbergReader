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
        var bookmarkIDs: [Int] = []
    }

    enum Action {
        case bookmarksTab(BooksListFeature.Action)
        case changeTab(AppTab)
        case loadBookmarks([Int])
        case onAppear
        case recentlyAddedTab(BooksListFeature.Action)
    }

    @Dependency(\.appStorage) var appStorage

    var body: some ReducerOf<Self> {
        Scope(state: \.recentlyAddedTab, action: \.recentlyAddedTab) {
            BooksListFeature()
        }
        Scope(state: \.bookmarksTab, action: \.bookmarksTab) {
            BooksListFeature()
        }
        Reduce { state, action in
            switch action {
            case .bookmarksTab(_):
                state.bookmarksTab = BooksListFeature.State(parameters: "")
                return .none
            case let .changeTab(selectedTab):
                state.appTab = selectedTab
                return .none
            case let .loadBookmarks(bookmarks):
                state.bookmarkIDs = bookmarks
                return .none
            case .onAppear:
                return .run { send in
                    try await send(.loadBookmarks(appStorage.fetchBookmarkIds()))
                }
            case .recentlyAddedTab(_):
                return .none
            }
        }
    }
}
