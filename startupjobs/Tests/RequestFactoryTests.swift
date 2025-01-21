import Foundation
import Testing
@testable import App

struct RequestFactoryTests {
    @Test
    func createsCorrectUrl() {
        let subject = RequestFactory()
        
        #expect(subject.create(from: AppRoutes.jobsList()).url! == URL(string: "https://www.startupjobs.cz/api/offers")!)
        
        #expect(subject.create(from: AppRoutes.jobsList(page: 2)).url! == URL(string: "https://www.startupjobs.cz/api/offers?page=2")!)
    }
}
