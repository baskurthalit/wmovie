//
//  MulticastDelegate.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import Foundation

final class MulticastDelegate<T> {
    private var delegates = NSHashTable<AnyObject>.weakObjects()

    func addDelegate(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    func removeDelegate(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
    }

    func invokeDelegates(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects {
            invocation(delegate as! T)
        }
    }
}
