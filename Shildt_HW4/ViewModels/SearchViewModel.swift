import SwiftUI
import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    var objectWillChange: ObservableObjectPublisher
    
    @Published var query: String = ""
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let api: BookAPIServiceProtocol
    private let favoritesStorage: FavoritesStorageProtocol
    
    @Published var favoriteIDs: Set<String> = []
    
    init(api: BookAPIServiceProtocol, favoritesStorage: FavoritesStorageProtocol) {
        self.objectWillChange = .init()
        self.api = api
        self.favoritesStorage = favoritesStorage
        Task { await loadFavorites() }
    }

    @MainActor
    convenience init() {
        self.init(api: BookAPIService(), favoritesStorage: FavoritesStorage())
    }
    
    func search() async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            books = try await api.searchBooks(query: query)
            print("Loaded books: \(books)") // Debug print statement
        } catch {
            errorMessage = "Failed to load books."
            print("Error: \(error)") // Debug print statement
        }
        
        isLoading = false
    }
    
    func toggleFavorite(_ book: Book) {
        Task {
            do {
                if favoriteIDs.contains(book.id) {
                    try favoritesStorage.removeFavorite(id: book.id)
                    favoriteIDs.remove(book.id)
                } else {
                    try favoritesStorage.addFavorite(book)
                    favoriteIDs.insert(book.id)
                }
            } catch { }
        }
    }
    
    func isFavorite(_ book: Book) -> Bool {
        favoriteIDs.contains(book.id)
    }
    
    private func loadFavorites() async {
        do {
            let favorites = try favoritesStorage.fetchFavorites()
            favoriteIDs = Set(favorites.map { $0.id })
        } catch { }
    }
}

