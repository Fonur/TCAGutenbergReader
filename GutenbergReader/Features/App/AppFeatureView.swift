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
        TabView {
            WithViewStore(self.store) { $0 } content: { viewStore in
              
            }

        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
/*
 #Preview {
 AppFeatureView()
 }
 */
