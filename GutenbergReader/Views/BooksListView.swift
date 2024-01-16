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
        WithViewStore(self.store, observe: {$0}) { viewStore in
            VStack(content: {
                if viewStore.state.isLoading {
                    ProgressView()
                        .font(.largeTitle)
                } else {
                    List(viewStore.state.books, id: \.id) { book in
                        Text("\(book.title)")
                    }
                }
            })
            .task { viewStore.send(.onAppear) }
        }
    }
}

#Preview {
    BooksListView(store: Store(initialState: BooksListFeature.State(), reducer: {
        BooksListFeature()
    }))
}
