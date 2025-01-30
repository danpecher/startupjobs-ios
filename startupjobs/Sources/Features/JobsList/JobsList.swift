import SwiftUI

struct JobsList: View {
    @StateObject var viewModel: JobsListViewModel
    
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
            
            
            FiltersToolbar(filters: viewModel.filters, didUpdateFilters: {
                Task {
                    await viewModel.load()
                }
            })
            
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
        }
        .refreshable {
            await viewModel.load()
        }
        .background(Colors.backgroundPrimary)
        .task {
            viewModel.loadIfNeeded()
        }
    }
    
    @ViewBuilder
    private func list(items: [JobListing]) -> some View {
        ForEach(Array(items.enumerated()), id: \.1.id) {
            index,
            job in
            Button {
                viewModel.openJobDetail(id: job.id)
            } label: {
                VStack {
                    JobsListItem(
                        viewModel: .init(
                            listing: job
                        )
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 14)
                    
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
