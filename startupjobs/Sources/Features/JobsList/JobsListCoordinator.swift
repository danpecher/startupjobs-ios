import UIKit
import SwiftUI
import Combine
import Networking
import AppFramework

class JobsListCoordinator: NSObject, Coordinator {
    enum Route {
        case jobDetail(listing: JobListing)
        case companyDetail(slug: String)
        case allFilters
    }

    lazy var navigationController: UINavigationController? = UINavigationController()
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Use local json response to avoid unnecessary requests during development
    private static let useLocalData = false
    
    private let apiService: ApiServicing = JobsListCoordinator.useLocalData
        ? PreviewApiService(previewData: try! Data(
            contentsOf: Bundle.main.url(forResource: "cachedjobs", withExtension: "json")!
        ))
        : ApiService(
            baseUrl: "https://www.startupjobs.cz/",
            urlSession: URLSession.shared
        )
    
    private lazy var viewModel = JobsListViewModel(
        filters: filters,
        apiService: apiService
    )
    
    private lazy var filters: [any Filter] = {
        [
            ListFilter(
                title: "Area",
                queryKey: "area",
                options: AreaOptionsLoader().load(),
                searchEnabled: true
            ),
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
        ]
    }()
    
    func start() {
        navigationController?.pushViewController(
            createMainController(),
            animated: false
        )
    }
    
    func navigate(to route: Route/*, presentation: ScreenPresentation*/) {
        switch route {
        case .jobDetail(let listing):
            let viewModel = JobDetailViewModel(listing: listing, apiService: apiService)
            
            viewModel.events.sink { [weak self] event in
                self?.handle(event: event)
            }
            .store(in: &cancellables)
            
            navigationController?.pushViewController(
                UIHostingController(
                    rootView: JobDetail(
                        viewModel: viewModel
                    )
                    .background(Colors.backgroundPrimary)
                ),
                animated: true
            )
        case .companyDetail(let slug):
            navigationController?.pushViewController(
                UIHostingController(
                    rootView: CompanyDetail(
                        viewModel: .init(
                            companySlug: slug,
                            apiService: apiService
                        ) { [weak self] listing in 
                            self?.navigate(to: .jobDetail(listing: listing))
                        }
                    )
                    .background(Colors.backgroundPrimary)
                ),
                animated: true
            )
        case .allFilters:
            navigationController?.present(createAllFiltersController(), animated: true)
        }
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension JobsListCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        reloadView()
    }
}

// MARK: - Private
private extension JobsListCoordinator {
    func createMainController() -> UIViewController {
        viewModel.events.sink { [weak self] event in
            self?.handle(event: event)
        }
        .store(in: &cancellables)
        
        let hostingController = HiddenBarUIHostingController(
            rootView: JobsList(viewModel: viewModel)
        )
        
        return hostingController
    }
    
    func createAllFiltersController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.presentationController?.delegate = self
        
        let filtersController = UIHostingController(
            rootView: AllFiltersView(
                filters: filters,
                didTapSeeAll: { filter in
                    navigationController.pushViewController(
                        UIHostingController(
                            rootView: FilterWrapper(filter: filter, onDoneTapped: {
                                navigationController.popViewController(animated: true)
                            })
                        ),
                        animated: true
                    )
                },
                didTapDone: { [weak self] in
                    self?.navigationController?.dismiss(animated: true)
                    self?.reloadView()
                }
            )
        )
        
        filtersController.title = "Filters"
        
        navigationController.pushViewController(filtersController, animated: false)
        
        return navigationController
    }
    
    func handle(event: JobsListViewModel.Event) {
        switch event {
        case let .didTapJobDetailButton(listing):
            navigate(to: .jobDetail(listing: listing))
        case .showAllFilters:
            navigate(to: .allFilters)
        }
    }
    
    func handle(event: JobDetailViewModel.Event) {
        switch event {
        case .didTapCompany(let slug):
            navigate(to: .companyDetail(slug: slug))
        }
    }
    
    func reloadView() {
        Task {
            await viewModel.load()
        }
    }
}
