import SwiftUI
import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    
    func start() {
        let mainCoordinator = JobsListCoordinator()
        coordinate(to: mainCoordinator)
        navigationController = mainCoordinator.navigationController
    }
}
