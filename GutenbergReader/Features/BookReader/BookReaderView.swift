//
//  BookReaderView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookReaderView: View {
    let store: StoreOf<BookReaderFeature>
    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            Text(viewStore.text)
                .lineLimit(nil)
                .onAppear {
                    viewStore.send(.loadText)
                }
        }
    }
}

#Preview {
    BookReaderView(store: Store(initialState: BookReaderFeature.State(bookContent: Data()), reducer: {
        BookReaderFeature()
    }))
}
