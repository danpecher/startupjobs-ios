import Foundation
import Networking

enum AppRoutes: Route {
    case jobsList(
        page: Int? = nil,
        filters: [QueryPair] = []
    )
    
    var path: String {
        switch self {
        case .jobsList:
            "offers"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .jobsList(page, filters):
            guard let page else {
                return nil
            }
            
            return [
                URLQueryItem(name: "page", value: String(page))
            ] + filters.map({ key, value in
                URLQueryItem(name: key, value: value)
            })
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .jobsList:
                .get
        }
    }
}
