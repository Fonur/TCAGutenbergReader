//
//  CategoryListFeature.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 15.01.2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct BooksListFeature {

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
        var parameters: String? = nil
        var isLoading: Bool = true
        var books: [Book] = []
        var bookmarkIDs: [Int] = []
        var path = StackState<Path.State>()
    }

    enum Action {
        case onAppear
        case booksListedResponse(Books)
        case delegate(Delegate)
        case path(StackAction<Path.State, Path.Action>)
        case selectedButtonTapped(Book)
        enum Delegate: Equatable {
            case saveBookmark(Int, Bool)
        }
    }

    @Dependency(\.bookList) var booksList

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let parameters = state.parameters
                return .run { send in
                    try await send(.booksListedResponse(self.booksList.fetch(parameters)))
                }
            case let .booksListedResponse(books):
                state.books = books.results
                state.isLoading = false
                return .none
            case let .path(.element(id: _, action: .bookDetail(.delegate(.saveBookmark(bookmarkID, bookmark))))):
                return .send(.delegate(.saveBookmark(bookmarkID, bookmark)))
            case let .path(.element(id: _, action: .bookDetail(.readButtonTapped(data)))):
                state.path.append(.bookReader(BookReaderFeature.State(bookContent: data)))
                return .none
            case .path(_):
                return .none
            case let .selectedButtonTapped(book):
                var book = book
                book.isBookmarked = state.bookmarkIDs.contains(book.id)
                state.path.append(.bookDetail(BookDetailFeature.State(book: book)))
                return .none
            case .delegate(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}
