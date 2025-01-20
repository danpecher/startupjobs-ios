import Foundation

class ApiService: ApiServicing {
    private let urlSession: URLSession
    private let requestFactory = RequestFactory()
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(_ route: Route) async throws -> ApiResult<T> {
        let (data, response) = try await urlSession.data(for: requestFactory.create(from: route))
        
        if let response = response as? HTTPURLResponse {
            print(response)
        }
        
        return try JSONDecoder().decode(ApiResult<T>.self, from: data)
    }
}
