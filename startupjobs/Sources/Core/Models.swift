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

struct JobListing: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let url: URL
    let company: String
    let imageUrl: URL
}
