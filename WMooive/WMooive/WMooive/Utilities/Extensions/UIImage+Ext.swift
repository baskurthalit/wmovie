//
//  UIImage+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 20.06.2024.
//


import UIKit

extension UIImage {
    func convertImageToBase64String() -> String? {
        guard let imageData = self.pngData() else { return nil }
        
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        return base64String
    }
}

