//
//  AppFeatureTests.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 19.01.2024.
//

import XCTest
import ComposableArchitecture
@testable import GutenbergReader

@MainActor
final class AppFeatureTests: XCTestCase {
    var store: TestStore<AppFeature.State, AppFeature.Action>!
    override func setUpWithError() throws {
        self.store = TestStore(initialState: AppFeature.State(), reducer: {
            AppFeature()
        })
    }

    override func tearDownWithError() throws {
        self.store = nil
    }

    func testChangeTab() async {
        await store.send(.changeTab(.bookmarks)) { state in
            state.appTab = .bookmarks
        }

        await store.send(.changeTab(.recentlyAdded)) { state in
            state.appTab = .recentlyAdded
        }
    }

    func testChangeTab_LoadBookmarksAfterBookmarkToggle() async {
        store.exhaustivity = .off
        await store.send(.onAppear)
        await store.skipReceivedActions()
        await store.send(.bookmarksTab(.onAppear))
        await store.skipReceivedActions()
        store.assert { state in
            state.bookmarksTab.books = [MockupBooks.books!.results[0]]
        }
        await store.send(.bookmarksTab(.delegate(.saveBookmark(46, false))))
        store.assert { state in
            state.bookmarksTab.books = []
        }
    }

    func testLoadBookmarks() async {
        store.exhaustivity = .off
        await store.send(.onAppear)
        await store.receive(\.loadBookmarks)
        store.assert { state in
            state.bookmarkIDs = [46, 2, 3, 1]
        }
    }

    func testShowBookmarkedBooks() async {
        await store.send(.onAppear)
        await store.receive(\.loadBookmarks) { state in
            state.bookmarkIDs = [46, 2, 3, 1]
        }
        await store.send(.changeTab(.bookmarks)) { state in
            state.appTab = .bookmarks
            state.bookmarksTab = BooksListFeature.State(parameters: "?ids=46,2,3,1")
            state.bookmarksTab.bookmarkIDs = state.bookmarkIDs
        }

    }

    func testRecentlyAddedDelegateToggleBookmark() async {
        let book = MockupBooks.books!.results[0]
        store.exhaustivity = .off

        await store.send(.onAppear)
        await store.skipReceivedActions()
        await store.send(.recentlyAddedTab(.delegate(.saveBookmark(46, false))))
        store.assert { state in
            state.bookmarkIDs = [2, 3, 1]
        }
        await store.send(.recentlyAddedTab(.delegate(.saveBookmark(46, true))))
        store.assert { state in
            state.bookmarkIDs = [2, 3, 1, 46]
            state.recentlyAddedTab.bookmarkIDs = state.bookmarkIDs
            state.bookmarksTab.bookmarkIDs = state.bookmarkIDs
        }
    }

    func testBookmarkDelegateToggleBookmark() async {
        let book = MockupBooks.books!.results[0]
        store.exhaustivity = .off

        await store.send(.onAppear)
        await store.skipReceivedActions()
        await store.send(.bookmarksTab(.delegate(.saveBookmark(46, false))))
        store.assert { state in
            state.bookmarkIDs = [2, 3, 1]
        }
        await store.send(.bookmarksTab(.delegate(.saveBookmark(46, true))))
        store.assert { state in
            state.bookmarkIDs = [2, 3, 1, 46]
            state.recentlyAddedTab.bookmarkIDs = state.bookmarkIDs
            state.bookmarksTab.bookmarkIDs = state.bookmarkIDs
        }
    }
}
