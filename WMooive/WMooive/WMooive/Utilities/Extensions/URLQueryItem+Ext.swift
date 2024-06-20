//
//  URLQueryItem+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import Foundation

extension URLQueryItem {
    static func page(_ page: String) -> Self { URLQueryItem(name: "page",value: page) }
    
    @available(iOS 16, *)
    static func langue(_ langue: Locale.LanguageCode) -> Self { URLQueryItem(name: "language",value: langue.identifier) }
}
