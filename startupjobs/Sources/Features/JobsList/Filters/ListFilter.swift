import SwiftUI
import Observation

@Observable
class ListFilter: Filter {
    var title: String
    var key: String
    var value: Set<String>
    var options: [FilterOption]

    var hasValues: Bool {
        !value.isEmpty
    }

    var label: String {
        value.isEmpty
            ? title
            : options
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
        value: Set<String> = []
    ) {
        self.title = title
        self.key = queryKey
        self.options = options
        self.value = value
    }
    
    func toggleOption(_ option: FilterOption) {
        if value.contains(option.key) {
            value.remove(option.key)
        } else {
            value.insert(option.key)
        }
    }
}
