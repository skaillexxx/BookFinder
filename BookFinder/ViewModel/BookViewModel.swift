import Foundation
import Observation

@MainActor
@Observable
final class BookViewModel {
    var errorMessage: String?
    var isLoading = false
    var books: [Book] = []
    private var searchID = 0
    private let service: BookServiceProtocol

    init(bookFinderService: BookServiceProtocol) {
        service = bookFinderService
    }

    func searchBooks(query: String) async {
        isLoading = true
        errorMessage = nil
        searchID += 1
        let currentSearchID = searchID
        defer {
            if currentSearchID == searchID {
                isLoading = false
            }
        }

        do {
            let result = try await service.searchBooks(query: query)

            guard !Task.isCancelled else {
                return
            }

            books = result
        } catch {
            guard !Task.isCancelled else {
                return
            }
            errorMessage = error.localizedDescription
        }
    }
}
