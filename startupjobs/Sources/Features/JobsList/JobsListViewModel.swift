import Combine
import Observation
import Foundation

@Observable
class JobsListViewModel: ObservableObject {
    enum Event {
        case didTapJobDetailButton(id: Int)
    }
    
    let apiService: ApiServicing
    
    private(set) var jobs: DataLoader<JobListing>!
    
    var filters: [any Filter] = [
        // TODO: Load options from backend
        // SearchableListFilter()
        ListFilter(
            title: "Obory",
            queryKey: "area[]",
            options: [
                .init(key: "vyvoj", value: "Vyvoj"),
                .init(key: "vyvoj/back-end", value: "Back-End"),
            ]
        ),
    ]
    
    init(apiService: ApiServicing) {
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
                    .reduce(into: [], { partialResult, filter in
                        partialResult.append(contentsOf: filter.queryValues)
                })
            )
        )
        
        return DataResult(
            data: result.resultSet,
            hasMore: result.paginator.current < result.paginator.max
        )
    }
    
    // MARK: - Actions
    func openJobDetaial(id: Int) {
        eventSubject.send(.didTapJobDetailButton(id: id))
    }
}
