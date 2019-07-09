//
//  UIView+Extension.swift
//  WannaBasket
//
//  Created by Het Song on 08/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateBlink(completion: ((Bool)->Void)?) {
        let duration = 0.4
        let delay = 0.0
        UIView.animate(withDuration: duration/4, delay: delay, options: [.repeat, .autoreverse], animations: {
            self.alpha = 0.5
        }, completion: { bool in
            self.alpha = 1.0
            completion?(bool)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + (duration)) {
            self.layer.removeAllAnimations()
        }
    }
    
    func animateGradient(completion: ((Bool)->Void)?) {
        let gradient: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            return gradient
        }()
        self.layer.addSublayer(gradient)
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        animation.values = [
            [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor],
            [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor],
            [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor],
            [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor],
            [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor],
            [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        ]
        animation.keyTimes = [0,0.2,0.4,0.6,0.8,1.0]
        animation.duration = 0.4
        animation.delegate = self
        animation.isRemovedOnCompletion = true
        gradient.add(animation, forKey: "animation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (animation.duration/2)) {
            completion?(true)
        }
    }
}

extension UIView: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let sublayers = self.layer.sublayers {
            sublayers.forEach { $0.removeFromSuperlayer() }
        }
    }
}
