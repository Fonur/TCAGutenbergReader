//
//  BookDetailView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailView: View {
    let store: StoreOf<BookDetailFeature>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            VStack(alignment: .leading, content: {
                Text("\(viewStore.book.title)").font(.largeTitle)
                HStack(spacing:3, content: {
                    Text("by")
                    ForEach(viewStore.book.authors, id:\.name) { author in
                        Text("\(author.name) ")
                    }
                })
                .font(.callout)
                .foregroundStyle(.gray)
                HStack(content: {
                    Spacer()
                    AsyncImage(url: URL(string: viewStore.state.book.formats.imageJPEG)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 300)
                    }
                    Spacer()
                })
                Divider()
                HStack(alignment: .top, spacing: 5, content: {
                    ForEach(viewStore.book.bookshelves, id:\.self) { subject in
                        Text(subject)
                            .lineLimit(2)
                            .font(.caption)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .fill(.gray.opacity(0.7))
                                    .frame(height: 35)
                            }
                    }
                })
                VStack(alignment: .leading, spacing: 3) {
                    Text("About")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top)

                    HStack {
                        Label("Languages:", systemImage: "globe")
                        ForEach(viewStore.book.languages, id:\.self) { language in
                            Text("\"\(language)\" ")
                        }
                    }
                    HStack {
                        Label("Download Count:", systemImage: "number")
                        Text("\(viewStore.book.downloadCount)")
                    }
                    HStack {
                        Label("Media Type:", systemImage: "doc")
                        Text("\"\(viewStore.book.mediaType)\"")
                    }
                    HStack {
                        Label {
                            Text("Copyright:")
                        } icon: {
                            Text("©")
                        }

                        Text(viewStore.book.copyright ? "true" : "false")
                    }
                }
                Spacer()
                HStack(alignment:.center) {
                    Button {
                        viewStore.send(.setNavigation(isActive: true))
                    } label: {
                        HStack {
                            Text("Read")
                            Image(systemName: "book")
                        }
                        .font(.title3)
                        .background {
                            RoundedRectangle(cornerRadius: 15.0)
                                .stroke()
                                .frame(width: 150, height: 40, alignment: .center)
                        }
                    }
                    Spacer()
                    Button {
                        viewStore.send(.downloadButtonTapped)
                    } label: {
                        HStack {
                            Text("Download")
                            viewStore.isDownloading ?
                            AnyView(Image(systemName: "arrow.down.circle.dotted")
                                .symbolEffect(.variableColor.iterative, options: .repeating.speed(0.05)))
                            : AnyView(Image(systemName: "arrow.down.circle.dotted"))
                        }
                        .font(.title3)
                        .background {
                            RoundedRectangle(cornerRadius: 15.0)
                                .stroke()
                                .frame(width: 150, height: 40, alignment: .center)
                        }
                    }
                    .disabled(viewStore.isDownloading)
                }
                .padding(.horizontal, 40)
            })
            .navigationDestination(isPresented: viewStore.binding(
                get: \.isSettingForReady,
                send: { .setNavigation(isActive: $0) }), destination: {
                IfLetStore(
                    self.store.scope(state: \.bookReader, action: \.bookReader)
                ) {
                    BookReaderView(store: $0)
                } else: {
                    ProgressView()
                }
            })
            .alert(store: self.store.scope(state: \.$alert, action: \.alert))
            .padding(10)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Group {
                        if viewStore.isBookmarked {
                            Image(systemName: "bookmark.fill")
                        } else {
                            Image(systemName: "bookmark")
                        }
                    }
                    .onTapGesture(perform: {
                        viewStore.send(.bookmarkButtonTapped)
                    })
                }
            })
        }
    }
}

#Preview {
    NavigationStack {
        BookDetailView(store: Store(initialState: BookDetailFeature.State(book: (MockupBooks.books?.results[0])!), reducer: {
            BookDetailFeature()
        }))
    }
}
