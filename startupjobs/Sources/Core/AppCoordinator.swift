import SwiftUI
import UIKit

class AppCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    
    func start() {
        coordinate(to: JobsListCoordinator(navigationController: navigationController))
    }
}
