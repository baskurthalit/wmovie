//
//  MovieFooterView.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import UIKit

class MovieFooterView: UICollectionReusableView {
    typealias ButtonCompletionType = (() -> Void)
    @IBOutlet weak var loadingContainerView: UIView!
    private var didTapLoadMore: ButtonCompletionType?
    override func prepareForReuse() { loadingContainerView.isHidden = true }
    
    @IBOutlet weak var loadingImageView: UIImageView!
    
    @IBAction func didTapLoadMore(_ sender: Any) {
        loadingContainerView.isHidden = false
        loadingImageView.fullRotate()
        didTapLoadMore?()
    }
    
    func load(completion: ButtonCompletionType?) {
        loadingContainerView.isHidden = true
        didTapLoadMore = completion
    }
}
