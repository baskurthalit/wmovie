//
//  Coordinator.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

enum CoordinatorType : String, CaseIterable {
    case app
    case movie
}

protocol Coordinator: AnyObject {
    var coordinatorType: CoordinatorType { get }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: BaseNavigationController { get set }
    func removeChild(coordinator: Coordinator)
    func addChild(coordinator: Coordinator)
    
    func start()
}

extension Coordinator {
    func addChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

protocol CoordinatorDelegate: AnyObject {
    associatedtype FlowType
    func navigate(to flowType: FlowType)
}
