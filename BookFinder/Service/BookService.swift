import Foundation

protocol BookServiceProtocol {
    func searchBooks(query: String) async throws -> [Book]
}

final class BookService: BookServiceProtocol {

    func searchBooks(query: String) async throws -> [Book] {
        guard
            var components = URLComponents(
                string: "https://openlibrary.org/search.json"
            )
        else {
            throw NetworkingError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

        guard let url = components.url else {
            throw NetworkingError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidServerResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkingError.badStatusCode(httpResponse.statusCode)
        }

        let responseDTO = try JSONDecoder().decode(
            BookSearchResponseDTO.self,
            from: data
        )

        return responseDTO.docs.map { $0.toBook() }
    }
}



enum NetworkingError: LocalizedError {
    case invalidURL
    case invalidServerResponse
    case badStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Ошибка в URL"
        case .badStatusCode(let statusCode):
            "Код ошибки: \(statusCode)"
        case .invalidServerResponse:
            "Ошибка сервера"
        }
    }
}
