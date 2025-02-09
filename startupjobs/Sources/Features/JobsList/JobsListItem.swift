import SwiftUI
import NukeUI

struct JobsListItem: View {
    let listing: JobListing
    
    var body: some View {
        HStack(alignment: .top) {
            CompanyImage(imageUrl: listing.imageUrl)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(listing.company)
                        .font(Fonts.regular)
                }
                
                Text(listing.name)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(4)
                    .font(Fonts.title)
                
                Text(JobListingFormatter.info(listing))
                    .font(Fonts.regular)
                    .foregroundStyle(Color.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            imageUrl: URL(string: "https://images-assets.startupjobs.cz/LOGO/3062/5764529b532eb545223c6b6904c224b2.png")!,
            salary: nil,
            locations: "Prague",
            isRemote: true
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
            imageUrl: URL(string: "https://images-assets.startupjobs.cz/LOGO/3062/5764529b532eb545223c6b6904c224b2.png")!,
            salary: nil,
            locations: "Prague",
            isRemote: true
        )
    )
    .padding()
}
