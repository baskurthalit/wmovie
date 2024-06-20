//
//  ImageLoader.swift
//
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

public struct ImageLoader {
    
    let imageCacher: ImageCacherInterface
    
    public init(imageCacher: ImageCacherInterface? = nil) {
        if let imageCacher {
            self.imageCacher = imageCacher
        } else {
            self.imageCacher = ImageCacher()
        }
    }
    
    public func loadImage(from urlString: String) async -> UIImage? {
        guard !urlString.isEmpty else { return nil }
        if let cachedImage = await imageCacher.loadImage(url: urlString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            imageCacher.saveImage(url: urlString, image: image)
            return image
        } else { return nil }
        
    }
}
