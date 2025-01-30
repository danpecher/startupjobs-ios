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

struct Salary: Decodable, Hashable  {
    let max: Int
    let min: Int
}
