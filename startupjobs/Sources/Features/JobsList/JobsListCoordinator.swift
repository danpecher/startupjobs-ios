import UIKit
import SwiftUI
import Combine

class JobsListCoordinator: Coordinator {
    enum Route {
        case jobDetail(id: Int)
    }

    lazy var navigationController: UINavigationController? = {
        let viewController = UINavigationController()
        
        viewController.navigationBar.prefersLargeTitles = true
        
        return viewController
    }()
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    func start() {
        PreviewApiService.previewData = try! Data(
            contentsOf: Bundle.main.url(forResource: "fakejobs", withExtension: "json")!
        )
        
        let viewModel = JobsListViewModel(
            apiService: PreviewApiService()
//            apiService: ApiService(urlSession: URLSession.shared)
        )
        
        viewModel.events.sink { [weak self] event in
            switch event {
            case let .didTapJobDetailButton(id):
                self?.navigate(to: .jobDetail(id: id))
            }
        }
        .store(in: &cancellables)
        
        let hostingController = UIHostingController(
            rootView: JobsList(viewModel: viewModel)
        )
        
        hostingController.title = "Jobs"
        
        navigationController?.pushViewController(
            hostingController,
            animated: false
        )
    }
    
    
    func navigate(to route: Route) {
        switch route {
        case .jobDetail(let id):
            let viewController = UIHostingController(rootView: Text("Job detail: \(id)"))
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
