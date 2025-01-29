import Testing
import Foundation
import Combine
@testable import StartupJobs
@testable import Networking

@MainActor
struct JobsListViewModelTest {
    @Test
    func loadsData() async {
        let viewModel = JobsListViewModel(
            filters: [],
            apiService: PreviewApiService(
                previewData: try! Data(
                    contentsOf: Bundle.main.url(forResource: "cachedjobs", withExtension: "json")!
                )
            )
        )
        
        await viewModel.load()
        
        guard case let .loaded(data) = viewModel.state else {
            Issue.record("\(viewModel.state)")
            return
        }
        
        #expect(data != nil)
    }
    
    @Test
    mutating func removesDuplicates() async {
        let viewModel = JobsListViewModel(
            filters: [],
            apiService: PreviewApiService(
                previewData: try! Data(
                    contentsOf: Bundle.main.url(forResource: "duplicated_jobs", withExtension: "json")!
                )
            )
        )
        
        await viewModel.load()
        
        guard case let .loaded(data) = viewModel.state else {
            Issue.record("\(viewModel.state)")
            return
        }
        
        #expect(data.map { $0.id }.count == 2)
    }

    func loadsMore() {}
    func loadsFilteredData() {}
    func handlesRequestError() {}
}
