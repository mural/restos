//
//  restosApp.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/13/22.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        let persistenceController = PersistenceController.shared
        let repository = RestaurantRepositoryImplementation(restaurantService: RestaurantAPI(), managedObjectContext: persistenceController.container.viewContext)
        let viewModel = RestaurantViewModel(restaurantRepository: repository)
        
        let useUIKit = !BundleUtils.getUIModeSwiftUIEnabled()
        
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            
            if (useUIKit) {
                let navigationVC = UINavigationController()
                window?.rootViewController = navigationVC
                let viewController = MainViewController(restaurantViewModel: viewModel, restaurantRepository: repository)
                navigationVC.pushViewController(viewController!, animated: false)
                
            } else {
                let contentView = RestaurantsView(viewModel: viewModel, restaurantRepository: repository)
                                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                window?.rootViewController = UIHostingController(rootView: contentView)
            }
            window?.makeKeyAndVisible()
        }
    }
}
