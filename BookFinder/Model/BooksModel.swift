import Foundation

struct Book: Sendable {
    let key: String
    let title: String
    let author: [String]
    let year: Int?
    let coverID: Int?
}

struct BookDTO: Decodable {
    let key: String
    let title: String
    let authorName: [String]?
    let firstPublishYear: Int?
    let coverID: Int?

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorName = "author_name"
        case firstPublishYear = "first_publish_year"
        case coverID = "cover_i"
    }

    func toBook() -> Book {
        Book(
            key: key,
            title: title,
            author: authorName ?? ["Unknown"],
            year: firstPublishYear,
            coverID: coverID
        )
    }
}

struct BookSearchResponseDTO: Decodable {
    let numFound: Int
    let start: Int
    let docs: [BookDTO]
}
