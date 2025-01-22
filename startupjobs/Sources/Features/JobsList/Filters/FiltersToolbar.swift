import SwiftUI

struct FiltersToolbar: View {
    @EnvironmentObject var viewModel: JobsListViewModel

    @State private var selected: (any Filter)? = nil
    
    var body: some View {
        ZStack {
            HStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.filters, id: \.queryKey) { filter in
                            filterItem(filter)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            
            filterButton
        }
        .padding(.horizontal)
        .sheet(isPresented: .constant(selected != nil), onDismiss: {
            selected = nil
            
            Task {
                await viewModel.load()
            }
        }) {
            VStack {
                switch selected {
                case let filter as ListFilter:
                    ListFilterView(filter: filter)
                default:
                    EmptyView()
                }
                
                Button {
                    selected = nil
                    
                    Task {
                        await viewModel.load()
                    }
                } label: {
                    Text("Done")
                }
            }
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
}

#Preview {
    VStack {
        FiltersToolbar()
            .environmentObject(
                JobsListViewModel(apiService: PreviewApiService())
            )
        Spacer()
    }
}
