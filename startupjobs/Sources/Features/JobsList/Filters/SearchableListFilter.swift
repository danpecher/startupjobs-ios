protocol SearchableListFilter<SearchResultType>: Filter where Value == Set<String> {
    associatedtype SearchResultType
    
    var query: String { get set }
    var displayOptions: [FilterOption] { get }
    var searchEnabled: Bool { get }
    func toggleOption(_ option: FilterOption)
}
