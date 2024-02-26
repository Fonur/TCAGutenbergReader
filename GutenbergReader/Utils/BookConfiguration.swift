//
//  BookConfiguration.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 25.02.2024.
//

import Foundation
import FolioReaderKit

class BookConfiguration {
    static func readerConfiguration(_ bookID: String) -> FolioReaderConfig {
        let config = FolioReaderConfig(withIdentifier: bookID)
        config.shouldHideNavigationOnTap = false
        config.scrollDirection = .defaultVertical
        config.quoteCustomBackgrounds = []
        if let image = UIImage(named: "launch") {
            let customImageQuote = QuoteImage(withImage: image, alpha: 0.6, backgroundColor: UIColor.black)
            config.quoteCustomBackgrounds.append(customImageQuote)
        }

        let textColor = UIColor(red:0.86, green:0.73, blue:0.70, alpha:1.0)
        let customColor = UIColor(red:0.30, green:0.26, blue:0.20, alpha:1.0)
        let customQuote = QuoteImage(withColor: customColor, alpha: 1.0, textColor: textColor)
        config.quoteCustomBackgrounds.append(customQuote)

        return config
    }
}
