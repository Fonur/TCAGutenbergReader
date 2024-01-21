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
    fileprivate func HomeView(_ viewStore: ViewStore<AppFeature.State, AppFeature.Action>) -> VStack<TupleView<(HStack<TupleView<(Spacer, Button<some View>, Spacer, Button<some View>, Spacer)>>, some View)>> {
        return VStack(alignment: .center) {
            HStack {
                Spacer()
                Button {
                    viewStore.send(.changeTab(.recentlyAdded))
                } label: {
                    Text("Recently Added")
                        .frame(width: 150, height: 50)
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
                        .frame(width: 150, height: 50)
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
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            TabView {
                HomeView(viewStore)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                SearchFeatureView(store: self.store.scope(state: \.searchTab, action: \.searchTab))
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                SettingsFeatureView(store: self.store.scope(state: \.settingsTab, action: \.settingsTab))
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }

        }
    }
}

 #Preview {
     AppFeatureView(store: GutenbergReaderApp.store)
 }
