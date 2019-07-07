//
//  ToggleView.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class ToggleView: UIView, NibLoadable {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
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
        layer.borderWidth = 1
    }
    
    func setup(name: String, highlightColor: UIColor) {
        nameLabel.text = name
        self.highlightColor = highlightColor
    }
    
    private var highlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet(oldVal) {
            layer.borderColor = highlightColor.cgColor
            nameLabel.textColor = highlightColor
        }
    }
    var isHighlighted: Bool = false {
        willSet(newVal) {
            if newVal == isHighlighted { return }
            view.backgroundColor = newVal ? highlightColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            nameLabel.textColor = newVal ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : highlightColor
        }
    }
}
