//
//  AppFeatureView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 19.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct AppFeatureView: View {
    let store: StoreOf<AppFeature>
    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Button {
                        viewStore.send(.changeTab(.recentlyAdded))
                    } label: {
                        Text("Recently Added")
                            .frame(width: 200, height: 75)
                            .background {
                                Rectangle()
                                    .stroke(lineWidth: 1.0)
                            }
                    }
                    Spacer()

                    Button {
                        viewStore.send(.changeTab(.bookmarks))
                    } label: {
                        Text("Bookmarks")
                            .frame(width: 200, height: 75)
                            .background {
                                Rectangle()
                                    .stroke(lineWidth: 1.0)
                            }
                    }

                    Spacer()
                }

                TabView(selection: viewStore.binding(get: \.appTab, send: { .changeTab($0) } )) {
                    BooksListView(store: store.scope(state: \.recentlyAddedTab, action: \.recentlyAddedTab))
                        .tag(AppTab.recentlyAdded)
                    BooksListView(store: store.scope(state: \.bookmarksTab, action: \.bookmarksTab))
                        .tag(AppTab.bookmarks)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
}

 #Preview {
     AppFeatureView(store: GutenbergReaderApp.store)
 }

