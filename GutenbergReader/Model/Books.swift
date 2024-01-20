// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let books = try? JSONDecoder().decode(Books.self, from: jsonData)

import Foundation

// MARK: - Books
struct Books: Equatable, Codable {
    var count: Int
    var next: String?
    var previous: JSONNull?
    var results: [Book]

    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results = "results" // Set the custom coding key for the results property
    }
}

// MARK: - Result
struct Book: Equatable, Codable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id && lhs.isBookmarked == rhs.isBookmarked
    }

    var id: Int
    var title: String
    var authors, translators: [Author]
    var subjects, bookshelves: [String]
    var languages: [String]
    var copyright: Bool
    var mediaType: String
    var formats: Formats
    var downloadCount: Int
    var isBookmarked = false

    enum CodingKeys: String, CodingKey {
        case id, title, authors, translators, subjects, bookshelves, languages, copyright
        case mediaType = "media_type"
        case formats
        case downloadCount = "download_count"
    }
}

// MARK: - Author
struct Author: Codable {
    var name: String
    var birthYear, deathYear: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case birthYear = "birth_year"
        case deathYear = "death_year"
    }
}

// MARK: - Formats
struct Formats: Codable {
    var textHTML, applicationEpubZip, applicationXMobipocketEbook: String?
    var applicationRDFXML: String?
    var imageJPEG: String?
    var textPlainCharsetUsASCII: String?
    var applicationOctetStream: String?
    var textHTMLCharsetUTF8: String?
    var textPlainCharsetUTF8, textPlainCharsetISO88591: String?
    var textHTMLCharsetISO88591: String?

    enum CodingKeys: String, CodingKey {
        case textHTML = "text/html"
        case applicationEpubZip = "application/epub+zip"
        case applicationXMobipocketEbook = "application/x-mobipocket-ebook"
        case applicationRDFXML = "application/rdf+xml"
        case imageJPEG = "image/jpeg"
        case textPlainCharsetUsASCII = "text/plain; charset=us-ascii"
        case applicationOctetStream = "application/octet-stream"
        case textHTMLCharsetUTF8 = "text/html; charset=utf-8"
        case textPlainCharsetUTF8 = "text/plain; charset=utf-8"
        case textPlainCharsetISO88591 = "text/plain; charset=iso-8859-1"
        case textHTMLCharsetISO88591 = "text/html; charset=iso-8859-1"
    }
}

enum Language: String, Codable {
    case en = "en"
}



// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
