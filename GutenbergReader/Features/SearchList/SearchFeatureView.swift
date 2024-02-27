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
                    if viewStore.isSearchInProgress {
                        VStack {
                            ProgressView()
                                .font(.title3)
                            Spacer()
                        }
                    } else {
                        Form {
                            Section("Search") {
                                List(viewStore.books, id: \.id) { book in
                                    HStack {
                                        Label(
                                            title: { Text(book.title) },
                                            icon: { Image(systemName: "book.closed.fill") }
                                        )
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewStore.send(.selectedBook(book))
                                    }
                                }
                            }
                        }
                    }

                }
                .searchable(text: viewStore.binding(get: \.text, send: { value in
                        .searchTextChanged(value)
                }))
                .navigationTitle(Text("Search"))
            }
        } destination: {
            switch $0 {
            case .bookDetail:
                CaseLet(
                    \Path.State.bookDetail,
                     action: Path.Action.bookDetail,
                     then: BookDetailView.init(store:)
                )
            case .bookReader:
                CaseLet(
                    \Path.State.bookReader,
                     action: Path.Action.bookReader,
                     then: BookReaderView.init(store:)
                )
            }
        }
    }
}



#Preview {
    let store = Store(initialState: SearchFeature.State(text:"Romeo", books: [])) {
        SearchFeature()
    }

    return SearchFeatureView(store: store)
}
