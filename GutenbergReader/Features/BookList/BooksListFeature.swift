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
    struct State: Equatable {
        var parameters: String? = nil
        var isLoading: Bool = true
        var books: [Book] = []
        var bookmarkIDs: [Int] = []
        var path = StackState<BookDetailFeature.State>()
    }

    enum Action {
        case onAppear
        case booksListedResponse(Books)
        case delegate(Delegate)
        case path(StackAction<BookDetailFeature.State, BookDetailFeature.Action>)
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
            case let .path(.element(id: _, action: .delegate(.saveBookmark(bookmarkID, bookmark)))):
                return .send(.delegate(.saveBookmark(bookmarkID, bookmark)))
            case .path(_):
                return .none
            case let .selectedButtonTapped(book):
                var book = book
                book.isBookmarked = state.bookmarkIDs.contains(book.id)
                state.path.append(BookDetailFeature.State(book: book))
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
