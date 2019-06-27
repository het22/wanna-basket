//
//  UIGestureRecognizerWithClosure.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class UITapGestureRecognizerWithClosure: UITapGestureRecognizer {
    
    private var action: ()->Void
    
    @objc private func execute() {
        self.action()
    }
    
    init(action: @escaping ()->Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }
}
