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
            ScrollView {
                Text(viewStore.showingText)
                    .lineLimit(nil)
                    .onAppear {
                        viewStore.send(.loadText)
                    }
            }
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar) {
                    HStack(content: {
                        Button("", systemImage: "chevron.backward") {
                            viewStore.send(.backwardButtonTapped)
                        }
                        Spacer()
                        Button("", systemImage: "chevron.forward") {
                            viewStore.send(.forwardButtonTapped)
                        }
                    })
                }
            })
            .padding()
        }
    }
}

#Preview {
    BookReaderView(store: Store(initialState: BookReaderFeature.State(bookContent: Data()), reducer: {
        BookReaderFeature()
    }))
}
