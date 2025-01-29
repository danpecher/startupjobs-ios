import Foundation
import Testing
@testable import Networking

fileprivate enum TestRoute: Route {
    case testPath(Int? = nil)
    case postForm
    
    var path: String {
        switch self {
        case .testPath:
            "test"
        case .postForm:
            "form"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .testPath(let int):
            guard let int else {
                return nil
            }
            
            return [
                URLQueryItem(name: "param", value: String(int))
            ]
        case .postForm:
            return nil
        }
    }
    
    var method: Networking.HTTPMethod {
        switch self {
        case .testPath:
                .get
        case .postForm:
                .post
        }
    }
}

struct RequestFactoryTests {
    private let baseUrl = "https://testsite.com/api"
    
    @Test
    func createsCorrectUrl() {
        let subject = RequestFactory(baseUrl: baseUrl)
        
        let getRequest = subject.create(
            from: TestRoute.testPath()
        )
        
        #expect(
            getRequest.url! == URL(string: "\(baseUrl)/test")!
        )
        
        #expect(
            getRequest.httpMethod == TestRoute.testPath().method.rawValue.uppercased()
        )
        
        #expect(
            subject.create(
                from: TestRoute.testPath(2)
            ).url! == URL(string: "\(baseUrl)/test?param=2")!
        )
        
        let postRequest = subject.create(
            from: TestRoute.postForm
        )
        
        #expect(
            postRequest.url! == URL(string: "\(baseUrl)/form")!
        )
        
        #expect(
            postRequest.httpMethod == TestRoute.postForm.method.rawValue.uppercased()
        )
    }
}
