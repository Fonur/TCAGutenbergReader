//
//  SearchFeatureView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct SearchFeatureView: View {
    let store: Store<SearchFeature.State, SearchFeature.Action>

    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            WithViewStore(self.store) {
                $0
            } content: { viewStore in
                VStack {
                    Form {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Example: Romeo and Juliet", text: viewStore.binding(get: \.text, send: { value in
                                    .searchTextChanged(value)
                            }))
                        }
                        Section("Search") {
                            List(viewStore.books, id: \.id) { book in
                                NavigationLink(state: BookDetailFeature.State(book: book)) {
                                    Label(
                                        title: { Text(book.title) },
                                        icon: { Image(systemName: "book.closed.fill") }
                                    )
                                }
                            }
                        }
                    }
                }
            }
        } destination: { store in
            BookDetailView(store: store)
        }
    }
}


let store = Store(initialState: SearchFeature.State(text:"Romeo", books: [])) {
    SearchFeature()
}
#Preview {
    SearchFeatureView(store: store)
}
