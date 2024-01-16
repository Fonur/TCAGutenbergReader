//
//  GutenbergReaderApp.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 15.01.2024.
//

import SwiftUI
import ComposableArchitecture
@main
struct GutenbergReaderApp: App {
    static let store = Store(initialState: BooksListFeature.State()) {
        BooksListFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            BooksListView(store: GutenbergReaderApp.store)
        }
    }
}
