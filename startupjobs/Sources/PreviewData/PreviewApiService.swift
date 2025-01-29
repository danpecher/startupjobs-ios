import Foundation
import Networking

class PreviewApiService: ApiServicing {
    let previewData: Data?
    
    let delay: Int?
    
    /// - Parameter delay: Delay request (in seconds)
    init(previewData: Data?, delay: Int? = nil) {
        self.previewData = previewData
        self.delay = delay
    }
    
    func request<T: Decodable>(_ route: Route) async throws -> T {
        if let delay {
            try? await Task.sleep(for: .seconds(delay))
        }
        
        return try JSONDecoder().decode(T.self, from: previewData!)
    }
}
