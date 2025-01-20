import Foundation

class RequestFactory {
    private static let baseUrl = "www.startupjobs.cz"
    
    func create(from route: Route) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Self.baseUrl
        urlComponents.path = "/api/\(route.path)"
        urlComponents.queryItems = route.queryItems
        
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = route.method.rawValue.uppercased()
        
        return request
    }
}
