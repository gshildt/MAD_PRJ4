import Foundation

struct BooksAPIResponse: Codable {
    let items: [BookItem]?
}

struct BookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publisher: String?
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let thumbnail: String?
}
