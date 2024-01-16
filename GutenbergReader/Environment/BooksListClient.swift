//
//  CategoriesListClient.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 15.01.2024.
//

import Foundation
import ComposableArchitecture

struct BooksListClient {
    var fetch: () async throws -> Books
}

extension BooksListClient: DependencyKey {
    static let liveValue = Self(fetch: {
        let (data, _) = try await URLSession.shared
          .data(from: URL(string: "https://gutendex.com/books")!)
        let books = try! JSONDecoder().decode(Books.self, from: data)
        return books
    })
}

extension DependencyValues {
    var bookList: BooksListClient {
        get { self[BooksListClient.self] }
        set { self[BooksListClient.self] = newValue }
    }
}
