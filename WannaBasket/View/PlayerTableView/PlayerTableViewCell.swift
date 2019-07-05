//
//  PlayerTableViewCell.swift
//  WannaBasket
//
//  Created by Het Song on 25/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectionStyle = .none
    }
    
    func setup(name: String, highlightColor: UIColor) {
        self.nameLabel.text = name
        self.highlightColor = highlightColor
    }
    
    var highlightColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private var _isHighlighted: Bool = false
    override var isHighlighted: Bool {
        get { return _isHighlighted }
        set(newVal) {
            if newVal == _isHighlighted { return }
            backgroundColor = newVal ? highlightColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            nameLabel.textColor = newVal ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            layer.borderColor = newVal ? highlightColor.cgColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            _isHighlighted = newVal
        }
    }
}
