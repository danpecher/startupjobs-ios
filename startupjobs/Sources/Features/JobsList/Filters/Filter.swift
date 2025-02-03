typealias QueryPair = (queryKey: String, value: String)

protocol Filter<Value> {
    associatedtype Value
    
    var title: String { get }
    var label: String { get }
    var key: String { get }
    var value: Value { get }
    var queryValues: [QueryPair] { get }
    var hasValues: Bool { get }
    func onViewAppear()
    func onViewDisappear()
}
