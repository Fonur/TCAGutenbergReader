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
    var store: TestStore<BooksListFeature.State, BooksListFeature.Action>!
    override func setUp() async throws {
        self.store = TestStore(initialState: BooksListFeature.State()) {
            BooksListFeature()
        } withDependencies: {
            $0.bookList.fetch = { self.books! }
        }
    }

    var books: Books? {
        let jsonData = """
        {
            "count": 72624,
            "next": "https://gutendex.com/books/?page=2",
            "previous": null,
            "results": [
                {
                    "id": 46,
                    "title": "A Christmas Carol in Prose; Being a Ghost Story of Christmas",
                    "authors": [
                        {
                            "name": "Dickens, Charles",
                            "birth_year": 1812,
                            "death_year": 1870
                        }
                    ],
                    "translators": [],
                    "subjects": [
                        "Christmas stories",
                        "Ghost stories",
                        "London (England) -- Fiction",
                        "Misers -- Fiction",
                        "Poor families -- Fiction",
                        "Scrooge, Ebenezer (Fictitious character) -- Fiction",
                        "Sick children -- Fiction"
                    ],
                    "bookshelves": [
                        "Children's Literature",
                        "Christmas"
                    ],
                    "languages": [
                        "en"
                    ],
                    "copyright": false,
                    "media_type": "Text",
                    "formats": {
                        "text/html": "https://www.gutenberg.org/ebooks/46.html.images",
                        "application/epub+zip": "https://www.gutenberg.org/ebooks/46.epub3.images",
                        "application/x-mobipocket-ebook": "https://www.gutenberg.org/ebooks/46.kf8.images",
                        "application/rdf+xml": "https://www.gutenberg.org/ebooks/46.rdf",
                        "image/jpeg": "https://www.gutenberg.org/cache/epub/46/pg46.cover.medium.jpg",
                        "text/plain; charset=us-ascii": "https://www.gutenberg.org/ebooks/46.txt.utf-8",
                        "application/octet-stream": "https://www.gutenberg.org/cache/epub/46/pg46-h.zip"
                    },
                    "download_count": 73366
                }
            ]
        }
        """.data(using: .utf8)!
        let books = try? JSONDecoder().decode(Books.self, from: jsonData)
        return books
    }

    func testCategoriesListed() async {
        await store.send(.onAppear)

        await store.receive(\.booksListedResponse) { state in
            state.books = self.books!.results
            state.isLoading = false
        }
    }

    func testNavigateBookDetailButtonTapped() async {
        var book: Book!
        var bookMarked: Book!
        await store.send(.onAppear)

        await store.receive(\.booksListedResponse) { state in
            state.books = self.books!.results
            state.isLoading = false
            book = state.books[0]
            bookMarked = book
            bookMarked.isBookmarked = true
        }

        await store.receive(\.loadBookmarks) { state in
            state.bookmarkIDs = [46]
        }

        await store.send(.selectedButtonTapped(book)) { state in
            state.path = StackState([BookDetailFeature.State(book: bookMarked)])
        }
    }

    func testLoadBookmarks() async {
        store.exhaustivity = .off
        await store.send(.onAppear)
        await store.skipReceivedActions()
        store.assert { state in
            state.bookmarkIDs = [46]
        }
    }
}
