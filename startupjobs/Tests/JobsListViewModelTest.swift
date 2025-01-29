import Testing
import Foundation
@testable import StartupJobs
@testable import Networking

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
        
        #expect(viewModel.jobs.currentData != nil)
    }
    
    @Test
    func loadsMore() {}
    func loadsFilteredData() {}
    func handlesRequestError() {}
}
