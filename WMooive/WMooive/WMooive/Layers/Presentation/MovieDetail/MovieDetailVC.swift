//
//  MovieDetailVC.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import UIKit

final class MovieDetailVC: BaseViewController {
    
    private var viewModel: MovieDetailVM!

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewModelObservation()
        setNavigationBackButton()
        viewModel.viewDidLoad()
    }
    
    func inject(viewModel: MovieDetailVM) {
        self.viewModel = viewModel
    }
    
    private func addViewModelObservation() {
        viewModel.stateClosure = { [weak self] viewModelState in
            switch viewModelState{
            case .updateUI(let data): self?.viewModelObservationHandler(data)
            case .error: break
            }
        }
    }
    
    @IBAction func didTapToggleFavoriteButton(_ sender: Any) {
        viewModel.toggleFavorite()
    }
    private func viewModelObservationHandler(_ state: MovieDetailVMImpl.Event?) {
        switch state {
        case .setMovieDetail(let movie):
            posterImageView.load(from: movie.posterUrl ?? "")
            movieTitleLabel.text = movie.originalTitle
            movieDescriptionLabel.text = movie.overview
        case .favoriteState(let isFavorite):
            let favoriteImageName: String = isFavorite ? "star.fill":"star"
            favoriteButton.setImage(.init(systemName: favoriteImageName), for: .normal)
        default: break
        }
    }
}
