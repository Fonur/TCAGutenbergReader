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
}

extension BookDetailClient: DependencyKey {
    static let liveValue = Self(
    download: { url in
        let downloadManager = DownloadManager()
        let url = URL(string: url)!
        return try await downloadManager.downloadBook(url: url)
    }, 
    downloadAndSave: { url, title in
        let downloadManager = DownloadManager()
        let url = URL(string: url)!
        let data = try await downloadManager.downloadBook(url: url)
        let fileURL = URL.documentsDirectory.appending(path: "\(title).txt")
        try FileManager.default.save(data: data, url: fileURL)
        return data
    })
}

extension DependencyValues {
    var bookDetail: BookDetailClient {
        get { self[BookDetailClient.self] }
        set { self[BookDetailClient.self] = newValue }
    }
}
