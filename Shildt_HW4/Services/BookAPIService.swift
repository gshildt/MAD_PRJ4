import Foundation

protocol BookAPIServiceProtocol {
    func searchBooks(query: String) async throws -> [Book]
}

final class BookAPIService: BookAPIServiceProtocol {
    func searchBooks(query: String) async throws -> [Book] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encoded)") else {
            return []
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(BooksAPIResponse.self, from: data)
        return (decoded.items ?? []).map { Book(from: $0) }
    }
}
