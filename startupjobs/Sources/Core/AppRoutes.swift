import Foundation
import Networking

enum AppRoutes: Route {
    case jobsList(
        page: Int? = nil,
        filters: [QueryPair] = []
    )
    
    case locationSearch(query: String)
    case companySearch(query: String)
    case techSearch(query: String)
    
    var path: String {
        switch self {
        case .jobsList:
            "api/offers"
        case .locationSearch:
            "api/locations"
        case .companySearch:
            "api/front/companies"
        case .techSearch:
            "search/technological-tags"
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
        case let .locationSearch(query):
            if query.isEmpty {
                return []
            }
            
            return [
                URLQueryItem(name: "name", value: query),
                URLQueryItem(name: "cities", value: "true")
            ]
        case let .companySearch(query):
            if query.isEmpty {
                return []
            }
            
            return [
                URLQueryItem(name: "needle", value: query),
            ]
        case let .techSearch(query):
            return [
                URLQueryItem(name: "name", value: query),
                URLQueryItem(name: "including", value: "react-js,python,java,php,javascript,sql") // default hardcoded set
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .jobsList, .locationSearch, .companySearch, .techSearch:
                .get
        }
    }
}
