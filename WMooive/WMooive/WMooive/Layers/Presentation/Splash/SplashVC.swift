//
//  SplashVC.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import UIKit
import CoreData
import WMovieImageCacher

class SplashVC: BaseViewController {
    
    private var viewModel: SplashVM!
    @IBOutlet weak var cachedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        addViewModelObservation()
        cachedImage.fullRotate()
    }
    
    func inject(viewModel: SplashVM) {
        self.viewModel = viewModel
    }
    
    deinit { print("DEINIT \(self)") }
    
    private func addViewModelObservation() {
        viewModel.stateClosure = { [weak self] viewModelState in
            switch viewModelState{
            case .updateUI(let data): self?.viewModelObservationHandler(data)
            case .error: break
            }
        }
    }
    
    private func viewModelObservationHandler(_ state: SplashVMImpl.Event?) {
        switch state {
        case .userAuthenticated:
            (coordinator as? AppCoordinator)?.navigate(to: .movieList)
        default: break
        }
    }
}
