import Testing
@testable import Networking

extension DataState {
    var isFailure: Bool {
        guard case .failed = self else { return false }
        
        return true
    }
    
    var isLoaded: Bool {
        guard case .loaded = self else { return false }
        
        return true
    }
}

struct DataLoaderTests {
    @Test
    func setsFailedStateOnError() async {
        struct Failure: Error {}
        
        let subject = DataLoader<String> { page in
            throw Failure()
        }
        
        await subject.load()
        
        #expect(subject.state.isFailure)
    }
    
    @Test
    func setsLoadedStateOnSuccess() async {
        let subject = DataLoader<String> { page in
            return DataResult(
                data: [],
                hasMore: true
            )
        }
        
        await subject.load()
        
        #expect(subject.state.isLoaded)
    }
    
    @Test
    func doesntLoadMoreWhenReachedEnd() async {
        let items = (1...30).map { "\($0)" }
        let pageSize = 10
        
        var finalPage: Int?
        
        let subject = DataLoader<String> { page in
            finalPage = page
            
            let hasMore = items.count > (page * pageSize)
            let data = hasMore ? Array(items[(page-1) * pageSize ..< (page * pageSize)]) : []
            
            return DataResult(
                data: data,
                hasMore: items.count > (page * pageSize)
            )
        }
        
        await subject.load()
        await subject.loadMore()
        await subject.loadMore()
        await subject.loadMore()

        #expect(finalPage == 3)
    }
    
    @Test
    func addsPageWhenLoadMore() async {
        var finalPage: Int?
        
        let subject = DataLoader<String> { page in
            finalPage = page
            
            return DataResult(
                data: [],
                hasMore: true
            )
        }
        
        await subject.load()
        await subject.loadMore()
        
        #expect(finalPage == 2)
    }
    
    @Test
    func keepsExistingDataWhenLoadingMore() async {
        let items = (1...30).map { "\($0)" }
        let pageSize = 10
        
        let subject = DataLoader<String> { page in
            let hasMore = items.count > (page * pageSize)
            let data = hasMore ? Array(items[(page-1) * pageSize ..< (page * pageSize)]) : []
            
            return DataResult(
                data: data,
                hasMore: items.count > (page * pageSize)
            )
        }
        
        await subject.load()
        await subject.loadMore()

        guard case let .loaded(data) = subject.state else {
            Issue.record()
            return
        }
        
        #expect(data.count == pageSize * 2)
    }
}
