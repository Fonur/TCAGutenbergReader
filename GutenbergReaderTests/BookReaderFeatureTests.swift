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
    let data =
"""
    1    The Project Gutenberg eBook of A Room with a View
    2
    3    This ebook is for the use of anyone anywhere in the United States and
    4    most other parts of the world at no cost and with almost no restrictions
    5    whatsoever. You may copy it, give it away or re-use it under the terms
    6    of the Project Gutenberg License included with this ebook or online
    7    at www.gutenberg.org. If you are not located in the United States,
    8    you will have to check the laws of the country where you are located
    9    before using this eBook.
    10
    11    Title: A Room with a View
    12
    13
    14    Author: E. M. Forster
    15
    16    Release date: May 1, 2001 [eBook #2641]
    17                    Most recently updated: October 22, 2023
    18
    19    Language: English
    20
    21
    22
    23    *** START OF THE PROJECT GUTENBERG EBOOK A ROOM WITH A VIEW ***
    24
    25
    26
    27    [Illustration]
    28
    29
    30
    31
    32    A Room With A View
    33
    34    By E. M. Forster
    35
    36
    37
    38
    39    CONTENTS
    40
    41     Part One.
    42     Chapter I. The Bertolini
    43     Chapter II. In Santa Croce with No Baedeker
    44     Chapter III. Music, Violets, and the Letter “S”
    45     Chapter IV. Fourth Chapter
    46     Chapter V. Possibilities of a Pleasant Outing
    47     Chapter VI. The Reverend Arthur Beebe, the Reverend Cuthbert Eager, Mr. Emerson, Mr. George Emerson, Miss Eleanor Lavish, Miss Charlotte Bartlett, and Miss Lucy Honeychurch Drive Out in Carriages to See a View; Italians Drive Them
    48     Chapter VII. They Return
    49
    50     Part Two.
    51     Chapter VIII. Medieval
    52     Chapter IX. Lucy As a Work of Art
    53     Chapter X. Cecil as a Humourist
    54     Chapter XI. In Mrs. Vyse’s Well-Appointed Flat
    55     Chapter XII. Twelfth Chapter
    56     Chapter XIII. How Miss Bartlett’s Boiler Was So Tiresome
    57     Chapter XIV. How Lucy Faced the External Situation Bravely
    58     Chapter XV. The Disaster Within
    59     Chapter XVI. Lying to George
    60     Chapter XVII. Lying to Cecil
    61     Chapter XVIII. Lying to Mr. Beebe, Mrs. Honeychurch, Freddy, and The Servants
    62     Chapter XIX. Lying to Mr. Emerson
    63     Chapter XX. The End of the Middle Ages
    64
    65
""".data(using: .utf8)!
    func testLoadText() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }
        store.exhaustivity = .off
        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }
    }

    func testForwardButtonTapped() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }

        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }

        await store.receive(\.showText) { state in
            state.showingText = state.text.lineRange(from: state.page * 30, to: state.page * 30 + 30)
        }

        await store.send(.forwardButtonTapped) { state in
            state.page = 1
        }

        await store.receive(\.showText) { state in
            state.showingText = state.text.lineRange(from: state.page * 30, to: state.page * 30 + 30)
        }
    }

    func testForwardButtonTapped_Exceeding() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }
        store.exhaustivity = .off

        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }

        await store.send(.forwardButtonTapped)
        await store.send(.forwardButtonTapped)
        await store.send(.forwardButtonTapped)
        await store.send(.forwardButtonTapped)

        store.assert { state in
            state.page = 4
            state.showingText = "THE END"
        }
    }

    func testChangePageNumber() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }
        store.exhaustivity = .off

        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }
        await store.send(.showPageNumberChangeAlertButtonTapped(true))
        await store.send(.changePageNumberButtonTapped(3))

        store.assert { state in
            state.page = 3
            state.showingPageNumberChangeAlert = false
        }
    }

    func testChangePageNumber_Negative() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }
        store.exhaustivity = .off

        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }
        
        await store.send(.showPageNumberChangeAlertButtonTapped(true))
        await store.send(.changePageNumberButtonTapped(-2))

        store.assert { state in
            state.page = 0
            state.showingPageNumberChangeAlert = true
        }
    }

    func testChangePageNumber_Zero() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data, page: 10)) {
            BookReaderFeature()
        }
        store.exhaustivity = .off

        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }

        await store.send(.showPageNumberChangeAlertButtonTapped(true))
        await store.send(.changePageNumberButtonTapped(0))

        store.assert { state in
            state.page = 0
            state.showingPageNumberChangeAlert = false
        }
    }

    func testShowChangeNumberAlert() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }

        await store.send(.showPageNumberChangeAlertButtonTapped(true)) { state in
            state.showingPageNumberChangeAlert = true
        }

        await store.send(.showPageNumberChangeAlertButtonTapped(false)) { state in
            state.showingPageNumberChangeAlert = false
        }
    }

    func testBackwardButtonTapped() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data, page: 1)) {
            BookReaderFeature()
        }

        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }

        await store.receive(\.showText) { state in
            state.showingText = state.text.lineRange(from: state.page * 30, to: state.page * 30 + 30)
        }

        await store.send(.backwardButtonTapped) { state in
            state.page = 0
        }

        await store.receive(\.showText) { state in
            state.showingText = state.text.lineRange(from: state.page * 30, to: state.page * 30 + 30)
        }
    }

    func testBackwardButtonTapped_MinusOne() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }

        store.exhaustivity = .off
        await store.send(.backwardButtonTapped)
        await store.send(.backwardButtonTapped)

        store.assert { state in
            state.page = 0
        }
    }

    func testShowChunkedTexts() async {
        let store = TestStore(initialState: BookReaderFeature.State(bookContent: data)) {
            BookReaderFeature()
        }
        await store.send(.loadText) { state in
            state.text = String(data: self.data, encoding: .utf8)!
        }
        await store.receive(\.showText) { state in
            state.showingText = """
    1    The Project Gutenberg eBook of A Room with a View
    2
    3    This ebook is for the use of anyone anywhere in the United States and
    4    most other parts of the world at no cost and with almost no restrictions
    5    whatsoever. You may copy it, give it away or re-use it under the terms
    6    of the Project Gutenberg License included with this ebook or online
    7    at www.gutenberg.org. If you are not located in the United States,
    8    you will have to check the laws of the country where you are located
    9    before using this eBook.
    10
    11    Title: A Room with a View
    12
    13
    14    Author: E. M. Forster
    15
    16    Release date: May 1, 2001 [eBook #2641]
    17                    Most recently updated: October 22, 2023
    18
    19    Language: English
    20
    21
    22
    23    *** START OF THE PROJECT GUTENBERG EBOOK A ROOM WITH A VIEW ***
    24
    25
    26
    27    [Illustration]
    28
    29
    30
"""
        }
    }
}
