import SwiftUI
import Networking
import Observation
import Combine

@Observable
class ApiSearchListFilter<SearchResultType: Decodable>: ListFilter {
    private let apiService: ApiServicing
    private let searchRouteProvider: (String) -> Route
    private let optionsParser: (SearchResultType) -> [FilterOption]
    
    override var previewOptions: [FilterOption] {
        options.filter { value.contains($0.key) }
    }
    
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
            options: [],
            value: value,
            searchEnabled: true
        )
    }
    
    override func search(query: String) {
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                let result: SearchResultType = try await apiService.request(searchRouteProvider(query))
                
                // Add currently selected options to the top of results
                let selectedOptions = options
                    .filter { value.contains($0.key) }
                
                // and remove them from received results
                let receivedOptions = optionsParser(result)
                    .filter { !value.contains($0.key) }
                options = selectedOptions + receivedOptions
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
