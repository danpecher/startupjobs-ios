import Foundation

struct Paginator: Decodable {
    let current: Int
    let max: Int
}

struct ApiResult<T: Decodable>: Decodable {
    let resultSet: T
    let resultCount: Int
    let paginator: Paginator
}

struct JobListing: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let url: URL
    let company: String
    let imageUrl: URL
    let salary: Salary?
    let locations: String
    let isRemote: Bool
}

struct JobOffer: Decodable {
    struct CompanyStub: Decodable {
        let slug: String
    }
    
    let company: CompanyStub
}

struct Company: Decodable {
    let name: String
    let slug: String
    let logo: URL
    let coverPhoto: URL?
    let intro: String?
    let description: String?
    let offers: [JobListing]
    
    struct Contents: Decodable {
        let introduction: String?
        let description: String?
    }
    
    enum CodingKeys: CodingKey {
        case name
        case slug
        case offers
        case logo
        case coverPhoto
        case contents
        case introduction
        case description
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.logo = try container.decode(URL.self, forKey: .logo)
        self.coverPhoto = try container.decodeIfPresent(URL.self, forKey: .coverPhoto)
        
        let contents = try container.decode([String: Contents].self, forKey: .contents).czech
        self.intro = contents?.introduction
        self.description = contents?.description
        
        self.offers = try container.decode([String: [JobListing]].self, forKey: .offers).czech ?? []
    }
}

struct Salary: Decodable, Hashable  {
    let max: Int
    let min: Int
}

struct FilterOptionsSearchResult: Decodable {
    let urlIdentifier: String
    let name: String
}

struct CompanySearchResult: Decodable {
    let id: Int
    let name: String
    let slug: String
}

// MARK: - Language extraction
fileprivate let CS = "cs"

extension Dictionary where Key == String {
    var czech: Value? {
        first { $0.key == CS }?.value
    }
}
