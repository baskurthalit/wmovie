//
//  UIView+Ext.swift
//  WMooive
//
//  Created by Halit Baskurt on 19.06.2024.
//

import UIKit

extension UIView {
    func fullRotate(duration: Double = 1) {
        if layer.animation(forKey: "rotationanimationkey").isNil {
            let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0
            rotationAnimation.toValue = Float.pi * 2
            rotationAnimation.duration = duration
            rotationAnimation.speed = 0.6
            rotationAnimation.repeatCount = .infinity
            layer.add(rotationAnimation, forKey: "rotationanimationkey")
        }
    }
}

extension UIView {
    var isShimmering: Bool {
        get {
            return layer.mask is ShimmeringLayer
        }
        set {
            if newValue {
                startShimmering()
            } else {
                stopShimmering()
            }
        }
    }
    
    private func startShimmering() {
        let shimmeringLayer = ShimmeringLayer()
        shimmeringLayer.frame = bounds
        layer.mask = shimmeringLayer
        shimmeringLayer.startAnimation()
    }
    
    private func stopShimmering() {
        layer.mask = nil
    }
    
    private class ShimmeringLayer: CAGradientLayer {
        
        override init() {
            super.init()
            setupLayer()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupLayer()
        }
        
        private func setupLayer() {
            let white = UIColor.white.cgColor
            let alpha = UIColor.white.withAlphaComponent(0.75).cgColor
            
            colors = [alpha, white, alpha]
            startPoint = CGPoint(x: 0.0, y: 0.4)
            endPoint = CGPoint(x: 1.0, y: 0.6)
            locations = [0.4, 0.5, 0.6]
            frame = CGRect(x: -bounds.size.width, y: 0, width: bounds.size.width*3, height: bounds.size.height)
        }
        
        func startAnimation() {
            let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
            animation.fromValue = [0.0, 0.1, 0.2]
            animation.toValue = [0.8, 0.9, 1.0]
            animation.duration = 1.25

            animation.repeatCount = .infinity
            add(animation, forKey: "shimmer")
            
            NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
        @objc private func restartAnimation() {
            removeAnimation(forKey: "shimmer")
            startAnimation()
        }
    }
}
