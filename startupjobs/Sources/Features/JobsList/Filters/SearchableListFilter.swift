protocol SearchableListFilter<SearchResultType>: Filter where Value == Set<String> {
    associatedtype SearchResultType: Decodable
    
    var query: String { get set }
    var options: [FilterOption] { get }
    func toggleOption(_ option: FilterOption)
}
