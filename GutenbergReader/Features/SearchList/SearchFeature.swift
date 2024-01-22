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
    
    @Reducer
    struct Path {
        enum State: Codable, Equatable, Hashable {
            case bookDetail(BookDetailFeature.State)
            case bookReader(BookReaderFeature.State)
        }

        enum Action {
            case bookDetail(BookDetailFeature.Action)
            case bookReader(BookReaderFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.bookDetail, action: \.bookDetail) {
                BookDetailFeature()
            }
            Scope(state: \.bookReader, action: \.bookReader) {
                BookReaderFeature()
            }
        }
    }

    struct State: Equatable {
        var text: String = ""
        var books: [Book]
        var path = StackState<Path.State>()
    }

    enum Action {
        case searchTextChanged(String)
        case searchedBookList(Books?)
        case selectedBook(Book)
        case delegate(Delegate)
        case path(StackAction<Path.State, Path.Action>)
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
            case let .path(.element(id: _, action: .bookDetail(.delegate(.saveBookmark(bookmarkID, bookmark))))):
                return .send(.delegate(.saveBookmark(bookmarkID, bookmark)))            
            case let .path(.element(id: _, action: .bookDetail(.readButtonTapped(data)))):
                state.path.append(.bookReader(BookReaderFeature.State(bookContent: data)))
                return .none
            case .path(_):
                return .none
            case .delegate(_):
                return .none
            case let .selectedBook(book):
                state.path.append(.bookDetail(BookDetailFeature.State(book: book)))
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}
