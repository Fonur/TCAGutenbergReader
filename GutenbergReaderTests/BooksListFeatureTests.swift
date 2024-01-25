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
        self.store = TestStore(initialState: BooksListFeature.State()) {
            BooksListFeature()
        } withDependencies: {
            $0.bookList.fetch = {_ in self.books! }
        }
    }

    func testCategoriesListed() async {
        self.store = TestStore(initialState: BooksListFeature.State(parameters: "?sort=descending")) {
            BooksListFeature()
        } withDependencies: {
            $0.bookList.fetch = {_ in self.books! }
        }

        await store.send(.onAppear)

        await store.receive(\.booksListedResponse) { state in
            state.books = self.books!.results
            state.isLoading = false
        }
    }

    func testDownloadedBooksListed() async {
        self.store = TestStore(initialState: BooksListFeature.State(books: self.books!.results)) {
            BooksListFeature()
        } withDependencies: {
            $0.bookList.fetch = {_ in self.books! }
        }

        await store.send(.onAppear)

        await store.receive(\.booksListedResponse) { state in
            state.books = []
            state.isLoading = false
        }
    }
}
