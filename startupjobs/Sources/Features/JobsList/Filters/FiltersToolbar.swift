import SwiftUI

struct FiltersToolbar: View {
    @State private var selected: (any Filter)? = nil
    
    let filters: [any Filter]
    let didUpdateFilters: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(filters, id: \.key) { filter in
                            filterItem(filter)
                        }
                    }
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
            HStack {
                Text(filter.label)
                Image(systemName: "chevron.down")
            }
        }
        .tint(Color("primary"))
    }
    
    var filterButton: some View {
        return HStack {
            Spacer()
            
            Button {
                
            } label: {
                VStack {
                    Image(systemName: "slider.horizontal.3")
                        .padding(2)
                        .padding(.leading, 20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(
                                    stops: [
                                        .init(color: Color(uiColor: .systemBackground).opacity(0), location: 0),
                                        .init(color: Color(uiColor: .systemBackground), location: 0.45)
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
        FiltersToolbar(filters: [], didUpdateFilters: {})

        Spacer()
    }
}
