//
//  BaseNavigationController.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import UIKit

class BaseNavigationController: UINavigationController {
    weak var coordinator: (any CoordinatorDelegate)?
    private var window : UIWindow?
    
    deinit { print("DEINIT -> \(self)") }
}

