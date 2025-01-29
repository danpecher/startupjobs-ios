import UIKit
import SwiftUI
import Combine
import Networking
import AppFramework

class JobsListCoordinator: Coordinator {
    enum Route {
        case jobDetail(id: Int)
    }

    lazy var navigationController: UINavigationController? = UINavigationController()
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    func start() {
        navigationController?.pushViewController(
            createMainController(),
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

// MARK: - Private
private extension JobsListCoordinator {
    func createMainController() -> UIViewController {
        // Use local json response to avoid unnecessary requests during development
        let useLocalData = false
        
        let apiService: ApiServicing = useLocalData
        ? PreviewApiService(previewData: try! Data(
            contentsOf: Bundle.main.url(forResource: "fakejobs", withExtension: "json")!
        ))
        : ApiService(
            baseUrl: "https://www.startupjobs.cz/api",
            urlSession: URLSession.shared
        )
        
        let viewModel = JobsListViewModel(
            filters: [
                // TODO: Add all filters
                ListFilter(title: "Obory", queryKey: "area", options: [
                    .init(key: "vyvoj", value: "Vyvoj"),
                    .init(key: "vyvoj/back-end", value: "Back-End"),
                ], value: ["vyvoj"])
            ],
            apiService: apiService
        )
        
        viewModel.events.sink { [weak self] event in
            self?.handle(event: event)
        }
        .store(in: &cancellables)
        
        let hostingController = HiddenBarUIHostingController(
            rootView: JobsList(viewModel: viewModel)
        )
        
        return hostingController
    }
    
    func handle(event: JobsListViewModel.Event) {
        switch event {
        case let .didTapJobDetailButton(id):
            navigate(to: .jobDetail(id: id))
        }
    }
}
