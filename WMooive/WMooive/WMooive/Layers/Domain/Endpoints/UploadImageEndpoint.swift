//
//  UploadImageEndpoint.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import WMovieAPI
import Foundation

struct UploadImageEndpoint: Endpoint {
    var queryItems: [URLQueryItem]? = nil
    
    var httpBody: Data?
    var base: String { "www.nftcalculatorsapp.net" }
    var path: String { "text_to_image_case_study" }
    var type: WMovieAPI.HTTPMethod { .POST }
    
    var headers: [String : String] = [
        "accept":"application/json",
        "Content-Type":"application/json"
    ]
    
    init(httpBody: Data?){
        self.httpBody = httpBody
    }
}
