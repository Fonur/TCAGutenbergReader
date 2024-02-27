//
//  SearchFeatureTests.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 20.01.2024.
//

import XCTest
@testable import GutenbergReader
import ComposableArchitecture

@MainActor
final class SearchFeatureTests: XCTestCase {
    var store: TestStore<SearchFeature.State, SearchFeature.Action>!
    let book = MockupData.books!.results[0]
    
    override func setUpWithError() throws {
        self.store = TestStore(initialState: SearchFeature.State(books: []), reducer: {
            SearchFeature()
        })
    }

    func testSearchTextChange() async {
        await self.store.send(.searchTextChanged("A Christmas")) { state in
            state.text = "A Christmas"
            state.isSearchInProgress = true
        }
        await self.store.receive(\.cancelSearchTask)
        await self.store.receive(\.searchedBookList) { state in
            state.books = [self.book]
            state.isSearchInProgress = false
        }
    }

    func testBookTapped() async {
        store.exhaustivity = .off
        await self.store.send(.searchTextChanged("A Christmas"))
        await self.store.receive(\.cancelSearchTask)
        await self.store.receive(\.searchedBookList)
        await self.store.send(.selectedBook(book))
        store.assert {state in
            state.path[id: 0] = .bookDetail(BookDetailFeature.State(book: self.book))
        }
    }

    func testReadButtonTapped() async {
        await store.send(.path(.push(id: 0, state: .bookDetail(BookDetailFeature.State(book: book))))) { state in
            state.path[id: 0] = .bookDetail(BookDetailFeature.State(book: self.book))
        }
        await store.send(.path(.element(id: 0, action: .bookDetail(.readButtonTapped(Data()))))) { state in
            state.path[id: 1] = .bookReader(BookReaderFeature.State(bookContent: Data()))
        }
    }
}
