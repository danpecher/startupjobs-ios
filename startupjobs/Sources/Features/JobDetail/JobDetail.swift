import SwiftUI
import NukeUI

struct JobDetail: View {
    let viewModel: JobDetailViewModel
    
    @State private var opacity = 0.0
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top, spacing: 24) {
                    VStack(spacing: 10) {
                        Text(viewModel.listing.company)
                            .font(Fonts.regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(viewModel.listing.name)
                            .font(Fonts.titleXL)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(JobListingFormatter.info(viewModel.listing))
                            .font(Fonts.note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        viewModel.didTapCompany()
                    } label: {
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
                    }
                }
                
                HTMLDescription(content: viewModel.listing.description)
            }
            .padding(16)
        }
        .opacity(opacity)
        .scrollIndicators(.never)
        .task {
            withAnimation(.easeIn) {
                opacity = 1
            }
            await viewModel.load()
        }
    }
}

#Preview {
    JobDetail(
        viewModel: .init(
            listing: try! JSONDecoder().decode(
                ApiResult<[JobListing]>.self,
                from: try! Data(
                    contentsOf: Bundle.main.url(forResource: "cachedjobs", withExtension: "json")!
                )
            ).resultSet.first!,
            apiService: PreviewApiService(previewData: "".data(using: .utf8))
        )
    )
}
