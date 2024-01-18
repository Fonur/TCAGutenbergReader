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
        var isLoading: Bool = true
        var books: [Book] = []
        var bookmarkIDs: [Int] = []
        var path = StackState<BookDetailFeature.State>()
    }

    enum Action {
        case onAppear
        case booksListedResponse(Books)
        case loadBookmarks([Int])
        case path(StackAction<BookDetailFeature.State, BookDetailFeature.Action>)
        case selectedButtonTapped(Book)
    }

    @Dependency(\.bookList) var booksList
    @Dependency(\.appStorage) var appStorage

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await send(.booksListedResponse(self.booksList.fetch()))
                    try await send(.loadBookmarks(self.appStorage.fetchBookmarkIds()))
                }
            case let .booksListedResponse(books):
                state.books = books.results
                state.isLoading = false
                return .none
            case let .loadBookmarks(fetchedBookmarks):
                state.bookmarkIDs = fetchedBookmarks
                return .none
            case .path(_):
                return .none
            case let .selectedButtonTapped(book):
                var book = book
                book.isBookmarked = state.bookmarkIDs.contains(book.id)
                state.path.append(BookDetailFeature.State(book: book))
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            BookDetailFeature()
        }
    }
}
