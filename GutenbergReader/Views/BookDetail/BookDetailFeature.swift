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
        let book: Book
        var bookContent: Data?
        var isBookmarked = false
        var isDownloading = false
        var isDownloadingForRead = false
    }

    enum Action {
        case alert(PresentationAction<Alert>)
        case bookmarkButtonTapped
        case downloadAndSaveResponse(Data?)
        case downloadButtonTapped
        case downloadResponse(Data?)
        case readButtonTapped
        enum Alert: Equatable {
            case downloadMessage
        }
    }

    @Dependency(\.bookDetail) var bookDetail

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.downloadMessage)):
                return .none
            case .alert:
                return .none
            case .bookmarkButtonTapped:
                state.isBookmarked.toggle()
                return .none
            case let .downloadResponse(data):
                state.isDownloadingForRead = false
                if let data {
                    state.bookContent = data
                }
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
                let title = state.book.title
                return .run { send in
                    try await send(.downloadAndSaveResponse(bookDetail.downloadAndSave(url, title)))
                }
            case .readButtonTapped:
                state.isDownloadingForRead = true
                let url = state.book.formats.textPlainCharsetUsASCII
                return .run { send in
                    try await send(.downloadResponse(bookDetail.download(url)))
                }
            }
        }
    }
}
