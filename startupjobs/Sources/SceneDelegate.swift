import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let appCoordinator = JobsListCoordinator()
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard NSClassFromString("XCTestCase") == nil, let windowScene = scene as? UIWindowScene else {
            return
        }
        
        appCoordinator.start()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appCoordinator.navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
