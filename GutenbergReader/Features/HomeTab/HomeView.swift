//
//  HomeView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 24.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct SegmentedView: View {
    let viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>
    @Namespace var name

    fileprivate func buttonUnderline(_ segment: AppTab) -> some View {
        ZStack {
            Capsule()
                .fill(Color.clear)
                .frame(height: 4)
            if viewStore.appTab == segment {
                Capsule()
                    .fill(Color.accentColor)
                    .frame(height: 4)
                    .matchedGeometryEffect(id: "Tab", in: name)
            }
        }
    }
    
    var body: some View {
        return HStack {
            Button {
                viewStore.send(.changeTab(.recentlyAdded))
            } label: {
                VStack {
                    Text("Recently Added")
                    buttonUnderline(.recentlyAdded)
                }
            }
            Button {
                viewStore.send(.changeTab(.bookmarks))
            } label: {
                VStack {
                    Text("Bookmarks")
                    buttonUnderline(.bookmarks)
                }
            }

            Spacer()
        }
    }
}

struct HomeView: View {
    let store: Store<HomeFeature.State, HomeFeature.Action>

    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            WithViewStore(self.store) { $0 } content: { viewStore in
                TabView(selection: viewStore.binding(get: \.appTab, send: { .changeTab($0) } )) {
                    BooksListView(store: store.scope(state: \.recentlyAddedTab, action: \.recentlyAddedTab))
                        .tag(AppTab.recentlyAdded)
                        .onAppear {
                            viewStore.send(.recentlyAddedTab(.onAppear))
                        }
                    BooksListView(store: store.scope(state: \.bookmarksTab, action: \.bookmarksTab))
                        .tag(AppTab.bookmarks)
                        .onAppear {
                            viewStore.send(.bookmarksTab(.onAppear))
                        }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        SegmentedView(viewStore: viewStore)
                    }
                }
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
