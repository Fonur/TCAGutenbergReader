//
//  String+Extensions.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 17.01.2024.
//

import Foundation

extension String {
    func lineRange(from: Int, to: Int) -> String {
        var newText = ""
        let array = self.components(separatedBy: .newlines)
        let to = to > array.count - 1 ? array.count - 1 : to
        if array.count <= from {
            return "THE END"
        }
        array[from..<to].enumerated().forEach { (index, text) in
            if index < to - 1  {
                newText += text + "\n"
            } else {
                newText += text
            }
        }
        return newText
    }
}
