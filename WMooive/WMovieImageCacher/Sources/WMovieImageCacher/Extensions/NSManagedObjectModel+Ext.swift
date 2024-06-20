//
//  NSManagedObjectModel.swift
//  
//
//  Created by Halit Baskurt on 19.06.2024.
//

import CoreData

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

