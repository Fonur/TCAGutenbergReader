//
//  AppStorageClient.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 18.01.2024.
//

import Foundation
import ComposableArchitecture

struct AppStorageClient {
    var fetchBookmarkIds: () async throws -> [Int]
}

extension AppStorageClient: DependencyKey {
    static let liveValue = Self(fetchBookmarkIds: {
        return UserDefaults.standard.object(forKey: "bookmarks") as? [Int] ?? []
    })
    static let testValue = Self(fetchBookmarkIds: {
        return [46]
    })
}

extension DependencyValues {
    var appStorage: AppStorageClient {
        get { self[AppStorageClient.self] }
        set { self[AppStorageClient.self] = newValue }
    }
}
