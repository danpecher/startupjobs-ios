import Combine

class JobsListViewModel {
    enum Event {
        case didTapJobDetailButton(id: Int)
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    func openJobDetail(id: Int) {
        eventSubject.send(.didTapJobDetailButton(id: id))
    }
}
