//
//  AppFeature.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 19.01.2024.
//

import Foundation
import ComposableArchitecture

enum AppTab {
    case recentlyAdded
    case bookmarks
}

@Reducer
struct AppFeature {
    struct State: Equatable {
        var appTab: AppTab = .recentlyAdded
    }

    enum Action {
        case changeTab(AppTab)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .changeTab(selectedTab):
                state.appTab = selectedTab
                return .none
            }
        }
    }
}
