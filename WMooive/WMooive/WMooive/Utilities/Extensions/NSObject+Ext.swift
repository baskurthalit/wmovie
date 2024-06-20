//
//  NSObject+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {
    public static var className: String { return String(describing: self) }
}
