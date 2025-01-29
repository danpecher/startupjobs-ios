import SwiftUI

struct JobsList: View {
    let viewModel: JobsListViewModel
    
    var body: some View {
        VStack {
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                
                Text("unofficial client")
                    .font(.system(size: 10))
            }
            ScrollView {
                LazyVStack {
                    FiltersToolbar(filters: viewModel.filters, didUpdateFilters: {
                        Task {
                            await viewModel.load()
                        }
                    })
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
        }
        .task {
            viewModel.loadIfNeeded()
        }
    }
    
    @ViewBuilder
    private func list(items: [JobListing]) -> some View {
        ForEach(Array(items.enumerated()), id: \.1.id) { index, job in
            Button {
                viewModel.openJobDetail(id: job.id)
            } label: {
                JobsListItem(listing: job)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.plain)
            .tint(.black)
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
    JobsList(
        viewModel: JobsListViewModel(
            filters: [],
            apiService: PreviewApiService(
                previewData: try! Data(
                    contentsOf: Bundle.main.url(forResource: "cachedjobs", withExtension: "json")!
                ),
                delay: 1
            )
        )
    )
}
