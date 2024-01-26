//
//  AboutInfoView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 21.01.2024.
//

import SwiftUI

struct AboutInfoView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("launch")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .accessibilityLabel(Text("Gutenberg Reader"))
                .padding(.bottom)

            Text("About Gutenberg Reader")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .padding(.bottom)

            Text("""
                Gutenberg Reader is an independent mobile application designed to make reading classic literature easy and enjoyable. Our app offers a simple interface for discovering and enjoying timeless works from various genres. Features include browsing categories, detailed book information, offline reading, and customizable reading settings, including a dark/light mode.
                """) + Text("\n\nPlease note: ").bold() + Text(
                    """
                 Please note: Gutenberg Reader is not affiliated with Project Gutenberg. We use the Gutendex API to source public domain books, ensuring a wide selection of classics readily available at your fingertips. \n\nEnjoy the world of classic literature with Gutenberg Reader.
                 """)
        }
        .padding()
    }
}

#Preview {
    AboutInfoView()
}
