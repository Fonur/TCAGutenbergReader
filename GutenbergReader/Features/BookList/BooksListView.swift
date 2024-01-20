//
//  BooksListView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 15.01.2024.
//

import ComposableArchitecture
import SwiftUI

struct BooksListView: View {
    let store: StoreOf<BooksListFeature>

    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            WithViewStore(self.store, observe: {$0}) { viewStore in
                VStack(alignment: .leading, content: {
                    if viewStore.state.isLoading {
                        ProgressView()
                            .font(.largeTitle)
                    } else {
                        List(viewStore.state.books, id: \.id) { book in
                            HStack {
                                Label(book.title, systemImage: "book.closed.fill")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewStore.send(.selectedButtonTapped(book))
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                })
            }
        } destination: { store in
            BookDetailView(store: store)
        }
    }
}

#Preview {
    BooksListView(store: Store(initialState: BooksListFeature.State(), reducer: {
        BooksListFeature()
    }))
}
