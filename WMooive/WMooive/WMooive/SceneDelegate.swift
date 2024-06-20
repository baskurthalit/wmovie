//
//  SceneDelegate.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private(set) var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let baseNavigationController: BaseNavigationController = .init()
        
        window.rootViewController = baseNavigationController
        
        appCoordinator = .init(navigationController: baseNavigationController, window: window)
        
        guard let appCoordinator else { return }
        appCoordinator.start()
        window.makeKeyAndVisible()
    }
}

