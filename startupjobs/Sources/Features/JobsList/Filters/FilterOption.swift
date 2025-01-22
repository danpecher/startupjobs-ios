struct FilterOption: Identifiable {
    var id: String {
        key
    }
    
    var key: String
    var value: StringConvertible
}
