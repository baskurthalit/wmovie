//
//  AppCoordinator.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import UIKit

class AppCoordinator: Coordinator, CoordinatorDelegate {
    typealias FlowType = TabFlow

    private(set) var coordinatorType: CoordinatorType = .app
    
    var parentCoordinator: Coordinator?
    var window: UIWindow
    var childCoordinators: [Coordinator] = []
    
    var navigationController: BaseNavigationController
    
    func start() {
        let builder: SplashScreenBuilder = SplashScreenBuilderImpl()
        let vc: UIViewController = builder.build(coordinator: self)
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    init(parentCoordinator: Coordinator? = nil,
         navigationController: BaseNavigationController, window: UIWindow) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.window = window
    }
}

extension AppCoordinator {
    func navigate(to flowType: TabFlow) {
        switch flowType {
        case .movieList:
            let movieCoordinator = MovieCoordinator(parentCoordinator: self)
            self.addChild(coordinator: movieCoordinator)
            movieCoordinator.start()
        }
    }
}
