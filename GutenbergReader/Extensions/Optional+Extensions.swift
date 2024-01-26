//
//  Optional+Extensions.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 25.01.2024.
//

import Foundation
import SwiftUI

extension Optional: RawRepresentable where Wrapped: Codable {
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self) else {
            return "{}"
        }
        return String(decoding: data, as: UTF8.self)
    }

    public init?(rawValue: String) {
        guard let value = try? JSONDecoder().decode(Self.self, from: Data(rawValue.utf8)) else {
            return nil
        }
        self = value
    }
}
