//
//  MovieEndpoint.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import Foundation
import WMovieAPI


struct MovieEndpoint: Endpoint {
    var queryItems: [URLQueryItem]? = [
        URLQueryItem(name: "page",value: "1")
    ]
    
    private let apiVersion: String = "3"
    
    var path: String { apiVersion.appending("/movie/popular") }
    
    var type: WMovieAPI.HTTPMethod { .GET }
    
    var headers: [String : String] { [:] }
    
    var mimeType: String? { nil }
}
