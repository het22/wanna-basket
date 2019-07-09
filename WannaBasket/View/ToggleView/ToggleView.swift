//
//  ToggleView.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class ToggleView: UIView, NibLoadable {
    
    @IBOutlet weak var underBarView: UIView!
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
    
    private var highlightColor: UIColor = Constants.Color.Black {
        didSet(oldVal) {
            layer.borderColor = highlightColor.cgColor
            nameLabel.textColor = highlightColor
            underBarView.backgroundColor = highlightColor
        }
    }
    var isHighlighted: Bool = false {
        willSet(newVal) {
            if newVal == isHighlighted { return }
            backgroundColor = newVal ? highlightColor : Constants.Color.White
            nameLabel.textColor = newVal ? Constants.Color.White : highlightColor
            underBarView.backgroundColor = newVal ? Constants.Color.White : highlightColor
        }
    }
}
