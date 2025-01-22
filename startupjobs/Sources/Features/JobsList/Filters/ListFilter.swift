import SwiftUI

class ListFilter: Filter, ObservableObject {
    var title: String
    var queryKey: String
    @Published var value: Set<String>
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

    var queryValues: [(String, String)] {
        value.map({ (queryKey, $0) })
    }

    init(
        title: String,
        queryKey: String,
        options: [FilterOption],
        value: Set<String> = []
    ) {
        self.title = title
        self.queryKey = queryKey
        self.options = options
        self.value = value
    }
}
