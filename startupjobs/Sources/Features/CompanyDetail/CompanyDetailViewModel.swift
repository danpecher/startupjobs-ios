import Networking
import SwiftUI

@Observable
class CompanyDetailViewModel {
    let companySlug: String
    
    var state: DataState<Company> = .initial
    
    private let apiService: ApiServicing
    private let onJobListingTap: (JobListing) -> Void
    
    init(companySlug: String, apiService: ApiServicing, onJobListingTap: @escaping (JobListing) -> Void) {
        self.companySlug = companySlug
        self.apiService = apiService
        self.onJobListingTap = onJobListingTap
    }
    
    func load() async {
        switch state {
        case .loading, .loaded:
            return
        default:
            break
        }
        
        state = .loading
        
        do {
            let result: Company = try await apiService.request(
                AppRoutes.companyDetail(
                    slug: companySlug
                )
            )
            
            withAnimation {
                state = .loaded(result)
            }
        } catch {
            state = .failed(error)
        }
    }
    
    func didTapJobListing(_ listing: JobListing) {
        onJobListingTap(listing)
    }
}
