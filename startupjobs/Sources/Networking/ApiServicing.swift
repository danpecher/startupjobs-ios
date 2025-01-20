protocol ApiServicing {
    func request<T: Decodable>(_ route: Route) async throws -> ApiResult<T>
}
