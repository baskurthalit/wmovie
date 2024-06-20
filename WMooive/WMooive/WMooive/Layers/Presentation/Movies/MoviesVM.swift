//
//  MoviesVM.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import Foundation
import WMovieAPI

protocol MoviesVM {
    var stateClosure:( (ObservationType<MoviesVMImpl.Event, MoviesVMImpl.ErrorType>) -> () )? { get set }
    func requestedToChangeDisplayMode()
    var contentMode: MoviesVMImpl.MoviesLayoutType { get }
    func viewDidLoad()
    func itemSize(for width: CGFloat) -> CGSize
    func movieItem(for indexPath: IndexPath) -> Movie?
    func numberOfItems(for section: Int) -> Int
    func shouldFetchMore() -> Bool
    func fetchNextPage()
    func movieAddedToFavorite(movieID: String, imageData: Data?)
    func searchMovie(for searchText: String)
}

final class MoviesVMImpl : MoviesVM {
    private var isFetchingMore: Bool = false
    private var currentPage: Int = 1
    private let network: WMovieNetworkInterface
    private var searchText: String = ""
    
    enum MoviesLayoutType {
        case grid
        case list
    }
    
    var stateClosure: ((ObservationType<MoviesEvent, ErrorType>) -> ())?
    
    typealias Event = MoviesEvent
    typealias ErrorType = Error
    private(set) var contentMode: MoviesLayoutType = .grid
    private var movieResponse: MovieResponse?
    private var moviesData: [Movie] = []
    private var filtredMovieData: [Movie] = []
    private var layoutImageName: String { return contentMode == .grid ? "circle.grid.3x3.circle":"list.bullet.circle" }
    
    init(network: WMovieNetworkInterface) {
        self.network = network
    }
    
    func viewDidLoad() {
        stateClosure?(.updateUI(.setLayoutButtonImage(toImageName: layoutImageName)))
        Task { await fetchPopularMovies() }
    }
    
    func fetchPopularMovies() async {
        if movieResponse.isNil { stateClosure?(.updateUI(.setLoading(isShowing: true))) }
        do {
            movieResponse = try await network.request(for: MovieEndpoint(queryItems: [.page("\(currentPage)")]))
            
            guard let movies = movieResponse?.results else { return }
            moviesData.append(contentsOf: movies)
            isFetchingMore = false
            stateClosure?(.updateUI(.reloadData(movies: suitableItems(for: searchText))))
            stateClosure?(.updateUI(.setLoading(isShowing: false)))
        } catch { }
        
    }
    
    func fetchNextPage() {
        if shouldFetchMore() {
            currentPage += 1
            Task { await fetchPopularMovies() }
        }
    }
    
    func shouldFetchMore() -> Bool {
        guard let movieResponse, !isFetchingMore else { return false }
        return movieResponse.page < movieResponse.totalPages
    }
    
    func itemSize(for viewWidth: CGFloat) -> CGSize {
        switch contentMode {
        case .grid: return .init(width: ((viewWidth - 20)/2) - 5, height: 200)
        case .list: return .init(width: (viewWidth - 20), height: 150)
        }
    }
    
    func movieAddedToFavorite(movieID: String, imageData: Data?) {
        Task(priority: .background) {
            let imageStr: String? = imageBase64String(image: imageData)
            if let imageStr { await uploadImage(base64Str: imageStr) }
        }
    }
    
    private func uploadImage(base64Str: String) async {
        let request = UploadImageRequest(prompt: "", base64str: "")
        let encoder: HTTPBodyEncoder = HTTPBodyEncoderImpl()
        let response: ResponseData? = try? await network.request(for: UploadImageEndpoint(httpBody: encoder.encode(for: request)))
        debugPrint("Upload Image Process is \(response?.result ?? false) on \(self)")
    }
    
    func searchMovie(for searchText: String) {
        stateClosure?(.updateUI(.reloadData(movies: suitableItems(for: searchText))))
    }
    
    private func suitableItems(for searchText: String) -> [Movie] {
        if searchText.isEmpty {
            self.searchText = searchText
            return moviesData
        } else {
            if searchText != self.searchText {
                self.searchText = searchText
                filtredMovieData = moviesData.filter {
                    $0.originalTitle.lowercased(with: Locale.current)
                        .contains(searchText.lowercased(with: Locale.current))
                }
            }
            return filtredMovieData
        }
    }
    
    private func imageBase64String(image data: Data?) -> String? {
        let resizer: ImageResizer = .init(targetWidth: 100)
        
        guard let data,
              let image = resizer.resize(data: data),
              let imageStr: String = image.convertImageToBase64String()
        else { return nil }
        return imageStr
        
    }
    
    func movieItem(for indexPath: IndexPath) -> Movie? { suitableItems(for: searchText)[indexPath.row] }
    
    func numberOfItems(for section: Int) -> Int { suitableItems(for: searchText).count }
        
    func requestedToChangeDisplayMode() {
        contentMode = contentMode == .grid ? .list : .grid
        stateClosure?(.updateUI(.reloadData(movies: suitableItems(for: searchText))))
        stateClosure?(.updateUI(.setLayoutButtonImage(toImageName: layoutImageName)))
    }
    
    enum MoviesEvent {
        case userAuthenticated
        case reloadData(movies:[Movie])
        case setLayoutButtonImage(toImageName: String)
        case setLoading(isShowing: Bool)
    }
}

