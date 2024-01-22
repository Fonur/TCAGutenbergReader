//
//  BookDetailClient.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import Foundation
import ComposableArchitecture

struct BookDetailClient {
    var download: (String) async throws -> Data
    var downloadAndSave: (String, String) async throws -> Data
    var loadBook: (String) async throws -> Data?
}

extension BookDetailClient: DependencyKey {
    static let liveValue = Self(
        download: { url in
            let downloadManager = DownloadManager()
            let url = URL(string: url)!
            return try await downloadManager.downloadBook(url: url)
        },
        downloadAndSave: { url, id in
            let downloadManager = DownloadManager()
            let url = URL(string: url)!
            let data = try await downloadManager.downloadBook(url: url)
            let fileURL = URL.documentsDirectory.appending(path: "\(id).txt")
            try FileManager.default.save(data: data, url: fileURL)
            return data
        },
        loadBook: { id in
            let fileURL = URL.documentsDirectory.appending(path: "\(id).txt")
            let data = try Data(contentsOf: fileURL)
            return data
        }
    )
    static let testValue = Self (
        download: { url in
            return Data()
        },
        downloadAndSave: { url, title in
            return Data()
        },
        loadBook: { url in
            return Data()
        }
    )
}

extension DependencyValues {
    var bookDetail: BookDetailClient {
        get { self[BookDetailClient.self] }
        set { self[BookDetailClient.self] = newValue }
    }
}
