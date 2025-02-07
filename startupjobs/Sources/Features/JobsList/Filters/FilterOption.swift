struct FilterOption: Identifiable {
    var id: String {
        key
    }
    
    let key: String
    let value: StringConvertible
    let children: [FilterOption]
    
    var flatList: [FilterOption] {
        [self] + children.flatMap { $0.flatList }
    }
    
    init(key: String, value: StringConvertible, children: [FilterOption] = []) {
        self.key = key
        self.value = value
        self.children = children
    }
}

extension FilterOption: Hashable {
    static func == (lhs: FilterOption, rhs: FilterOption) -> Bool {
        lhs.id == rhs.id && lhs.value.stringValue == rhs.value.stringValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(value.stringValue)
    }
}
