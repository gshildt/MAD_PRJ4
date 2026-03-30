import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .onAppear { print("SearchView loaded") } // Debug print
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .onAppear { print("FavoritesView loaded") } // Debug print
        }
    }
}
