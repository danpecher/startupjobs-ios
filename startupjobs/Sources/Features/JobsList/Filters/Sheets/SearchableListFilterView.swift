import SwiftUI

struct SearchableListFilterView: View {
    @State var filter: any SearchableListFilter
    
    var body: some View {
        VStack {
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
        .searchable(text: $filter.query)
    }
}
