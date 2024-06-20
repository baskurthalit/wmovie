//
//  LoadingShowable.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

protocol LoadingShowable where Self: UIViewController {
    func loading(isShowing: Bool)
}

extension LoadingShowable {
    func loading(isShowing: Bool) {
        DispatchQueue.main.async { [weak self] in
            isShowing ? self?.addLoadinView() : self?.removeLoadingView()
        }
    }
    
    private func addLoadinView() {
        removeLoadingView()
        let loadingView: UIImageView = prepareLoadingView()
        let alphaView: UIView = prepareAlphaView()
        
        alphaView.addSubview(loadingView)
        view.addSubview(alphaView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: alphaView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: alphaView.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 75),
            loadingView.heightAnchor.constraint(equalTo: loadingView.widthAnchor)
        ])        
        
        NSLayoutConstraint.activate([
            alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            alphaView.topAnchor.constraint(equalTo: view.topAnchor),
            alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func removeLoadingView() {
        guard let loadingView = view.subviews.first(where: { $0.accessibilityIdentifier == "AlphaView" }) else { return }
        loadingView.removeFromSuperview()
    }
    
    private func prepareLoadingView() -> UIImageView {
        let imageView = UIImageView(image: .init(systemName: "circle.dashed"))

        imageView.accessibilityIdentifier = "LoadingView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.fullRotate()
        return imageView
    }    
    
    private func prepareAlphaView() -> UIView {
        let alphaView: UIView = .init()
        alphaView.translatesAutoresizingMaskIntoConstraints = false
        alphaView.backgroundColor = .black.withAlphaComponent(0.2)

        alphaView.accessibilityIdentifier = "AlphaView"
        return alphaView
    }
}
