import NukeUI
import SwiftUI

struct CompanyDetail: View {
    let viewModel: CompanyDetailViewModel
    
    var body: some View {
        ScrollView {
            switch viewModel.state {
            case .initial, .loading, .loadingMore:
                ProgressView()
                    .containerRelativeFrame([.horizontal, .vertical])
            case let .failed(error, _):
                Text(error.localizedDescription)
            case .loaded(let company):
                if let coverPhoto = company.coverPhoto {
                    LazyImage(url: coverPhoto, content: { state in
                        if let image = state.image {
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } else {
                            Rectangle()
                                .frame(height: 200)
                        }
                    })
                }
                
                VStack {
                    HStack {
                        Text(company.name)
                            .font(Fonts.titleXL)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 24)
                        
                        Spacer()
                        
                        CompanyImage(imageUrl: company.logo)
                    }
                    
                    if let intro = company.intro {
                        HTMLDescription(content: intro)
                    }
                    
                    if let description = company.description {
                        HTMLDescription(content: description)
                    }
                    
                    Text("Current openings")
                        .font(Fonts.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 24)
                    
                    ForEach(company.offers) { offer in
                        Button {
                            viewModel.didTapJobListing(offer)
                        } label: {
                            JobsListItem(listing: offer)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
            }
        }
        .ignoresSafeArea(edges: .top)
        .task {
            await viewModel.load()
        }
    }
}

