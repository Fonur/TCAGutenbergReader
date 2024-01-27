//
//  Settings.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 21.01.2024.
//

import Foundation

enum ThemeMode: String {
    case lightTheme = "lightTheme"
    case darkTheme = "darkTheme"
    case defaultTheme = "defaultTheme"
}

struct Settings: Equatable, Codable {

    static func ==(lhs: Settings, rhs: Settings) -> Bool {
        return lhs.themeMode.rawValue == rhs.themeMode.rawValue
    }

    var themeMode: ThemeMode

    enum CodingKeys: CodingKey {
        case themeMode
    }
    
    init(themeMode: ThemeMode) {
        self.themeMode = themeMode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.themeMode = ThemeMode(rawValue: try container.decode(String.self, forKey: .themeMode))!
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(themeMode.rawValue, forKey: .themeMode)
    }
}
