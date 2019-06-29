//
//  QuarterView.swift
//  WannaBasket
//
//  Created by Het Song on 28/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class QuarterSelectView: UIView, NibLoadable {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        commonInit()
    }
    
    func commonInit() {
        layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}

extension QuarterSelectView: QuarterViewDelegate {
    
    func didQuarterViewTap(id: ObjectIdentifier) {
        
    }
}
