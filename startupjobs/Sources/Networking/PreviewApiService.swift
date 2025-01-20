import Foundation

class PreviewApiService: ApiServicing {
    static var previewData: Data?
    
    let delay: Int?
    
    /// - Parameter delay: Delay request (in seconds)
    init(delay: Int? = nil) {
        self.delay = delay
    }
    
    func request<T: Decodable>(_ route: Route) async throws -> ApiResult<T> {
        if let delay {
            try? await Task.sleep(for: .seconds(delay))
        }
        
        return try JSONDecoder().decode(ApiResult<T>.self, from: Self.previewData!)
    }
}
