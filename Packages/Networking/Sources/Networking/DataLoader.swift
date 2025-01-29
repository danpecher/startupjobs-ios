import Observation

@Observable
public class DataLoader<T: Hashable> {
    /// - Parameter page: The page number to fetch
    typealias DataTask = (_ page: Int) async throws -> DataResult<[T]>
    
    @ObservationIgnored
    /// Provide a function that fetches data
    private var dataTask: DataTask
    
    private(set) var page = 1
    
    public private(set) var state: DataState<[T]> = .initial
    
    public var currentData: [T]? {
        guard case let .loaded(t) = state else {
            return nil
        }
        
        return t
    }
    
    public private(set) var reachedEnd = false
    
    public init(dataTask: @escaping (Int) async throws -> DataResult<[T]>) {
        self.dataTask = dataTask
    }
    
    public func load() async {
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
    
    public func loadMore() async {
        guard !reachedEnd, case let .loaded(existingItems) = state else {
            return
        }
        
        page += 1
        
        do {
            state = .loadingMore(existingItems)
            let result = try await dataTask(page)
            reachedEnd = !result.hasMore
            state = .loaded(existingItems + result.data)
        } catch {
            state = .failed(error, existingItems)
        }
    }
}
