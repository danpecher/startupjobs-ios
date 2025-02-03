import SwiftUI

struct FilterWrapper: View {
    let filter: (any Filter)?
    
    let onDoneTapped: () -> Void
    
    @ViewBuilder private var filterView: some View {
        switch filter {
        case let filter as any SearchableListFilter:
            SearchableListFilterView(filter: filter)
        case let filter as ListFilter:
            ListFilterView(filter: filter)
        default:
            EmptyView()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                filterView
                    .onAppear {
                        filter?.onViewAppear()
                    }
                    .onDisappear {
                        filter?.onViewDisappear()
                    }
                    .navigationTitle(filter?.title ?? "Filter")
                    .navigationBarTitleDisplayMode(.inline)
                
                
                Button {
                    onDoneTapped()
                } label: {
                    VStack {
                        Text("Done")
                            .font(Fonts.title)
                            .foregroundStyle(.white)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Colors.primary, ignoresSafeAreaEdges: [])
                    .padding(16)
                    
                }
            }
        }
    }
}

#Preview {
    FilterWrapper(
        filter: ListFilter(
            title: "Test",
            queryKey: "test",
            options: [
                .init(key: "one", value: "One"),
                .init(key: "one", value: "Two"),
            ]
        ),
        onDoneTapped: {
        })
}
