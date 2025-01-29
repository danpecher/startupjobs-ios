import Foundation

public class ApiService: ApiServicing {
    private let urlSession: URLSession
    private let requestFactory: RequestFactory
    
    public init(baseUrl: String, urlSession: URLSession) {
        self.requestFactory = RequestFactory(baseUrl: baseUrl)
        self.urlSession = urlSession
    }
    
    public func request<T: Decodable>(_ route: Route) async throws -> T {
        let request = requestFactory.create(from: route)
        
        let (data, response) = try await urlSession.data(for: request)
        
#if DEBUG
        print("Request: ", request)
        
        if let response = response as? HTTPURLResponse {
            print("Response: ", response)
        }
#endif

        return try JSONDecoder().decode(T.self, from: data)
    }
}
