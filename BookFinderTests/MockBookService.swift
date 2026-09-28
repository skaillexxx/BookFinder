import Foundation

@testable import BookFinder

final class MockBookService: BookServiceProtocol {
    var receivedQuery: String?
    var shouldFail = false
    func searchBooks(query: String) async throws -> [Book] {
        receivedQuery = query
        try await Task.sleep(for: .seconds(1))
        if shouldFail {
            throw NetworkingError.badStatusCode(500)
        }
        return [
            Book(
                key: "001-1",
                title: "Гарри Поттер",
                author: ["Александр"],
                year: nil,
                coverID: nil
            ),
            Book(
                key: "002-2",
                title: "Влестелин Колец",
                author: ["Наташка"],
                year: nil,
                coverID: nil
            ),
            Book(
                key: "003-3",
                title: "Наташенька какашенька",
                author: ["Дениска"],
                year: nil,
                coverID: nil
            ),
        ]
    }
}
