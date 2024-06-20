//
//  AppConfigrationType.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import Foundation


enum AppConfigType {
    case test
    case prod

    init(cfBundleName: String) {
        switch cfBundleName {
        case "WMovie-Test":
            self = .test
        default:
            self = .prod
        }
    }
    
    var bundleIdentifier: String {
        switch self {
        case .prod:return "bseyha.WMooive.Prod"
        case .test:return "bseyha.WMooive"
        }
    }
    
    var configName: String {
        switch self {
        case .prod: return "WMovie-Prod"
        case .test: return "WMovie-Test"
        }
    }
}
