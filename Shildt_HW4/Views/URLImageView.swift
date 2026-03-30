import SwiftUI

struct URLImageView: View {
    let url: URL?
    
    var body: some View {
        Group {
            if let url = url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        Color.gray.opacity(0.3)
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .frame(width: 60, height: 90)
        .cornerRadius(6)
    }
}
