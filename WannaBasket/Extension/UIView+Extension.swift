//
//  UIView+Extension.swift
//  WannaBasket
//
//  Created by Het Song on 08/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateBlink(completion: @escaping (Bool)->Void) {
        let duration = 0.08
        let delay = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: [.repeat, .autoreverse], animations: {
            self.alpha = 0.5
        }, completion: { bool in
            self.alpha = 1.0
            completion(bool)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.32) {
            self.layer.removeAllAnimations()
        }
    }
}
