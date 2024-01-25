//
//  DownloadedBookListClient.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 24.01.2024.
//

import Foundation
import ComposableArchitecture

struct DownloadedBookListClient {
    var fetch: () async throws -> Books
    var appendAndSave: (Book) async throws -> Void
}

extension DownloadedBookListClient: DependencyKey {
    static let liveValue = Self(
        fetch: {
            let filePath = FileManager.getDocumentsDirectory().appendingPathComponent("SavedBooks.json")

            guard FileManager.default.fileExists(atPath: filePath.path) else {
                return Books(count: 0, results: [])
            }

            let data = try Data(contentsOf: filePath)
            let books = try JSONDecoder().decode([Book].self, from: data)
            return Books(count: books.count, results: books)
        }) { newBook in
            let filePath = FileManager.getDocumentsDirectory().appendingPathComponent("SavedBooks.json")
            var books: [Book] = []

            if FileManager.default.fileExists(atPath: filePath.path) {
                let data = try Data(contentsOf: filePath)
                let decoder = JSONDecoder()
                books = try decoder.decode([Book].self, from: data)
            }

            books.append(newBook)

            let encoder = JSONEncoder()
            let data = try encoder.encode(books)
            try data.write(to: filePath)
        }
    static let testValue = Self( fetch:{
        return Books(count: 0, results: [])
    }) { _ in
    }
}

extension DependencyValues {
    var downloadedBookList: DownloadedBookListClient {
        get { self[DownloadedBookListClient.self] }
        set { self[DownloadedBookListClient.self] = newValue }
    }
}
