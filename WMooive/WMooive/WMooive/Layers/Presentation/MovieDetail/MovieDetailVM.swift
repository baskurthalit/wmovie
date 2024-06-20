//
//  MovieDetailVM.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import Foundation
import WMovieAPI
import WMovieImageCacher

protocol MovieDetailVM {
    var stateClosure:( (ObservationType<MovieDetailVMImpl.Event, MovieDetailVMImpl.ErrorType>) -> () )? { get set }
    func viewDidLoad()
    func toggleFavorite()
}

final class MovieDetailVMImpl: MovieDetailVM {
    var stateClosure: ((ObservationType<Event, any ErrorType>) -> ())?
    
    typealias Event = MoviedetailEvent
    typealias ErrorType = Error
    let network: WMovieNetworkInterface
    let movie: Movie
    let favoritesManager: FavoritesManager
    
    init(network: WMovieNetworkInterface, movieItem: Movie, favoriteManager: FavoritesManager) {
        self.network = network
        movie = movieItem
        self.favoritesManager = favoriteManager
        favoriteManager.delegate.addDelegate(self)
    }
    
    func viewDidLoad() {
        stateClosure?(.updateUI(.setMovieDetail(withMovie: movie)))
        stateClosure?(
            .updateUI(
                .favoriteState(isFavorite: favoritesManager.isFavorite(itemID: String(movie.id)))
            )
        )
    }
    
    func toggleFavorite() {
        favoritesManager.toggleFavorite(itemID: .init(movie.id))
    }
    
    enum MoviedetailEvent {
        case setMovieDetail(withMovie: Movie)
        case favoriteState(isFavorite: Bool)
    }
    
}

extension MovieDetailVMImpl: FavoritesDelegate {
    func didUpdateFavorites(itemAdded itemID: String) {
        guard Int(itemID) == movie.id else { return }
        stateClosure?(.updateUI(.favoriteState(isFavorite: true)))
    }
    
    func didUpdateFavorites(itemRemoved itemID: String) {
        guard Int(itemID) == movie.id else { return }
        stateClosure?(.updateUI(.favoriteState(isFavorite: false)))
    }
}
