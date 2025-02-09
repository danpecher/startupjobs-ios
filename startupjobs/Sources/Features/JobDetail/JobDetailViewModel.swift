import Combine
import Networking

class JobDetailViewModel {
    enum Event {
        case didTapCompany(slug: String)
    }
    
    private var companySlug: String?
    
    private(set) var listing: JobListing
    private let apiService: ApiServicing
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(listing: JobListing, apiService: ApiServicing) {
        self.listing = listing
        self.apiService = apiService
    }
    
    func load() async {
        if companySlug != nil {
            return
        }
        
        do {
            let offer: JobOffer = try await apiService.request(
                AppRoutes.jobOffer(id: listing.id)
            )
            
            companySlug = offer.company.slug
        } catch {
            print(error)
        }
    }
    
    func didTapCompany() {
        guard let companySlug else {
            return
        }
        
        eventSubject.send(.didTapCompany(slug: companySlug))
    }
}
