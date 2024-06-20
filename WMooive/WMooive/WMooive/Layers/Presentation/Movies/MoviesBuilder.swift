//
//  MoviesBuilder.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit
import WMovieAPI

protocol MoviesBuilder {
    func build(coordinator cDelegate: any CoordinatorDelegate) -> UIViewController
}

struct MoviesBuilderImpl: MoviesBuilder {
    func build(coordinator cDelegate: any CoordinatorDelegate) -> UIViewController {
        let viewController = MoviesVC(nibName: MoviesVC.className, bundle: nil)
        viewController.coordinator = cDelegate
        let moviesViewModel: MoviesVM = MoviesVMImpl(network: WMovieNetwork())
        viewController.inject(viewModel: moviesViewModel)
        return viewController
    }
}
