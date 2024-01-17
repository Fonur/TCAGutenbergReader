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
    struct State: Equatable {
        let bookContent: Data
        var text: String = ""
    }

    enum Action {
        case loadText
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadText:
                state.text = String(data: state.bookContent, encoding: .utf8)!
                return .none
            }
        }
    }
}
