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
                        .font(Fonts.regular)
                        .foregroundStyle(Colors.primary)
                    
                    if filter.value.contains(option.key) {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}
