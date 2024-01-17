//
//  BookReaderFeatureTests.swift
//  GutenbergReaderTests
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import XCTest
@testable import GutenbergReader
import ComposableArchitecture

@MainActor
final class BookReaderFeatureTests: XCTestCase {
    let data = "Hello, World!".data(using: .utf8)!
    func testLoadText() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }

        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }
    }
}
