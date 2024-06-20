//
//  ImageCacherInterface.swift
//  
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

public protocol ImageCacherInterface {
    func saveImage(url: String, image: UIImage)
    func loadImage(url: String) async -> UIImage?
}
