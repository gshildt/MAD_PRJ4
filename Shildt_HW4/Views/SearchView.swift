import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                // Search Bar
                HStack {
                    TextField("Search books", text: $viewModel.query)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit {
                            Task { await viewModel.search() }
                        }
                    
                    Button {
                        Task { await viewModel.search() }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding(.horizontal)
                
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView("Loading…")
                        .padding(.top)
                }
                
                // Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Search")
            
            // The List MUST be outside the VStack to render correctly
            List(viewModel.books, id: \.id) { book in
                HStack(alignment: .top, spacing: 12) {
                    
                    URLImageView(url: book.thumbnailURL)
                    
                    VStack(alignment: .leading, spacing: 4) {
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
                    
                    Spacer()
                    
                    Button {
                        viewModel.toggleFavorite(book)
                    } label: {
                        Image(systemName: viewModel.isFavorite(book) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
        }
    }
}
