import SwiftUI
import Networking
import Observation
import Combine

@Observable
class ApiSearchListFilter<SearchResultType: Decodable>: ListFilter, SearchableListFilter {
    
    @ObservationIgnored // Change if query needed in view
    @Published var query: String = ""
    private(set) var isSearching = false
    
    private let apiService: ApiServicing
    private let searchRouteProvider: (String) -> Route
    private let optionsParser: (SearchResultType) -> [FilterOption]
    
    private var cancellables = Set<AnyCancellable>()
    
    private var searchTask: Task<(), Never>?
    
    init(
        apiService: ApiServicing,
        title: String,
        queryKey: String,
        value: Set<String>,
        searchRouteProvider: @escaping (String) -> Route,
        optionsParser: @escaping (SearchResultType) -> [FilterOption]
    ) {
        self.apiService = apiService
        self.searchRouteProvider = searchRouteProvider
        self.optionsParser = optionsParser
        
        super.init(
            title: title,
            queryKey: queryKey,
            options: []
        )
    }
    
    override func onViewAppear() {
        super.onViewAppear()
        bindSearch()
    }
    
    override func onViewDisappear() {
        super.onViewDisappear()
        cancellables = []
    }
}

private extension ApiSearchListFilter {
    func bindSearch() {
        // TODO: Don't run search when we have results and query didn't change
        $query
            .debounce(for: 0.4, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.search(query: value)
            }
        .store(in: &cancellables)
    }
    
    func search(query: String) {
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                let result: SearchResultType = try await apiService.request(searchRouteProvider(query))
                
                options = optionsParser(result)
            } catch {
                print(error)
                return
            }
        }
    }
}

// Default parser of the filter options API result.
extension ApiSearchListFilter where SearchResultType == [FilterOptionsSearchResult] {
    convenience init(
        apiService: ApiServicing,
        title: String,
        queryKey: String,
        value: Set<String>,
        searchRouteProvider: @escaping (String) -> Route
    ) {
        self.init(
            apiService: apiService,
            title: title,
            queryKey: queryKey,
            value: value,
            searchRouteProvider: searchRouteProvider,
            optionsParser: Self.defaultOptionsParser
        )
    }
    
    private static func defaultOptionsParser(items: SearchResultType) -> [FilterOption] {
        items.map {
            FilterOption(
                key: $0.urlIdentifier,
                value: $0.name
            )
        }
    }
}
