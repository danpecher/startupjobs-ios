import SwiftUI

struct JobsListItem: View {
    let listing: JobListing
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(listing.company).font(.system(size: 20, weight: .semibold))
                Text(listing.name)
                Text("Praha • 100k • Remote")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray)
            }
            
            Spacer()
            
            VStack {
                AsyncImage(url: listing.imageUrl) { image in
                    image.image?.resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 96)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
        }
    }
}

#Preview {
    JobsListItem(
        listing: .init(
            id: 1,
            name: "Fullstack developer",
            description: "We are looking for a fullstack developer to join our team.",
            url: URL(string: "https://google.com")!,
            company: "Windyty",
            imageUrl: URL(string: "https://images-assets.startupjobs.cz/LOGO/3062/5764529b532eb545223c6b6904c224b2.png")!
        )
    )
    .padding()
    
    JobsListItem(
        listing: .init(
            id: 1,
            name: "🚀 Golang vývojář - web3 tržiště pro Ubisoft a další přední herní studia 🇨🇦",
            description: "We are looking for a fullstack developer to join our team.",
            url: URL(string: "https://google.com")!,
            company: "LOGEX Solution Center s.r.o.",
            imageUrl: URL(string: "https://images-assets.startupjobs.cz/LOGO/3062/5764529b532eb545223c6b6904c224b2.png")!
        )
    )
    .padding()
}
