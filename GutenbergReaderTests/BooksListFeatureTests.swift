//
//  CategoryListFeatureTests.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 15.01.2024.
//

@testable import GutenbergReader
import XCTest
import ComposableArchitecture


@MainActor
final class BooksListFeatureTests: XCTestCase {
    let books = MockupData.books
    var store: TestStore<BooksListFeature.State, BooksListFeature.Action>!
    override func setUp() async throws {
        self.store = TestStore(initialState: BooksListFeature.State(bookmarkIDs: [46, 2, 3, 1])) {
            BooksListFeature()
        } withDependencies: {
            $0.bookList.fetch = {_ in self.books! }
        }
    }

    func testCategoriesListed() async {
        await store.send(.onAppear)

        await store.receive(\.booksListedResponse) { state in
            state.books = self.books!.results
            state.isLoading = false
        }
    }
}
