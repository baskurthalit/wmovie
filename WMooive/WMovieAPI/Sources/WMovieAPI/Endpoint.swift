//
//  File.swift
//  
//
//  Created by Halit Baskurt on 19.06.2024.
//

import Foundation

public protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var parameters: [String:Any]? { get }
    var type: HTTPMethod { get }
    var headers: [String: String] { get }
    var mimeType: String? { get }
    var queryItems: [URLQueryItem]? { get set }
    var apiKey: String { get }
    var httpBody:Data? { get }
}

public extension Endpoint {
    var scheme: String { "https" }
    var httpBody:Data? { nil }
    var mimeType: String? { nil }
    var apiKey: String { "" }
    var parameters: [String:Any]? { nil }
    
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = base
        components.queryItems = queryItems
        var fullPath = path
        fullPath = "/".appending(path)
        
        components.path = fullPath

        return components
    }
    
    var request: URLRequest? {
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpBody = httpBody
        request.httpMethod = type.rawValue
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if !apiKey.isEmpty { request.setValue("Bearer \(apiKey)",forHTTPHeaderField: "Authorization") }
        
        request.httpShouldHandleCookies = true
        return request
    }
     
}
