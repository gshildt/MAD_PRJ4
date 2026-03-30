import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published var favorites: [Book] = []
    @Published var errorMessage: String?
    
    private let storage: FavoritesStorageProtocol
    
    init(storage: FavoritesStorageProtocol? = nil) {
        self.storage = storage ?? FavoritesStorage()
        Task { await loadFavorites() }
    }
    
    func loadFavorites() async {
        do {
            favorites = try storage.fetchFavorites()
        } catch {
            errorMessage = "Failed to load favorites."
        }
    }
    
    func delete(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let book = favorites[index]
                try? storage.removeFavorite(id: book.id)
            }
            await loadFavorites()
        }
    }
}

