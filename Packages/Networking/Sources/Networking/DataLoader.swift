import Combine

public class DataLoader<T: Hashable> {
    /// - Parameter page: The page number to fetch
    typealias DataTask = (_ page: Int) async throws -> DataResult<[T]>
    
    /// Provide a function that fetches data
    private var dataTask: DataTask
    
    public var currentData: [T]? {
        guard case let .loaded(t) = state.value else {
            return nil
        }
        
        return t
    }
    
    // MARK: - State variables
    public private(set) var state = CurrentValueSubject<DataState<[T]>, Never>(.initial)
    
    private(set) var page = 1
    
    public private(set) var reachedEnd = false
    
    public init(dataTask: @escaping (Int) async throws -> DataResult<[T]>) {
        self.dataTask = dataTask
    }
    
    public func load() async {
        do {
            page = 1
            state.send(.loading)
            
            let result = try await dataTask(page)
            reachedEnd = !result.hasMore
            state.send(.loaded(result.data))
        } catch {
            state.send(.failed(error))
        }
    }
    
    public func loadMore() async {
        guard !reachedEnd, case let .loaded(existingItems) = state.value else {
            return
        }
        
        page += 1
        
        do {
            state.send(.loadingMore(existingItems))
            let result = try await dataTask(page)
            reachedEnd = !result.hasMore
            state.send(.loaded(existingItems + result.data))
        } catch {
            state.send(.failed(error, existingItems))
        }
    }
}
