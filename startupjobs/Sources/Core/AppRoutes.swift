import Foundation

enum AppRoutes: Route {
    case jobsList(page: Int? = nil)
    
    var path: String {
        switch self {
        case .jobsList:
            "offers"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .jobsList(let page):
            guard let page else {
                return nil
            }
            
            return [URLQueryItem(name: "page", value: String(page))]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .jobsList:
                .get
        }
    }
}
