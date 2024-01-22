//
//  BookInfoTests.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import XCTest
@testable import GutenbergReader
import ComposableArchitecture

@MainActor
final class BookDetailFeatureTests: XCTestCase {
    var store: TestStore<BookDetailFeature.State, BookDetailFeature.Action>!
    override func setUp() async throws {
        self.store = TestStore(initialState: BookDetailFeature.State(book: book)) {
            BookDetailFeature()
        } withDependencies: {
            $0.bookDetail.download = { _ in
                return Data()
            }
            $0.bookDetail.downloadAndSave = { _, _ in
                return Data()
            }
        }
    }

    var book: Book {
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
        return books!.results[0]
    }
    
    var success = false

    func testDownloadButtonTapped() async {
        await store.send(.downloadButtonTapped) { state in
            state.isDownloading = true
        }
        
        await store.receive(\.downloadAndSaveResponse) { state in
            state.isDownloading = false
            state.bookContent = Data()
            state.alert = .downloadMessage()
        }
    }
    
    func testBookmarkBookTapped() async {
        store.exhaustivity = .off
        await store.send(.bookmarkButtonTapped) { state in
            state.book.isBookmarked = true
        }
        await store.skipReceivedActions()
        await store.send(.bookmarkButtonTapped) { state in
            state.book.isBookmarked = false
        }
    }

    func testLoadBook() async {
        store.exhaustivity = .off
        await store.send(.onAppear)
        await store.receive(\.isDownloadedBook) { state in
            state.bookContent = Data()
            state.isDownloadedBook = true
        }
    }
}
