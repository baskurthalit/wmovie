//
//  ImageResizer.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import UIKit

public enum ImageResizingError: Error {
    case cannotRetrieveFromURL
    case cannotRetrieveFromData
}

public struct ImageResizer {
    public var targetWidth: CGFloat
    
    public init(targetWidth: CGFloat) {
        self.targetWidth = targetWidth
    }
    
    public func resize(at url: URL) -> UIImage? {
        guard let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        return self.resize(image: image)
    }
    
    public func resize(image: UIImage) -> UIImage {
        let originalSize = image.size
        let originalRatio = originalSize.height/originalSize.width
        let height = (targetWidth) / originalRatio
        let targetSize = CGSize(width: targetWidth, height: height)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    public func resize(data: Data) -> UIImage? {
        guard let image = UIImage(data: data) else { return nil }
        return resize(image: image )
    }
}
