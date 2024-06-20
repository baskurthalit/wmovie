//
//  UIApplication+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import UIKit

extension UIApplication {
    
    static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
          if let nav = base as? UINavigationController {
              return getTopViewController(base: nav.visibleViewController)

          } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
              return getTopViewController(base: selected)

          } else if let presented = base?.presentedViewController {
              return getTopViewController(base: presented)
          }
        
          return base
      }
}
