import SwiftUI

struct JobsList: View {
    @StateObject var viewModel: JobsListViewModel
    
    init(viewModel: JobsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                
                Text("unofficial client")
                    .font(Fonts.note)
            }
            .padding(.top, 8)
            
            FiltersToolbar(
                filters: viewModel.filters,
                didUpdateFilters: {
                    Task {
                        await viewModel.load()
                    }
                },
                onSeeAllTap: {
                    Task {
                        viewModel.showAllFilters()
                    }
                }
            )
            .padding(.vertical, 8)
            
            ScrollView {
                LazyVStack {
                    switch viewModel.state {
                    case .initial, .loading:
                        ProgressView()
                            .frame(maxHeight: .infinity)
                    case let .failed(error, _):
                        Text(error.localizedDescription)
                    case .loaded(let items), .loadingMore(let items):
                        list(items: items)
                    }
                }
            }
            .refreshable {
                // wrap in extra task to avoid getting cancelled
                Task { await viewModel.load() }
            }
        }
        .background(Colors.backgroundPrimary)
        .task {
            viewModel.loadIfNeeded()
        }
    }
    
    @ViewBuilder
    private func list(items: [JobListing]) -> some View {
        ForEach(items, id: \.id) { job in
            Button {
                viewModel.openJobDetail(job)
            } label: {
                VStack {
                    JobsListItem(
                        listing: job
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    
                    Divider()
                }
            }
            .buttonStyle(.plain)
            .tint(.black)
        }
        
        if !viewModel.reachedEnd {
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
