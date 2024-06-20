//
//  ImageCacher.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

final class ImageCacher: ImageCacherInterface {
    
    private let coreData: ImageCacheCoreDataManager?
    
    init(coreData: ImageCacheCoreDataManager? = try? ImageCacheCoreDataManager()) {
        self.coreData = coreData
    }
    
    public func saveImage(url: String, image: UIImage) {
        coreData?.saveImage(url: url, imageData: image.pngData())
        deleteOutdatedEntities()
    }
    
    public func loadImage(url: String) async -> UIImage? {
        guard let imageData = await coreData?.loadImage(url: url) else { return nil }
        return .init(data: imageData)
    }
    
    private func deleteOutdatedEntities() {
        coreData?.deleteOutdatedEntities(olderThan: .sevenDays)
    }
}
