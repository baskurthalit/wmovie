//
//  ObservationType.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import Foundation

enum ObservationType<T, E> where E: Error {
    case updateUI(_ data: T? = nil), error(error: E?)
}
