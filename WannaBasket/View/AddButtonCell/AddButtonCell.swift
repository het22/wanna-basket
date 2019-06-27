//
//  AddButtonCell.swift
//  WannaBasket
//
//  Created by Het Song on 24/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class AddButtonCell: UITableViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 1
//        layer.cornerRadius = 5
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        selectionStyle = .none
    }
    
    func setup(color: UIColor) {
        layer.borderColor = color.cgColor
        label.backgroundColor = color
    }
}
