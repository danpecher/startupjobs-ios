import SwiftUI

struct SearchableListFilterView: View {
    @State var filter: any SearchableListFilter
    
    let children: [FilterOption]?
    
    init(filter: any SearchableListFilter, children: [FilterOption]? = nil) {
        self.filter = filter
        self.children = children
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(children ?? filter.displayOptions) { option in
                    item(option)
                }
                .listStyle(.plain)
            }
            .searchable(text: $filter.query, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
    
    private func item(_ option: FilterOption) -> some View {
        HStack(spacing: 12) {
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
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .layoutPriority(1)
            
            if !option.children.isEmpty {
                NavigationLink {
                    SearchableListFilterView(
                        filter: filter,
                        children: option.children
                    )
                } label: {}
                    .buttonStyle(.plain)
            }
        }
    }
}
