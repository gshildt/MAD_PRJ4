import Foundation

struct Book: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let authors: [String]
    let publisher: String?
    let thumbnailURL: URL?
    let description: String?
    
    var authorsText: String {
        authors.joined(separator: ", ")
    }
}

extension Book {
    init(from item: BookItem) {
        self.id = item.id
        self.title = item.volumeInfo.title ?? "Untitled"
        self.authors = item.volumeInfo.authors ?? []
        self.publisher = item.volumeInfo.publisher
        self.description = item.volumeInfo.description
        
        if let thumb = item.volumeInfo.imageLinks?.thumbnail,
           let url = URL(string: thumb.replacingOccurrences(of: "http://", with: "https://")) {
            self.thumbnailURL = url
        } else {
            self.thumbnailURL = nil
        }
    }
}
