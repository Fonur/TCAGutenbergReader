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
    }

    enum Action {
        case onAppear
        case booksListedResponse(Books)
        case delegate(Delegate)
        case selectedButtonTapped(Book)
        enum Delegate: Equatable {
            case saveBookmark(Int, Bool)
        }
    }

    @Dependency(\.bookList) var booksList
    @Dependency(\.downloadedBookList) var downloadedBookList

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if let parameters = state.parameters {
                    return .run { send in
                        try await send(.booksListedResponse(self.booksList.fetch(parameters)))
                    }
                } else {
                    return .run { send in
                        try await send(.booksListedResponse(self.downloadedBookList.fetch()))
                    }
                }
            case let .booksListedResponse(books):
                state.books = books.results
                state.isLoading = false
                return .none
            case .delegate(_):
                return .none
            case .selectedButtonTapped(_):
                return .none
            }
        }
    }
}
