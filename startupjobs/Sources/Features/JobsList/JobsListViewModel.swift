import Combine
import SwiftUI
import Foundation
import Networking

class JobsListViewModel: ObservableObject {
    enum Event {
        case didTapJobDetailButton(id: Int)
    }
    
    let filters: [any Filter]
    let apiService: ApiServicing
    
    private var dataLoader: DataLoader<JobListing>!
    
    @Published var state: DataState<[JobListing]> = .initial
    
    var cancellables = Set<AnyCancellable>()
    
    var reachedEnd: Bool {
        dataLoader.reachedEnd
    }
    
    init(filters: [any Filter], apiService: ApiServicing) {
        self.filters = filters
        self.apiService = apiService
        self.dataLoader = .init(dataTask: fetchJobs)
        
        bindState()
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Loading data
    func load() async {
        await dataLoader.load()
    }
    
    // TODO: offer new items as a button after some time
    func loadIfNeeded() {
        guard dataLoader.currentData == nil else {
            return
        }
        
        Task {
            await load()
        }
    }
    
    func loadMore() {
        Task {
            await dataLoader.loadMore()
        }
    }
    
    // MARK: - Actions
    func openJobDetail(id: Int) {
        eventSubject.send(.didTapJobDetailButton(id: id))
    }
}

// MARK: - Private
private extension JobsListViewModel {
    func fetchJobs(page: Int) async throws -> DataResult<[JobListing]> {
        let result: ApiResult<[JobListing]> = try await apiService.request(
            AppRoutes.jobsList(
                page: page,
                filters: filters
                    .filter(\.hasValues)
                    .flatMap { $0.queryValues }
            )
        )
        
        return DataResult(
            data: result.resultSet,
            hasMore: result.paginator.current < result.paginator.max
        )
    }
    
    func bindState() {
        dataLoader.state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                guard let self else {
                    return
                }
                
                // The API returnes duplicates in case of promoted jobs -> we don't want that
                switch state {
                case let .loaded(data):
                    if self.dataLoader.currentData == nil {
                        withAnimation {
                            self.state = .loaded(data.removingDuplicates())
                        }
                    } else {
                        self.state = .loaded(data.removingDuplicates())
                    }
                case let .loadingMore(data):
                    self.state = .loadingMore(data.removingDuplicates())
                default:
                    self.state = state
                }
            })
            .store(in: &cancellables)
    }
}
