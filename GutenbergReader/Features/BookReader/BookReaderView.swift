//
//  BookReaderView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookReaderView: View {
    @State private var selectedPage: Int = 0

    let store: StoreOf<BookReaderFeature>
    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            ScrollView {
                Text(viewStore.showingText)
                    .lineLimit(nil)
                    .onAppear {
                        viewStore.send(.loadText)
                    }
            }
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar) {
                    HStack(content: {
                        Button("", systemImage: "chevron.backward") {
                            viewStore.send(.backwardButtonTapped)
                        }
                        Spacer()
                        Text("\(viewStore.page)")
                            .font(.headline)
                            .onTapGesture {
                                viewStore.send(.showPageNumberChangeAlertButtonTapped(true))
                            }
                        Spacer()
                        Button("", systemImage: "chevron.forward") {
                            viewStore.send(.forwardButtonTapped)
                        }
                    })
                }
            })
            .padding()
            .alert("Log in", isPresented: viewStore.binding(get: \.showingPageNumberChangeAlert, send: { .showPageNumberChangeAlertButtonTapped($0) })) {
                TextField("Number:", value: $selectedPage, formatter: NumberFormatter())
                Button("Cancel", role: .cancel) {
                    viewStore.send(.showPageNumberChangeAlertButtonTapped(false))
                }
                Button("Go") {
                    viewStore.send(.changePageNumberButtonTapped(selectedPage))
                }
            } message: {
                Text("Please enter your username and password.")
            }
        }
    }
}

#Preview {
    BookReaderView(store: Store(initialState: BookReaderFeature.State(bookContent: Data()), reducer: {
        BookReaderFeature()
    }))
}
