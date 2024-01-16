//
//  BookDetailView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailView: View {
    let store: StoreOf<BookDetailFeature>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            VStack {
                
            }
            .navigationTitle(Text("\(viewStore.book.title)"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    NavigationStack {
        BookDetailView(store: Store(initialState: BookDetailFeature.State(book: (MockupBooks.books?.results[0])!), reducer: {
            BookDetailFeature()
        }))
    }
}
