import Foundation
import XCTest
@testable import App

final class RequestFactoryTests: XCTestCase {
    func testCreatesCorrectUrl() {
        let subject = RequestFactory()
        
        XCTAssertEqual(
            subject.create(from: AppRoutes.jobsList()).url!,
            URL(string: "https://www.startupjobs.cz/api/offers")!
        )
        
        XCTAssertEqual(
            subject.create(from: AppRoutes.jobsList(page: 2)).url!,
            URL(string: "https://www.startupjobs.cz/api/offers?page=2")!
        )
    }
}
