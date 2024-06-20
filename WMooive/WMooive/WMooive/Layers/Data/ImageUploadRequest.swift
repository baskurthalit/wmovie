//
//  ImageUploadRequest.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//

import Foundation

struct UploadImageRequest: Codable {
    let prompt: String
    let base64str: String
    let inputImage: Bool
    
    init(prompt starName: String, base64str: String, inputImage: Bool = false) {
        self.prompt = starName
        self.base64str = base64str
        self.inputImage = inputImage
    }
}
