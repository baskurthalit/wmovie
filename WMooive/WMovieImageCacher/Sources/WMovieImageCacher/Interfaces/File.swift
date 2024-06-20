//
//  File.swift
//  
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

public protocol ImageLoaderInterface {
    func loadImage(from urlString: String) async -> UIImage?
}
