//
//  NibLoadable.swift
//  WannaBasket
//
//  Created by Het Song on 19/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol NibLoadable {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    func loadViewFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        view.frame = self.bounds
        addSubview(view)
    }
}
