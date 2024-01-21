//
//  SearchFeature.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 20.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchFeature {
    struct State: Equatable {
        var text: String = ""
        var books: [Book]
        var path = StackState<BookDetailFeature.State>()
    }

    enum Action {
        case searchTextChanged(String)
        case searchedBookList(Books?)
        case delegate(Delegate)
        case path(StackAction<BookDetailFeature.State, BookDetailFeature.Action>)
        enum Delegate {
            case saveBookmark(Int, Bool)
        }
    }

    @Dependency(\.bookList) var bookList

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.text = text
                return .run { send in
                    try await send(.searchedBookList(bookList.fetch("?search=\(text)")))
                }
            case let .searchedBookList(bookList):
                state.books = bookList!.results
                return .none
            case let .path(.element(id: _, action: .delegate(.saveBookmark(bookmarkID, bookmark)))):
                return .send(.delegate(.saveBookmark(bookmarkID, bookmark)))
            case .path(_):
                return .none
            case .delegate(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            BookDetailFeature()
        }
    }
}
