import Combine
import Observation
import Foundation
import Networking

@Observable
class JobsListViewModel: ObservableObject {
    enum Event {
        case didTapJobDetailButton(id: Int)
    }
    
    let apiService: ApiServicing
    
    private(set) var jobs: DataLoader<JobListing>!
    
    var filters: [any Filter]
    
    init(filters: [any Filter], apiService: ApiServicing) {
        self.filters = filters
        self.apiService = apiService
        self.jobs = .init(dataTask: fetchJobs)
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Loading data
    func load() async {
        await jobs.load()
    }
    
    // TODO: offer new items as a button after some time
    func loadIfNeeded() {
        guard jobs.currentData == nil else {
            return
        }
        
        Task {
            await load()
        }
    }
    
    func loadMore() {
        Task {
            await jobs.loadMore()
        }
    }
    
    private func fetchJobs(page: Int) async throws -> DataResult<[JobListing]> {
        let result: ApiResult<[JobListing]> = try await apiService.request(
            AppRoutes.jobsList(
                page: page,
                filters: filters
                    .filter(\.hasValues)
                    .flatMap { $0.queryValues }
            )
        )
        
        return DataResult(
            data: result.resultSet.removingDuplicates(),
            hasMore: result.paginator.current < result.paginator.max
        )
    }
    
    // MARK: - Actions
    func openJobDetail(id: Int) {
        eventSubject.send(.didTapJobDetailButton(id: id))
    }
}
