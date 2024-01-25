//
//  HomeFeature+Path.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 24.01.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Path {
    enum State: Codable, Equatable, Hashable {
        case bookDetail(BookDetailFeature.State)
        case bookReader(BookReaderFeature.State)
    }

    enum Action {
        case bookDetail(BookDetailFeature.Action)
        case bookReader(BookReaderFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.bookDetail, action: \.bookDetail) {
            BookDetailFeature()
        }
        Scope(state: \.bookReader, action: \.bookReader) {
            BookReaderFeature()
        }
    }
}

