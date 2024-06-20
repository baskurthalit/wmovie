//
//  Endpoint+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import WMovieAPI

extension Endpoint {
    var apiKey: String {
        guard let apiKey = AppConfiguration().apiKey else { return "" }
        return apiKey
    }
    
    var base: String {
        guard let baseUrl = AppConfiguration().apiBaseURL else { return "" }
        return baseUrl
    }
}
