//
//  BookCardView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 25.01.2024.
//

import SwiftUI

struct BookCardView: View {
    let width: CGFloat
    let height: CGFloat
    let bookTitle: String
    let imageURL: URL?

    var body: some View {
        ZStack(alignment:.bottom) {
            VStack {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:width)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 15.0, topTrailing: 15.0)))
                } placeholder: {
                    Image(systemName: "book.pages")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width)
                }

                Spacer()
            }
            Color.black.opacity(0.8)
                .frame(height: height / 2.5)
                .overlay {
                    Text(bookTitle)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 15.0, bottomTrailing: 15.0)))

            RoundedRectangle(cornerRadius: 15.0)
                .stroke()
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    BookCardView(width: 200, height: 250, bookTitle: "Hello World", imageURL: URL(string:"https://www.gutenberg.org/cache/epub/46/pg46.cover.medium.jpg"))
}
