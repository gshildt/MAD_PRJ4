import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favorites.isEmpty {
                    Text("No favorites yet.")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(viewModel.favorites) { book in
                            HStack(alignment: .top, spacing: 12) {
                                URLImageView(url: book.thumbnailURL)
                                
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                    
                                    if !book.authors.isEmpty {
                                        Text(book.authorsText)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if let publisher = book.publisher {
                                        Text(publisher)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar { EditButton() }
            .task { await viewModel.loadFavorites() }
        }
    }
}
