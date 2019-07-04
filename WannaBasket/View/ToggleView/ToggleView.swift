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
        layer.borderColor = highlightColor.cgColor
        layer.borderWidth = 2
    }
    
    func setup(name: String, highlightColor: UIColor) {
        nameLabel.text = name
        self.highlightColor = highlightColor
    }
    
    private var highlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private var _isHighlighted: Bool = false
    var isHighlighted: Bool {
        get { return _isHighlighted }
        set(newVal) {
            if newVal == _isHighlighted { return }
            view.backgroundColor = newVal ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            nameLabel.textColor = newVal ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            _isHighlighted = newVal
        }
    }
}
