//
//  UIImageView+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit
import WMovieImageCacher

extension UIImageView {
    
    func load(from imageUrl: String, placeholder: String = "photo.circle.fill") {
        DispatchQueue.main.async { [weak self] in
            self?.image = .init(systemName: placeholder)
            let imageLoader = ImageLoader()
            self?.isShimmering = true
            Task {
                self?.image = await imageLoader.loadImage(from: imageUrl)
                self?.isShimmering = false
                self?.contentMode = .scaleAspectFill
            }
        }
    }
}
