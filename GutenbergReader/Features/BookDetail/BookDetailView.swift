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
            ScrollView {
                VStack(alignment: .leading, content: {
                    Text("\(viewStore.book.title)")
                        .font(.custom("CormorantGaramond-Regular", size: 32))
                        .fontWeight(.bold)
                    HStack(spacing:3, content: {
                        Text("by")
                        ForEach(viewStore.book.authors, id:\.name) { author in
                            Text("\(author.name) ")
                        }
                    })
                    .font(.callout)
                    .italic()
                    .foregroundStyle(.gray)
                    HStack(content: {
                        Spacer()
                        AsyncImage(url: URL(string: viewStore.state.book.formats.imageJPEG ?? "")) { image in
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
                                .foregroundStyle(Color.white)
                                .lineLimit(2)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(Color("DarkGray"))
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
                        NavigationLink(state: Path.State.bookReader(BookReaderFeature.State(bookContent: viewStore.bookContent ?? Data()))) {
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
                        .disabled(!viewStore.isDownloadedBook)
                        .padding(.leading, 20)
                        Spacer()
                        Button {
                            viewStore.send(.downloadButtonTapped)
                        } label: {
                            HStack {
                                viewStore.isDownloadedBook ? Text("Downloaded") : Text("Download")
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
                        .disabled(viewStore.isDownloading || viewStore.isDownloadedBook)
                        .padding(.trailing, 20)
                    }
                    .padding()
                })
            }

            .onAppear(perform: {
                viewStore.send(.onAppear)
            })
            .padding(10)
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
