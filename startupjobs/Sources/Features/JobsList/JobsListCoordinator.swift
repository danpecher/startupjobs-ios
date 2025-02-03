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
            contentsOf: Bundle.main.url(forResource: "cachedjobs", withExtension: "json")!
        ))
        : ApiService(
            baseUrl: "https://www.startupjobs.cz/",
            urlSession: URLSession.shared
        )
        
        let viewModel = JobsListViewModel(
            filters: [
                // TODO: TreeSearchListFilter
                ApiSearchListFilter(
                    apiService: apiService,
                    title: "Location",
                    queryKey: "location",
                    value: [],
                    searchRouteProvider: { query in
                        AppRoutes.locationSearch(query: query)
                    }
                ),
                ListFilter(
                    title: "Work mode",
                    queryKey: "collaboration",
                    options: [
                        .init(key: "remote", value: "Remote"),
                        .init(key: "hybrid", value: "Hybrid"),
                        .init(key: "onsite", value: "Onsite"),
                    ]
                ),
                ListFilter(
                    title: "Seniority",
                    queryKey: "seniority",
                    options: [
                        .init(key: "junior", value: "Junior"),
                        .init(key: "medior", value: "Medior"),
                        .init(key: "senior", value: "Senior"),
                    ]
                ),
                ApiSearchListFilter(
                    apiService: apiService,
                    title: "Startups",
                    queryKey: "company",
                    value: [],
                    searchRouteProvider: { query in
                        AppRoutes.companySearch(query: query)
                    },
                    optionsParser: { (items: [CompanySearchResult]) in
                        items.map {
                            FilterOption(key: $0.slug, value: $0.name)
                        }
                    }
                ),
                ApiSearchListFilter(
                    apiService: apiService,
                    title: "Tech",
                    queryKey: "technological-tag",
                    value: [],
                    searchRouteProvider: { query in
                        AppRoutes.techSearch(query: query)
                    }
                )
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
