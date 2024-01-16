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
        var isLoading: Bool = false
        var books: [Book] = []
        var path = StackState<BookDetailFeature.State>()
    }

    enum Action {
        case onAppear
        case booksListedResponse(Books)
        case path(StackAction<BookDetailFeature.State, BookDetailFeature.Action>)
    }

    @Dependency(\.bookList) var booksList

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    try await send(.booksListedResponse(self.booksList.fetch()))
                }
            case let .booksListedResponse(books):
                state.books = books.results
                state.isLoading = false
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            BookDetailFeature()
        }
    }
}
