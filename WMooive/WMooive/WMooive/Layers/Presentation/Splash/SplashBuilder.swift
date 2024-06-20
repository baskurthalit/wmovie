//
//  SplashBuilder.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import UIKit

protocol SplashScreenBuilder {
    func build(coordinator cDelegate: any CoordinatorDelegate) -> UIViewController
}

struct SplashScreenBuilderImpl: SplashScreenBuilder {
    func build(coordinator cDelegate: any CoordinatorDelegate) -> UIViewController {
        let viewController = SplashVC(nibName: SplashVC.className, bundle: nil)
        viewController.coordinator = cDelegate
        let splashViewModel: SplashVM = SplashVMImpl()
        viewController.inject(viewModel: splashViewModel)
        return viewController
    }
}
