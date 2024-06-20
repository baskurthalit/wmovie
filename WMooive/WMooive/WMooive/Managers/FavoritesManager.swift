//
//  FavoritesManager.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import Foundation

protocol FavoritesDelegate: AnyObject {
    func didUpdateFavorites(itemRemoved itemID:String)
    func didUpdateFavorites(itemAdded itemID:String)
}

extension FavoritesDelegate {
    func didUpdateFavorites(itemRemoved itemID:String) { }
    func didUpdateFavorites(itemAdded itemID:String) { }
}

final class FavoritesManager {
    static let shared: FavoritesManager = .init()
    @Favorites(key: "favoriteItems")
    var favoriteItems: [String]
    var delegate: MulticastDelegate<FavoritesDelegate> = .init()
    
    private init() { }
    
    func toggleFavorite(itemID: String) { addFavorite(itemID: itemID) }
    
    private func addFavorite(itemID: String) {
        if !favoriteItems.contains(itemID) {
            favoriteItems.append(itemID)
            delegate.invokeDelegates { $0.didUpdateFavorites(itemAdded: itemID) }
        } else {
            removeFavorite(itemID: itemID)
        }
    }

    private func removeFavorite(itemID: String) {
        if let index = favoriteItems.firstIndex(of: itemID) {
            favoriteItems.remove(at: index)
            delegate.invokeDelegates { $0.didUpdateFavorites(itemRemoved: itemID) }
        } else {
            addFavorite(itemID: itemID)
        }
    }
    
    func isFavorite(itemID: String) -> Bool { favoriteItems.contains(where: { $0 == itemID }) }
}
