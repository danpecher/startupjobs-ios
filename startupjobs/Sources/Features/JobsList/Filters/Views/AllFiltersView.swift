import SwiftUI

struct AllFiltersView: View {
    let filters: [any Filter]
    
    let didTapSeeAll: (any Filter) -> Void
    let didTapDone: () -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(filters, id: \.key) { filter in
                        filterSection(filter: filter)
                    }
                }
                .padding(16)
            }
            .scrollIndicators(.hidden)
            
            Button {
                didTapDone()
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
        .background(Colors.backgroundPrimary)
    }
    
    private func filterSection(filter: any Filter) -> some View {
        VStack {
            Text(filter.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Fonts.title)
                .padding(.bottom, 8)
            
            switch filter {
            case let filter as ListFilter:
                listPreview(filter: filter)
                
                if filter is (any SearchableListFilter) {
                    Button {
                        didTapSeeAll(filter)
                    } label: {
                        Text("Select value")
                            .font(Fonts.regular)
                            .foregroundStyle(Colors.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .border(Colors.primary)
                    }
                }
            default:
                EmptyView()
            }
        }
        .padding(.vertical, 12)
    }
    
    private func listPreview(filter: ListFilter) -> some View {
        VStack(alignment: .leading) {
            ForEach(filter.previewOptions) { option in
                HStack {
                    Text(option.value.stringValue)
                        .font(Fonts.regular)
                        .foregroundStyle(filter.contains(value: option.key) ? Colors.primary : Colors.foreground)
                    
                    Spacer()
                    
                    if filter.value.contains(option.key) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12))
                            .tint(Colors.primary)
                    }
                }
                .frame(minHeight: 24)
                .background(Colors.backgroundPrimary)
                .onTapGesture {
                    withAnimation {
                        filter.toggleOption(option)
                    }
                }
            }
        }
    }
}

#Preview {
    AllFiltersView(
        filters: [
            // TODO: TreeSearchListFilter
            ApiSearchListFilter(
                apiService: PreviewApiService(previewData: nil),
                title: "Location",
                queryKey: "location",
                value: [],
                searchRouteProvider: { query in
                    AppRoutes.locationSearch(query: query)
                }
            ),
            ListFilter(
                title: "Work mode",
                queryKey: "collaboration",
                options: [
                    .init(key: "remote", value: "Remote"),
                    .init(key: "hybrid", value: "Hybrid"),
                    .init(key: "onsite", value: "Onsite"),
                ],
                value: ["hybrid"]
            ),
            ListFilter(
                title: "Seniority",
                queryKey: "seniority",
                options: [
                    .init(key: "junior", value: "Junior"),
                    .init(key: "medior", value: "Medior"),
                    .init(key: "senior", value: "Senior"),
                ]
            ),
            ApiSearchListFilter(
                apiService: PreviewApiService(previewData: nil),
                title: "Startups",
                queryKey: "company",
                value: [],
                searchRouteProvider: { query in
                    AppRoutes.companySearch(query: query)
                },
                optionsParser: { (items: [CompanySearchResult]) in
                    items.map {
                        FilterOption(key: $0.slug, value: $0.name)
                    }
                }
            ),
            ApiSearchListFilter(
                apiService: PreviewApiService(previewData: nil),
                title: "Tech",
                queryKey: "technological-tag",
                value: [],
                searchRouteProvider: { query in
                    AppRoutes.techSearch(query: query)
                }
            )
        ],
        didTapSeeAll: { _ in },
        didTapDone: {}
    )
}
