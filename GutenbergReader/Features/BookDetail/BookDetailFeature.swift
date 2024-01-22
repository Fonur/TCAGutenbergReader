//
//  BookDetailFeature.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct BookDetailFeature {
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var bookReader: BookReaderFeature.State?
        var book: Book
        var bookContent: Data?
        var readContentURL: String?
        var isDownloading = false
        var isDownloadedBook = false
    }

    enum Action {
        case alert(PresentationAction<Alert>)
        case bookmarkButtonTapped
        case bookReader(BookReaderFeature.Action)
        case delegate(Delegate)
        case downloadAndSaveResponse(Data?)
        case downloadButtonTapped
        case onAppear
        case isDownloadedBook(Data?)
        enum Alert: Equatable { case downloadMessage }
        enum Delegate: Equatable {
            case saveBookmark(Int, Bool)
        }
    }

    private enum CancelID { case load }

    @Dependency(\.bookDetail) var bookDetail

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.downloadMessage)):
                return .none
            case .alert:
                return .none
            case .bookmarkButtonTapped:
                state.book.isBookmarked.toggle()
                return .send(.delegate(.saveBookmark(state.book.id, state.book.isBookmarked)))
            case .delegate(_):
                return .none
            case let .downloadAndSaveResponse(data):
                state.isDownloading = false
                state.bookContent = data
                if state.bookContent != nil {
                    state.alert = .downloadMessage()
                }
                return .none
            case .downloadButtonTapped:
                state.isDownloading = true
                let url = state.book.formats.textPlainCharsetUsASCII
                let id = String(state.book.id)
                return .run { send in
                    try await send(.downloadAndSaveResponse(bookDetail.downloadAndSave(url!, id)))
                }
            case .bookReader:
                return .none
            case .onAppear:
                let id = String(state.book.id)
                return .run { send in
                    try await send(.isDownloadedBook(bookDetail.loadBook(id)))
                }
            case let .isDownloadedBook(data):
                if let data {
                    state.isDownloadedBook = true
                    state.bookContent = data
                } else {
                    state.isDownloadedBook = false
                }
                return .none
            }
        }
        .ifLet(\.bookReader, action: \.bookReader) {
            BookReaderFeature()
        }
    }
}
