internal import CoreData
import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("FavoritesDidChange")
}

protocol FavoritesStorageProtocol {
    func fetchFavorites() throws -> [Book]
    func isFavorite(id: String) throws -> Bool
    func addFavorite(_ book: Book) throws
    func removeFavorite(id: String) throws
}

final class FavoritesStorage: FavoritesStorageProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func fetchFavorites() throws -> [Book] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        return try context.fetch(request).compactMap { $0.toBook() }
    }
    
    func isFavorite(id: String) throws -> Bool {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return try context.count(for: request) > 0
    }
    
    func addFavorite(_ book: Book) throws {
        let entity = BookEntity(context: context)
        entity.id = book.id
        entity.title = book.title
        entity.authors = book.authors.joined(separator: ", ")
        entity.publisher = book.publisher
        entity.thumbnailURL = book.thumbnailURL?.absoluteString
        entity.bookDescription = book.description
        try context.save()
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    func removeFavorite(id: String) throws {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let results = try context.fetch(request)
        results.forEach(context.delete)
        try context.save()
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
}

extension BookEntity {
    func toBook() -> Book? {
        guard let id = id,
              let title = title,
              let authorsString = authors else { return nil }
        
        let authorsArray = authorsString
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        let url = thumbnailURL.flatMap { URL(string: $0) }
        
        return Book(
            id: id,
            title: title,
            authors: authorsArray,
            publisher: publisher,
            thumbnailURL: url,
            description: bookDescription
        )
    }
}
