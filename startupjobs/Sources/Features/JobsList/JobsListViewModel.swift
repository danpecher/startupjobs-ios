import Combine
import Observation
import Foundation

@Observable
class JobsListViewModel {
    enum Event {
        case didTapJobDetailButton(id: Int)
    }
    
    let apiService: ApiServicing
    
    private(set) var jobs: DataLoader<JobListing>!
    
    init(apiService: ApiServicing) {
        self.apiService = apiService
        self.jobs = .init(dataTask: fetchJobs)
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func load() async {
        await jobs.load()
    }
    
    func loadMore() {
        Task {
            await jobs.loadMore()
        }
    }
    
    private func fetchJobs(page: Int) async throws -> DataResult<[JobListing]> {
        let result: ApiResult<[JobListing]> = try await apiService.request(
            AppRoutes.jobsList(page: page)
        )
        
        return DataResult(
            data: result.resultSet,
            hasMore: result.paginator.current < result.paginator.max
        )
    }
    
    func openJobDetaial(id: Int) {
        eventSubject.send(.didTapJobDetailButton(id: id))
    }
}
