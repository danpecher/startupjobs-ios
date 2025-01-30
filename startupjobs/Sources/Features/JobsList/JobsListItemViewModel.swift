class JobsListItemViewModel {
    let listing: JobListing
    
    init(listing: JobListing) {
        self.listing = listing
    }
    
    var info: String {
        [
            listing.locations,
            listing.isRemote ? "Remote" : nil,
            formattedSalary
        ]
            .compactMap { $0 }
            .joined(separator: " • ")
    }
    
    private var formattedSalary: String? {
        guard let salary = listing.salary else {
            return nil
        }
        
        return "\(salary.min / 1000)-\(salary.max / 1000)k"
    }
}
