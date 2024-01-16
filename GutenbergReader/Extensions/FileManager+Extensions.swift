//
//  FileManager+Extensions.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import Foundation

extension FileManager {
    func save(data: Data, title: String) throws {
        let url = URL.documentsDirectory.appending(path: "\(title).txt")
        do {
            try data.write(to: url)
        } catch {
            throw error
        }
    }
}
