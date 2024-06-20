//
//  BaseViewController.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import UIKit

class BaseViewController: UIViewController, LoadingShowable {
    weak var coordinator: (any CoordinatorDelegate)?
    
    func setNavigationTitle(_ title : String, _ color : UIColor = .black) {
        self.title = title
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                                                                        NSAttributedString.Key.foregroundColor: color]
    }
    
    
    
    
    
    func setNavigationBackButton() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButtonOnNavigationController))
        
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setupNavigationRightButton(imageName: String, action: Selector? = nil) {
        let buttonImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItems = [rightButton]
    }
    
    @objc func didTapBackButtonOnNavigationController() {
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
