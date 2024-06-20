//
//  AppConfigration.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import Foundation


final class AppConfiguration {
    lazy var apiKey: String? = { try? Configuration.value(for: "API_KEY") }()
    
    lazy var apiBaseURL: String? = { try? Configuration.value(for: "API_BASE_URL") }()
    
    var bundleVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    var bundleId: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
    }
    
    var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
        
    static var appConfigType: AppConfigType {
        return AppConfigType(cfBundleName: Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "")
    }
    
}
