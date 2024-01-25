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
    struct State: Codable, Equatable, Hashable {
        var bookReader: BookReaderFeature.State?
        var book: Book
        var bookContent: Data?
        var readContentURL: String?
        var isDownloading = false
        var isDownloadedBook = false
    }

    enum Action {
        case alert(PresentationAction<Alert>)
        case bookReader(BookReaderFeature.Action)
        case downloadAndSaveResponse(Data?)
        case downloadButtonTapped
        case readButtonTapped(Data)
        case onAppear
        case isDownloadedBook(Data?)
        enum Alert: Equatable { case downloadMessage }
    }

    private enum CancelID { case load }

    @Dependency(\.bookDetail) var bookDetail
    @Dependency(\.downloadedBookList) var downloadedBookList

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.downloadMessage)):
                return .none
            case .alert:
                return .none
            case let .downloadAndSaveResponse(data):
                let id = String(state.book.id)
                state.isDownloading = false
                state.bookContent = data
                if state.bookContent != nil {
                    //state.alert = .downloadMessage()
                }
                let book = state.book

                return .run { send in
                    try await downloadedBookList.appendAndSave(book)
                    try await send(.isDownloadedBook(bookDetail.loadBook(id)))
                }
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
            case .readButtonTapped:
                return .none
            }
        }
        .ifLet(\.bookReader, action: \.bookReader) {
            BookReaderFeature()
        }
    }
}
