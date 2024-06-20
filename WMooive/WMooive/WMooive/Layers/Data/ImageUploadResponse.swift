//
//  ImageUploadResponse.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import Foundation

struct ResponseData: Codable {
    let result: Bool?
    let responseMessage: String?
    let data: DataDetails?
}

struct DataDetails: Codable {
    let base64str: String?
    let title: String?
}
