//
//  MovieCollectionViewCell.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

protocol MovieCollectionViewCellDelegate: AnyObject {
    func movieAddedToFavorite(movieID: String, image: Data?)
}

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    private let favoritesManager: FavoritesManager = .shared
    private weak var delegate: MovieCollectionViewCellDelegate?
    private var movie: Movie?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoritesManager.delegate.removeDelegate(self)
        movie = nil
        movieNameLabel.text = nil
        posterImageView.image = nil
        isShimmering = false
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let movie else { return }
        favorite(movieId: "\(movie.id)")
    }
    
//    deinit { print("DEINIT \(self)") }
    
    func load(_ movie: Movie?, delegate: MovieCollectionViewCellDelegate? = nil) {
        self.delegate = delegate
        self.movie = movie
        posterImageView.load(from: movie?.posterUrl ?? "")
        movieNameLabel.text = movie?.originalTitle
        favoritesManager.delegate.addDelegate(self)

        if let id = movie?.id {
            let isFavorite = favoritesManager.isFavorite(itemID: "\(id)")
            updateFavoriteState(isFavorite: isFavorite)
        }
    }
    
    private func updateFavoriteState(isFavorite: Bool) {
        let favoriteImageName: String = isFavorite ? "star.fill":"star"
        favoriteButton.setImage(.init(systemName: favoriteImageName), for: .normal)
    }
    
    private func favorite(movieId: String) {
        favoritesManager.toggleFavorite(itemID: movieId)
    }
    
}

extension MovieCollectionViewCell: FavoritesDelegate {
    func didUpdateFavorites(itemAdded itemID: String) {
        guard let id = movie?.id, String(id) == itemID else { return }
        let isFavorite = favoritesManager.isFavorite(itemID: itemID)
        updateFavoriteState(isFavorite: isFavorite)
        delegate?.movieAddedToFavorite(movieID: itemID, image: posterImageView.image?.pngData())
    }
    
    func didUpdateFavorites(itemRemoved itemID: String) {
        guard let id = movie?.id, String(id) == itemID else { return }
        let isFavorite = favoritesManager.isFavorite(itemID: itemID)
        updateFavoriteState(isFavorite: isFavorite)
    }
}
