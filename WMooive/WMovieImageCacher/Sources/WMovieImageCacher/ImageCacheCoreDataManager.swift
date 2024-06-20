//
//  ImageCacheCoreDataManager.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import CoreData

final class ImageCacheCoreDataManager {
    private static let modelName = "ImageCacheModel"
    private static let model = NSManagedObjectModel.with(name: modelName, in: .module)
    let persistentContainer: NSPersistentContainer
    public let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public enum ContextQueue {
        case main
        case background
    }
    
    public init(storeURL: URL = NSPersistentContainer.defaultDirectoryURL().appendingPathExtension("image-cache.sqlite"),
                contextQueue: ContextQueue = .background) throws {
        guard let model = ImageCacheCoreDataManager.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            persistentContainer = try NSPersistentContainer.load(name: ImageCacheCoreDataManager.modelName, model: model, url: storeURL)
            context = contextQueue == .main ? persistentContainer.viewContext : persistentContainer.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func loadImage(url: String) async -> Data? {
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let imageData = results.first?.imageData {
                return imageData
            }
        } catch {
            debugPrint("Failed to fetch image: \(error)")
        }
        return nil
    }
    
    func saveImage(url: String, imageData: Data?) {
        guard let imageData else { return }
        
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let newImageEntity = ImageEntity(context: context)
                newImageEntity.url = url
                newImageEntity.imageData = imageData
                newImageEntity.timestamp = Date()
            } else {
                let existingImageEntity = results.first
                existingImageEntity?.imageData = imageData
                existingImageEntity?.timestamp = Date()
            }
            try context.save()
        } catch {
            debugPrint("Failed to fetch or save image: \(error)")
        }
    }
    
    func deleteOutdatedEntities(olderThan time: TimeInterval) {
        
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        let timeBuffer = Date().addingTimeInterval(-time)
        fetchRequest.predicate = NSPredicate(format: "timestamp < %@", timeBuffer as NSDate)
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach({ context.delete($0) })
            try context.save()
        } catch {
            debugPrint("Failed to remove old images: \(error)")
        }
    }
}
