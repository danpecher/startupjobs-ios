public enum DataState<T> {
    case initial
    case loading
    case loaded(T)
    case loadingMore(T)
    case failed(Error, T? = nil)
}
