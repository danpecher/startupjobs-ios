import SwiftUI

struct ListFilterView: View {
    @State var filter: ListFilter
    
    var body: some View {
        List(filter.displayOptions) { option in
            Button {
                filter.toggleOption(option)
            } label: {
                HStack {
                    Image(systemName: filter.value.contains(option.key) ? "checkmark.circle.fill" : "checkmark.circle")
                        .fontWeight(.light)
                        .foregroundStyle(Colors.primary)
                    
                    Text(option.value.stringValue)
                        .font(Fonts.regular)
                        .foregroundStyle(Colors.primary)
                    
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
    }
}
