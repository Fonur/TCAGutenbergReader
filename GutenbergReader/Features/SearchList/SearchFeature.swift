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
        var path = StackState<Path.State>()
        var isSearchInProgress = false
    }

    enum Action {
        case cancelSearchTask
        case searchTextChanged(String)
        case searchedBookList(Books?)
        case selectedBook(Book)
        case path(StackAction<Path.State, Path.Action>)
    }

    @Dependency(\.bookList) var bookList
    enum CancelID { case searching }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.text = text
                state.isSearchInProgress = true
                return .run { send in
                    await send(.cancelSearchTask)
                    try await withTaskCancellation(id: CancelID.searching) {
                        try await send(.searchedBookList(bookList.fetch("?search=\(text)")))
                    }
                }
            case let .searchedBookList(bookList):
                state.books = bookList!.results
                state.isSearchInProgress = false
                return .none
            case let .path(.element(id: _, action: .bookDetail(.readButtonTapped(data)))):
                state.path.append(.bookReader(BookReaderFeature.State(bookContent: data)))
                return .none
            case .path(_):
                return .none
            case let .selectedBook(book):
                state.path.append(.bookDetail(BookDetailFeature.State(book: book)))
                return .none
            case .cancelSearchTask:
                return .cancel(id: CancelID.searching)
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}
