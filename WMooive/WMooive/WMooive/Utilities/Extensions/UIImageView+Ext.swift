//
//  UIImageView+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit
import WMovieImageCacher

extension UIImageView {
    static let imageLoader: ImageLoader = .init()
    
    func load(from imageUrl: String, placeholder: String = "photo.circle.fill") {
        image = .init(systemName: placeholder)
        isShimmering = true
        Task(priority:.userInitiated) {
            image = try? await Self.imageLoader.loadImage(from: imageUrl)
            isShimmering = false
            contentMode = .scaleAspectFill
        }
    }
}
