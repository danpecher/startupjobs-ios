public struct DataResult<T> {
    let data: T
    let hasMore: Bool
    
    public init(data: T, hasMore: Bool) {
        self.data = data
        self.hasMore = hasMore
    }
}
