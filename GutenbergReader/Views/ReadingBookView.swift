//
//  ReadingBookView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 26.02.2024.
//

import SwiftUI
import FolioReaderKit

// SwiftUI wrapper for FolioReaderContainer
struct ReadingBookView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    let bookID: String
    let folioReader: FolioReader

    func makeUIViewController(context: Context) -> FolioReaderContainer {
        let config: FolioReaderConfig  = BookConfiguration.readerConfiguration(bookID)
        config.tintColor = UIColor(Color.accentColor)
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(bookID).epub")
        let bookPath = fileURL.path
        let folioReaderContainer = FolioReaderContainer(withConfig: config, folioReader: folioReader, epubPath: bookPath)
        self.folioReader.delegate = context.coordinator
        return folioReaderContainer

    }

    func updateUIViewController(_ uiViewController: FolioReaderContainer, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension ReadingBookView {
    class Coordinator: NSObject, FolioReaderDelegate  {
        var parent: ReadingBookView
        init(_ parent: ReadingBookView) {
            self.parent = parent
        }

        func folioReaderDidClose(_ folioReader: FolioReader) {
            parent.dismiss()
        }
    }
}
