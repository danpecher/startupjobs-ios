import Observation

enum DataState<T> {
    case initial
    case loading
    case loaded(T)
    case loadingMore(T)
    case failed(Error, T? = nil)
}

struct DataResult<T> {
    let data: T
    let hasMore: Bool
}

@Observable
class DataLoader<T: Hashable> {
    @ObservationIgnored
    private var dataTask: (Int) async throws -> DataResult<[T]>
    
    private(set) var page = 1
    
    private(set) var state: DataState<[T]> = .initial
    
    private(set) var reachedEnd = false
    
    init(dataTask: @escaping (Int) async throws -> DataResult<[T]>) {
        self.dataTask = dataTask
    }
    
    func load() async {
        do {
            page = 1
            state = .loading
            
            let result = try await dataTask(page)
            reachedEnd = !result.hasMore
            state = .loaded(result.data)
        } catch {
            state = .failed(error)
        }
    }
    
    func loadMore() async {
        guard !reachedEnd, case let .loaded(existingItems) = state else {
            return
        }
        
        page += 1
        
        do {
            state = .loadingMore(existingItems)
            let result = try await dataTask(page)
            reachedEnd = !result.hasMore
            state = .loaded((existingItems + result.data).removingDuplicates())
        } catch {
            state = .failed(error, existingItems)
        }
    }
}
