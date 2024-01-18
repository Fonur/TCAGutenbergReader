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
        let book: Book
        var bookContent: Data?
        var readContentURL: String?
        var isBookmarked = false
        var isDownloading = false
        var isSettingForReady = false
    }

    enum Action {
        case alert(PresentationAction<Alert>)
        case bookmarkButtonTapped
        case bookReader(BookReaderFeature.Action)
        case downloadAndSaveResponse(Data?)
        case download(Data?)
        case downloadButtonTapped
        case saveUserDefaults
        case setNavigation(isActive: Bool)
        enum Alert: Equatable { case downloadMessage }
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
                state.isBookmarked.toggle()
                return .none
            case let .download(data):
                state.bookReader = BookReaderFeature.State(bookContent: data!)
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
            case .bookReader:
                return .none
            case .saveUserDefaults:
                let userDefaults = UserDefaults.standard
                var books: [Int] = userDefaults.array(forKey: "books") as? [Int] ?? []
                userDefaults.setValue([state.book.id], forKey: "books")
                return .none
            case .setNavigation(isActive: true):
                let url = state.book.formats.textPlainCharsetUsASCII
                state.isSettingForReady = true
                return .run { send in
                    try await send(.download(bookDetail.download(url)))
                }
                .cancellable(id: CancelID.load)
            case .setNavigation(isActive: false):
                state.isSettingForReady = false
                state.bookReader = nil
                return .cancel(id: CancelID.load)
            }
        }
        .ifLet(\.bookReader, action: \.bookReader) {
            BookReaderFeature()
        }
    }
}
