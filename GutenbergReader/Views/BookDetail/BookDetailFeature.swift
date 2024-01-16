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
        let book: Book
        var isDownloading = false
        var isDownloadingForRead = false
        var downloadSucceed = false
        var bookContent: Data?
        var isBookmarked = false
    }

    enum Action {
        case bookmarkButtonTapped
        case downloadAndSaveResponse(Data?)
        case downloadButtonTapped
        case downloadResponse(Data?)
        case readButtonTapped
    }

    @Dependency(\.bookDetail) var bookDetail

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .readButtonTapped:
                state.isDownloadingForRead = true
                let url = state.book.formats.textPlainCharsetUsASCII
                return .run { send in
                    try await send(.downloadResponse(bookDetail.download(url)))
                }
            case let .downloadResponse(data):
                state.isDownloadingForRead = false
                if let data {
                    state.bookContent = data
                    state.downloadSucceed = true
                } else {
                    state.downloadSucceed = false
                }
                return .none
            case let .downloadAndSaveResponse(data):
                state.isDownloading = false
                state.bookContent = data
                return .none
            case .downloadButtonTapped:
                state.isDownloading = true
                let url = state.book.formats.textPlainCharsetUsASCII
                return .run { send in
                    try await send(.downloadAndSaveResponse(bookDetail.downloadAndSave(url)))
                }
            case .bookmarkButtonTapped:
                state.isBookmarked = true
                return .none
            }
        }
    }
}
