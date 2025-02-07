import SwiftUI
import Observation
import Combine

@Observable
class ListFilter: SearchableListFilter {
    typealias SearchResultType = FilterOption
    
    private static let PreviewMaxItems = 3
    
    @ObservationIgnored // Change if query needed in view
    @Published var query: String = ""
    
    let searchEnabled: Bool
    
    var title: String
    var key: String
    var value: Set<String>
    var options: [FilterOption]
    
    var filteredOptions: [FilterOption]? = nil
    
    var displayOptions: [FilterOption] {
        filteredOptions ?? options
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var previewOptions: [FilterOption] {
        Array(
            (
                // Gather all selected options
                options
                    .flatMap { $0.flatList }
                    .filter { value.contains($0.key) }
                +
                // Combine with all options, but remove duplicates
                options
            )
            .removingDuplicates()
            .prefix(Self.PreviewMaxItems)
        )
    }
    
    var hasValues: Bool {
        !value.isEmpty
    }

    var label: String {
        value.isEmpty
            ? title
            : options
                .flatMap { $0.flatList }
                .filter({ value.contains($0.key) })
                .map({ $0.value.stringValue })
                .joined(separator: ", ")
    }

    var queryValues: [QueryPair] {
        value.map({ ("\(key)[]", $0) })
    }

    init(
        title: String,
        queryKey: String,
        options: [FilterOption],
        value: Set<String> = [],
        searchEnabled: Bool = false
    ) {
        self.title = title
        self.key = queryKey
        self.options = options
        self.value = value
        self.searchEnabled = searchEnabled
    }
    
    func toggleOption(_ option: FilterOption) {
        if value.contains(option.key) {
            value.remove(option.key)
        } else {
            value.insert(option.key)
        }
    }
    
    func contains(value: String) -> Bool {
        value.contains(value)
    }
    
    func search(query: String) {
        guard !query.isEmpty else {
            filteredOptions = nil
            return
        }
        
        filteredOptions = options
            .flatMap { $0.flatList }
            .filter { $0.value.stringValue.lowercased().contains(query.lowercased()) }
    }
    
    func onViewAppear() {
        if searchEnabled {
            bindSearch()
        }
    }
    
    func onViewDisappear() {
        cancellables = []
    }
}

private extension ListFilter {
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
}
