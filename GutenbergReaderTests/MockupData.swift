//
//  MockupData.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 20.01.2024.
//

import Foundation
@testable import GutenbergReader

class MockupData {
    static var books: Books? {
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
}
