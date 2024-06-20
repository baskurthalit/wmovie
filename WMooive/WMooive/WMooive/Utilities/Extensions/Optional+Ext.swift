//
//  Optional+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import Foundation

extension Optional {
    var isNotNil: Bool { self != nil }
    var isNil: Bool { self == nil }
}
