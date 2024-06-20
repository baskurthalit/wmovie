//
//  Favorites.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import Foundation

@propertyWrapper
struct Favorites {
    private let key: String
    private let defaultValue: [String]
    
    init(key: String, defaultValue: [String] = []) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: [String] {
        get { return UserDefaults.standard.stringArray(forKey: key) ?? defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
}
