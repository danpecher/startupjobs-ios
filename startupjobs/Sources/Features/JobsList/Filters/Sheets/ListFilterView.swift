import SwiftUI

struct ListFilterView: View {
    @StateObject var filter: ListFilter
    
    var body: some View {
        List(filter.options) { option in
            Button {
                if filter.value.contains(option.key) {
                    filter.value.remove(option.key)
                } else {
                    filter.value.insert(option.key)
                }
            } label: {
                HStack {
                    Text(option.value.stringValue)
                    
                    if filter.value.contains(option.key) {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
            }
        }
    }
}
