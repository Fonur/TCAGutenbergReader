//
//  BooksListView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 15.01.2024.
//

import ComposableArchitecture
import SwiftUI

struct BooksListView: View {
    @State var store = Store(initialState: BooksListFeature.State()) {
        BooksListFeature()
    }

    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack(alignment: .leading, content: {
                if viewStore.state.isLoading {
                    ProgressView()
                        .font(.largeTitle)
                } else {
                    List(viewStore.state.books, id: \.id) { book in
                        NavigationLink(state: Path.State.bookDetail(BookDetailFeature.State(book: book))) {
                            Label(book.title, systemImage: "book.closed.fill")
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            })
        }
    }
}

#Preview {
    BooksListView(store: Store(initialState: BooksListFeature.State(), reducer: {
        BooksListFeature()
    }))
}
