import Observation

enum DataState<T> {
    case initial
    case loading
    case loaded(T)
    case failed(Error)
}

@Observable
class DataLoader<T> {
    @ObservationIgnored
    var dataTask: () async throws -> T
    
    var state: DataState<T> = .initial
    
    init(dataTask: @escaping () async throws -> T) {
        self.dataTask = dataTask
    }
    
    func load() async {
        state = .loading
        
        do {
            state = .loaded(try await dataTask())
        } catch {
            state = .failed(error)
        }
    }
}
