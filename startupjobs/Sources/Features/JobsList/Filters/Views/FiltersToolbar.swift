import SwiftUI

struct FiltersToolbar: View {
    @State private var selected: (any Filter)? = nil
    
    let filters: [any Filter]
    
    /// Return filters with values first
    private var sortedFilters: [any Filter] {
        filters.sorted(by: { a, b in a.hasValues })
    }
    
    let didUpdateFilters: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(sortedFilters, id: \.key) { filter in
                            filterItem(filter)
                        }
                    }
                    .padding(.trailing, 40)
                }
                .scrollIndicators(.hidden)
            }
            
            filterButton
        }
        .padding(.horizontal)
        .sheet(isPresented: .constant(selected != nil), onDismiss: didDismissSheet) {
            FilterWrapper(filter: selected, onDoneTapped: {
                selected = nil
            })
        }
    }
}

private extension FiltersToolbar {
    func filterItem(_ filter: any Filter) -> some View {
        Button {
            selected = filter
        } label: {
            HStack(spacing: 2) {
                HStack(spacing: 5) {
                    if filter.hasValues {
                        Circle()
                            .fill(.white)
                            .frame(width: 5, height: 5)
                    }
                    
                    Text(filter.label)
                        .font(
                            filter.hasValues ? Fonts.regularBold : Fonts.regular
                        )
                        .foregroundStyle(filter.hasValues ? .white : Colors.primary)
                }
                
                Image(systemName: "chevron.down")
                    .tint(filter.hasValues ? .white : Colors.primary)
                    .font(.system(size: 12))
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 12)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Colors.primary)
            }
            .background {
                if filter.hasValues {
                    RoundedRectangle(cornerRadius: 16)
                }
            }
            
        }
        .tint(Colors.primary)
        .frame(maxWidth: 130)
    }
    
    var filterButton: some View {
        return HStack {
            Spacer()
            
            Button {
                
            } label: {
                VStack {
                    Image(systemName: "slider.horizontal.3")
                        .tint(Colors.primary)
                        .padding(10)
                        .padding(.leading, 20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(
                                    stops: [
                                        .init(color: Colors.backgroundPrimary.opacity(0), location: 0),
                                        .init(color: Colors.backgroundPrimary, location: 0.4)
                                    ]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
            }
        }
    }
    
    func didDismissSheet() {
        selected = nil
        
        // TODO: Don't update if filters didn't change
        didUpdateFilters()
    }
}

#Preview {
    VStack {
        FiltersToolbar(
            filters: [
                ListFilter(
                    title: "Work mode",
                    queryKey: "work",
                    options: [
                        .init(key: "remote", value: "Remote"),
                        .init(key: "hybrid", value: "Hybrid"),
                        .init(key: "onsite", value: "Onsite")
                    ],
                    value: ["remote", "hybrid", "onsite"]
                ),
                ListFilter(title: "Oblast", queryKey: "area", options: []),
                ListFilter(title: "Oblast", queryKey: "area", options: []),
                ListFilter(title: "Oblast", queryKey: "area", options: []),
                ListFilter(title: "Oblast", queryKey: "area", options: []),
            ],
            didUpdateFilters: {
            })

        Spacer()
    }
    .background(Colors.backgroundPrimary)
}
