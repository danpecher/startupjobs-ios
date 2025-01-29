import SwiftUI

struct ListFilterView: View {
    @State var filter: ListFilter
    
    var body: some View {
        List(filter.options) { option in
            Button {
                filter.toggleOption(option)
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
