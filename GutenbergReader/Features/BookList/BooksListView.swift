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
        } destination: {
            switch $0 {
            case .bookDetail:
                CaseLet(
                    \BooksListFeature.Path.State.bookDetail,
                     action: BooksListFeature.Path.Action.bookDetail,
                     then: BookDetailView.init(store:)
                )
            case .bookReader:
                CaseLet(
                    \BooksListFeature.Path.State.bookReader,
                     action: BooksListFeature.Path.Action.bookReader,
                     then: BookReaderView.init(store:)
                )
            }
        }
    }
}

#Preview {
    BooksListView(store: Store(initialState: BooksListFeature.State(), reducer: {
        BooksListFeature()
    }))
}
