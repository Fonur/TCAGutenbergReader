//
//  DownloadManager.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import Foundation

class DownloadManager {
    func downloadBook(url: URL) async throws -> Data {
        let urlRequest = URLRequest(url: url)
        let data = try await URLSession.shared.data(for: urlRequest)
        return data.0
    }
}
