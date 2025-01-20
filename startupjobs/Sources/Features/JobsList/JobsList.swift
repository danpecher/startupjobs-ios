import SwiftUI

struct JobsListItem: View {
    let listing: JobListing
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(listing.name)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct JobsList: View {
    let viewModel: JobsListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                switch viewModel.jobs.state {
                case .initial:
                    EmptyView()
                case .loading:
                    Text("Loading")
                case .failed(let error):
                    Text(error.localizedDescription)
                case .loaded(let items):
                    ForEach(items) { job in
                        JobsListItem(listing: job)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    let _ = PreviewApiService.previewData = try! Data(
        contentsOf: Bundle.main.url(forResource: "fakejobs", withExtension: "json")!
    )
        
    JobsList(
        viewModel: JobsListViewModel(
            apiService: PreviewApiService(delay: 1)
        )
    )
}
