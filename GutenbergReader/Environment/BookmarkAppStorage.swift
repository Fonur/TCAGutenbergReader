//
//  AppStorageClient.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 18.01.2024.
//

import Foundation
import ComposableArchitecture

struct BookmarkAppStorage {
    var fetchBookmarkIds: () async throws -> [Int]
    var saveBookmarkIds: ([Int]) async throws -> Void
}

extension BookmarkAppStorage: DependencyKey {
    static let liveValue = Self(fetchBookmarkIds: {
        return UserDefaults.standard.object(forKey: "bookmarks") as? [Int] ?? []
    }, saveBookmarkIds: { ids in
        UserDefaults.standard.setValue(ids, forKey: "bookmarks")
    })
    static let testValue = Self(fetchBookmarkIds: {
        return [46, 2, 3, 1]
    }, saveBookmarkIds: { _ in })
}

extension DependencyValues {
    var appStorage: BookmarkAppStorage {
        get { self[BookmarkAppStorage.self] }
        set { self[BookmarkAppStorage.self] = newValue }
    }
}
