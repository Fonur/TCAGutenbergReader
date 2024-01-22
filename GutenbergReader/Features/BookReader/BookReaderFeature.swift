//
//  BookReader.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct BookReaderFeature {
    struct State: Codable, Equatable, Hashable {
        let bookContent: Data
        var text: String = ""
        var showingText: String = ""
        var showingPageNumberChangeAlert = false
        var page = 0
    }

    enum Action {
        case backwardButtonTapped
        case changePageNumberButtonTapped(Int)
        case showPageNumberChangeAlertButtonTapped(Bool)
        case forwardButtonTapped
        case loadText
        case showText(from: Int, to: Int)
        enum Alert: Equatable { case enterPageAlert }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadText:
                state.text = String(data: state.bookContent, encoding: .utf8)!
                let page = state.page
                return .run { send in
                    await send(.showText(from: page * 30, to: page * 30 + 30))
                }
            case .forwardButtonTapped:
                state.page += 1
                let page = state.page
                return .run { send in
                    await send(.showText(from: page * 30, to: page * 30 + 30))
                }
            case .backwardButtonTapped:
                if state.page > 0 {
                    state.page -= 1
                }
                let page = state.page
                return .run { send in
                    await send(.showText(from: page * 30, to: page * 30 + 30))
                }
            case .showText(from: let from, to: let to):
                state.showingText = state.text.lineRange(from: from, to: to)
                return .none
            case let .changePageNumberButtonTapped(newPageNumber):
                if newPageNumber >= 0 {
                    state.page = newPageNumber
                    state.showingPageNumberChangeAlert = false
                    return .run { send in
                        await send(.showText(from: newPageNumber * 30, to: newPageNumber * 30 + 30))
                    }
                } else {
                    return .none
                }
            case let .showPageNumberChangeAlertButtonTapped(isAction):
                state.showingPageNumberChangeAlert = isAction
                return .none
            }
        }
    }
}
