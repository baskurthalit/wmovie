//
//  MovieCoordinator.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import UIKit

class MovieCoordinator: Coordinator, CoordinatorDelegate {

    
    typealias FlowType = MovieFlow

    var coordinatorType: CoordinatorType = .movie
    
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: BaseNavigationController
    
    init(parentCoordinator: Coordinator?,
        navigationController: BaseNavigationController? = nil) {
        self.navigationController = navigationController ?? .init()
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let builder: MoviesBuilder = MoviesBuilderImpl()
        let vc = builder.build(coordinator: self)
        navigationController.viewControllers = [vc]
        
        navigationController.modalPresentationStyle = .fullScreen
        parentCoordinator?.navigationController
            .present(navigationController, animated: false) {
            self.parentCoordinator?.navigationController.viewControllers.removeAll()
        }
    }
}

extension MovieCoordinator {
    func navigate(to flowType: MovieFlow) {
        handleMovieFlows(flowType)
    }
    
    private func handleMovieFlows(_ movieFlow: MovieFlow) {
        switch movieFlow {
        case .movieDetail(let moviewItem):
            let builder: MovieDetailBuilder = MovieDetailBuilderImpl()
            let vc = builder.build(coordinator: self, movie: moviewItem)
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}

