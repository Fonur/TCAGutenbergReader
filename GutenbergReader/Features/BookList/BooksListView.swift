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

    let columns = [
        GridItem(.adaptive(minimum: 250)),
        GridItem(.adaptive(minimum: 250))
    ]

    var body: some View {
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack(alignment: .leading, content: {
                if viewStore.state.isLoading {
                    ProgressView()
                        .font(.largeTitle)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewStore.state.books, id: \.id) { book in
                                NavigationLink(state: Path.State.bookDetail(BookDetailFeature.State(book: book))) {
                                    BookCardView(width: 180, height: 200, bookTitle: book.title, imageURL: URL(string:book.formats.imageJPEG ?? ""))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            })
        }
        .navigationBarTitleDisplayMode(.large)

    }
}

#Preview {
    BooksListView(store: Store(initialState: BooksListFeature.State(), reducer: {
        BooksListFeature()
    }))
}
