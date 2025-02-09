class JobListingFormatter {
    static func info(_ listing: JobListing) -> String {
        [
            listing.locations,
            listing.isRemote ? "Remote" : nil,
            formattedSalary(listing)
        ]
            .compactMap { $0 }
            .joined(separator: " • ")
    }
    
    private static func formattedSalary(_ listing: JobListing) -> String? {
        guard let salary = listing.salary else {
            return nil
        }
        
        return "\(salary.min / 1000)-\(salary.max / 1000)k"
    }
}
