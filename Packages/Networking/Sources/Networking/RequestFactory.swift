import Foundation

class RequestFactory {
    let baseUrl: URL
    
    init(baseUrl: String) {
        guard let url = URL(string: baseUrl) else {
            preconditionFailure("Not a valid baseUrl (\(baseUrl)")
        }
        
        self.baseUrl = url
    }
    
    func create(from route: Route) -> URLRequest {
        var newUrl = baseUrl.appending(path: route.path)
        
        if let queryItems = route.queryItems {
            newUrl.append(queryItems: queryItems)
        }
        
        var request = URLRequest(url: newUrl)
        
        request.httpMethod = route.method.rawValue.uppercased()
        
        return request
    }
}
