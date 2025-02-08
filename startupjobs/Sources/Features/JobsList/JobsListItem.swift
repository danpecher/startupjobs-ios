import SwiftUI
import NukeUI

struct JobsListItem: View {
    let viewModel: JobsListItemViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            LazyImage(url: viewModel.listing.imageUrl, content: { state in
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
            
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(viewModel.listing.company)
                        .font(Fonts.regular)
                }
                
                Text(viewModel.listing.name)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(4)
                    .font(Fonts.title)
                
                Text(viewModel.info)
                    .font(Fonts.regular)
                    .foregroundStyle(Color.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    JobsListItem(
        viewModel: .init(listing: .init(
            id: 1,
            name: "Fullstack developer",
            description: "We are looking for a fullstack developer to join our team.",
            url: URL(string: "https://google.com")!,
            company: "Windyty",
            imageUrl: URL(string: "https://images-assets.startupjobs.cz/LOGO/3062/5764529b532eb545223c6b6904c224b2.png")!,
            salary: nil,
            locations: "Prague",
            isRemote: true
        ))
    )
    .padding()
    
    JobsListItem(
        viewModel: .init(listing: .init(
            id: 1,
            name: "🚀 Golang vývojář - web3 tržiště pro Ubisoft a další přední herní studia 🇨🇦",
            description: "We are looking for a fullstack developer to join our team.",
            url: URL(string: "https://google.com")!,
            company: "LOGEX Solution Center s.r.o.",
            imageUrl: URL(string: "https://images-assets.startupjobs.cz/LOGO/3062/5764529b532eb545223c6b6904c224b2.png")!,
            salary: nil,
            locations: "Prague",
            isRemote: true
        ))
    )
    .padding()
}
