//
//  MovieDetailBuilder.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import Foundation
import WMovieAPI

protocol MovieDetailBuilder {
    func build(coordinator cDelegate: any CoordinatorDelegate, movie: Movie) -> MovieDetailVC
}

struct MovieDetailBuilderImpl: MovieDetailBuilder {
    func build(coordinator cDelegate: any CoordinatorDelegate, movie:Movie) -> MovieDetailVC {
        let viewController = MovieDetailVC(nibName: MovieDetailVC.className, bundle: nil)
        viewController.coordinator = cDelegate
        let movieDetailViewModel: MovieDetailVM = MovieDetailVMImpl(network: WMovieNetwork(), movieItem: movie, favoriteManager: .shared)
        viewController.inject(viewModel: movieDetailViewModel)
        return viewController
    }
}
