//
//  FileManager+Extensions.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import Foundation

extension FileManager {
    func save(data: Data, url: URL) throws {
        do {
            try data.write(to: url)
        } catch {
            throw error
        }
    }

    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
