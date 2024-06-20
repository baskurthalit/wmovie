//
//  MoviesVC.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

class MoviesVC: BaseViewController {
    
    private var viewModel: MoviesVM!
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>!
    @IBOutlet weak var searchTextField: UITextField!
    private var isSearching: Bool = false
    private var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureDataSource()
        addViewModelObservation()
        setNavigationTitle("Popular Movies")
        viewModel.viewDidLoad()
        searchTextField.delegate = self
    }

    func inject(viewModel: MoviesVM) {
        self.viewModel = viewModel
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.contentInset = .init(top: .zero, left: 10, bottom: .zero, right: 10)
        collectionView.register(nibName: "GridMovieCell")
        collectionView.register(nibName: "ListMovieCell")
        collectionView.register(reusableViewType: MovieFooterView.self)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Movie>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, movieItem: Movie) -> UICollectionViewCell? in
            
            let cell: MovieCollectionViewCell
            switch self.viewModel.contentMode {
            case .grid:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridMovieCell", for: indexPath) as! MovieCollectionViewCell
            case .list:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListMovieCell", for: indexPath) as! MovieCollectionViewCell
            }
            
            cell.load(movieItem,delegate: self)
            return cell
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let footerView: MovieFooterView = collectionView.dequeueReusableView(with: MovieFooterView.self, for: indexPath, ofKind: kind)
            footerView.load { [weak self] in
                self?.viewModel.fetchNextPage()
            }
            return footerView
        }
    }
    
    private func addViewModelObservation() {
        viewModel.stateClosure = { [weak self] viewModelState in
            switch viewModelState {
            case .updateUI(let data):
                self?.viewModelObservationHandler(data)
            case .error: break
            }
        }
    }
    
    private func applySnapshot(with data: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func viewModelObservationHandler(_ state: MoviesVMImpl.Event?) {
        switch state {
        case .reloadData(let movies):
            DispatchQueue.main.async { [weak self] in
                self?.applySnapshot(with: movies)
            }
        case .setLayoutButtonImage(let imageName):
            setupNavigationRightButton(imageName: imageName,action: #selector(didTapRightButton))
        case .setLoading(let isShowing): loading(isShowing: isShowing)
        default: break
        }
    }
    
    @objc private func didTapRightButton() {
        viewModel.requestedToChangeDisplayMode()
    }
}

extension MoviesVC: UITextFieldDelegate {
    
    @objc func searchMovie() {
        viewModel.searchMovie(for: searchText)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        searchText = ""
        viewModel.searchMovie(for: "")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isSearching = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.isSearching = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        searchText = textField.text ?? ""
        textField.resignFirstResponder()
        viewModel.searchMovie(for: textField.text ?? "")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchTextField {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            if let searchText = newText, !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                self.searchText = searchText
                self.perform(#selector(searchMovie), with: nil, afterDelay: 0.5)
            } else { viewModel.searchMovie(for: "") }
        }
        return true
    }
}

extension MoviesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.itemSize(for: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 5 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let isFooterActive: Bool = viewModel.shouldFetchMore() && !isSearching && searchText == ""
        return isFooterActive ? .init(width: collectionView.frame.width, height: 75) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieItem: Movie = viewModel.movieItem(for: indexPath) else { return }
        (coordinator as? MovieCoordinator)?.navigate(to: .movieDetail(withMovie: movieItem))
    }
}

extension MoviesVC: MovieCollectionViewCellDelegate {
    func movieAddedToFavorite(movieID: String, image: Data?) {
        viewModel.movieAddedToFavorite(movieID: movieID, imageData: image)
    }
}
