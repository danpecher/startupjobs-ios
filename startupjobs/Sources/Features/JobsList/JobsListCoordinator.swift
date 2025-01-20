import UIKit
import SwiftUI
import Combine

class JobsListCoordinator: Coordinator {
    enum Route {
        case jobDetail(id: Int)
    }

    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = JobsListViewModel()
        
        viewModel.events.sink { [weak self] event in
            switch event {
            case let .didTapJobDetailButton(id):
                self?.navigate(to: .jobDetail(id: id))
            }
        }
        .store(in: &cancellables)
        
        navigationController.pushViewController(
            UIHostingController(rootView: JobsList(viewModel: viewModel)),
            animated: false
        )
    }
    
    
    func navigate(to route: Route) {
        switch route {
        case .jobDetail(let id):
            let viewController = UIHostingController(rootView: Text("Job detail: \(id)"))
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
