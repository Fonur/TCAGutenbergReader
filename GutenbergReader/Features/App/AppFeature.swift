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
        var settingsTab = SettingsFeature.State()
        var searchTab = SearchFeature.State(books: [])
        var bookmarkIDs: [Int] = []
    }

    enum Action {
        case bookmarksTab(BooksListFeature.Action)
        case changeTab(AppTab)
        case saveUserDefaults(Void)
        case loadBookmarks([Int])
        case onAppear
        case recentlyAddedTab(BooksListFeature.Action)
        case searchTab(SearchFeature.Action)
        case settingsTab(SettingsFeature.Action)
    }

    @Dependency(\.appStorage) var appStorage

    var body: some ReducerOf<Self> {
        Scope(state: \.recentlyAddedTab, action: \.recentlyAddedTab) {
            BooksListFeature()
        }
        Scope(state: \.bookmarksTab, action: \.bookmarksTab) {
            BooksListFeature()
        }
        Scope(state: \.searchTab, action: \.searchTab) {
            SearchFeature()
        }
        Scope(state: \.settingsTab, action: \.settingsTab) {
            SettingsFeature()
        }
        Reduce { state, action in
            switch action {
            case let .changeTab(selectedTab):
                switch selectedTab {
                case .bookmarks where !state.bookmarkIDs.isEmpty:
                    let bookmarkIDs: String = state.bookmarkIDs.reduce("") { result, number in
                        result + String(number) + ","
                    }.trimmingCharacters(in: CharacterSet(charactersIn: ","))
                    state.bookmarksTab.bookmarkIDs = state.bookmarkIDs
                    state.bookmarksTab.parameters = "?ids=\(bookmarkIDs)"
                    state.appTab = selectedTab
                case .recentlyAdded:
                    state.recentlyAddedTab.bookmarkIDs = state.bookmarkIDs
                    state.recentlyAddedTab.parameters = "?sort=descending"
                    state.appTab = selectedTab
                case .bookmarks:
                    state.appTab = selectedTab
                    break
                }
                return .none
            case let .loadBookmarks(bookmarks):
                state.bookmarkIDs = bookmarks
                return .none
            case .onAppear:
                return .run { send in
                    try await send(.loadBookmarks(appStorage.fetchBookmarkIds()))
                }
            case let .recentlyAddedTab(.delegate(.saveBookmark(bookmarkID, bookmark))),
                let .bookmarksTab(.delegate(.saveBookmark(bookmarkID, bookmark))),
                let .searchTab(.delegate(.saveBookmark(bookmarkID, bookmark))):
                bookmark == true
                    ? state.bookmarkIDs.append(bookmarkID)
                    : state.bookmarkIDs.removeAll(where: { currentBookmark in
                        currentBookmark == bookmarkID
                    })
                let bookmarkIDs = state.bookmarkIDs
                state.recentlyAddedTab.bookmarkIDs = state.bookmarkIDs
                state.bookmarksTab.bookmarkIDs = state.bookmarkIDs
                state.bookmarksTab.books = state.bookmarksTab.books.compactMap({ book in
                    if bookmarkIDs.contains(book.id) { return book }
                    return nil
                })
                return .run { send in
                    try await send(.saveUserDefaults(appStorage.saveBookmarkIds(bookmarkIDs)))
                }
            case .recentlyAddedTab(_):
                return .none
            case .bookmarksTab(_):
                return .none
            case .saveUserDefaults():
                return .none
            case .searchTab(_):
                return .none
            case .settingsTab(_):
                return .none
            }
        }
    }
}
