//
//  Settings.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 21.01.2024.
//

import Foundation

struct Settings: Equatable, Codable {
    static func == (lhs: Settings, rhs: Settings) -> Bool {
        lhs.isDarkMode == rhs.isDarkMode
    }
    var isDarkMode: Bool
}
