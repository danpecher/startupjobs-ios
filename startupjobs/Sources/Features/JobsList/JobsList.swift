import SwiftUI

struct JobsList: View {
    let viewModel: JobsListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                FiltersToolbar()
                    .environmentObject(viewModel)
                
                switch viewModel.jobs.state {
                case .initial:
                    EmptyView()
                case .loading:
                    Text("Loading")
                case let .failed(error, _):
                    Text(error.localizedDescription)
                case .loaded(let items), .loadingMore(let items):
                    list(items: items)
                }
            }
        }
        .refreshable {
            await viewModel.load()
        }
        .task {
            await viewModel.load()
        }
    }
    
    @ViewBuilder
    private func list(items: [JobListing]) -> some View {
        ForEach(Array(items.enumerated()), id: \.1.id) { index, job in
            JobsListItem(listing: job)
                .padding(.horizontal)
                .padding(.vertical, 8)
        }
        
        if !viewModel.jobs.reachedEnd {
            ProgressView()
                .onAppear {
                    viewModel.loadMore()
                }
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
