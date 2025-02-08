import SwiftUI
import NukeUI

struct JobDetail: View {
    let listing: JobListing
    
    private let viewModel: JobListingViewModel
    
    init(listing: JobListing) {
        self.listing = listing
        self.viewModel = JobListingViewModel(listing: listing)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top, spacing: 24) {
                    VStack(spacing: 10) {
                        Text(listing.company)
                            .font(Fonts.regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(listing.name)
                            .font(Fonts.titleXL)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(viewModel.info)
                            .font(Fonts.note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    LazyImage(url: listing.imageUrl, content: { state in
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
                
                JobDetailDescription(content: listing.description)
            }
            .padding(16)
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    JobDetail(
        listing: try! JSONDecoder().decode(
            ApiResult<[JobListing]>.self,
            from: try! Data(
                contentsOf: Bundle.main.url(forResource: "cachedjobs", withExtension: "json")!
            )
        ).resultSet.first!
    )
}
