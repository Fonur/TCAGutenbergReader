//
//  AlertState+Extensions.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 16.01.2024.
//

import Foundation
import ComposableArchitecture

extension AlertState where Action == BookDetailFeature.Action.Alert {
    static func downloadMessage() -> Self {
        Self {
            TextState("Downloaded!")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("Okay")
            }
        }
    }
}
