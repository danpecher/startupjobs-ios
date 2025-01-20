struct ApiResult<T: Decodable>: Decodable {
    let resultSet: T
    let resultCount: Int
}

struct JobListing: Codable, Identifiable {
    let id: Int
    let name: String
}
