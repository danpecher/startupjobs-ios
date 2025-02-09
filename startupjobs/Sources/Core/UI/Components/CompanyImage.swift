import SwiftUI
import NukeUI

struct CompanyImage: View {
    let imageUrl: URL
    
    var body: some View {
        LazyImage(url: imageUrl, content: { state in
            if let image = state.image {
                image.resizable()
                    .scaledToFit()
                    .transition(.opacity)
                    .aspectRatio(contentMode: .fit)
            }
        })
        .frame(width: 64, height: 64)
        .padding(6)
        .background(Colors.logoBackground)
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color(uiColor: .systemGray5), lineWidth: 1)
        }
    }
}
