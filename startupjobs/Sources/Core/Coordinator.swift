import SwiftUI
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func finish()
    func coordinate(to: Coordinator)
    func childDidFinish(_ child: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func finish() {
        childCoordinators.forEach { $0.finish() }
        childCoordinators.removeAll()
        
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
    }
    
    func childDidFinish(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}
