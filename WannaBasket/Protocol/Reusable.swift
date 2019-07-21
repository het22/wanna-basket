//
//  Reusable.swift
//  WannaBasket
//
//  Created by Het Song on 19/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
