protocol Filter {
    associatedtype Value
    
    var title: String { get }
    var label: String { get }
    var queryKey: String { get }
    var value: Value { get }
    var queryValues: [(String, String)] { get }
    var hasValues: Bool { get }
}
