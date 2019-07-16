//
//  NumberSelectViewCell.swift
//  WannaBasket
//
//  Created by Het Song on 12/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class NumberSelectViewCell: UICollectionViewCell, Reusable, NibLoadable {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var underBarView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 1
        layer.borderColor = Constants.Color.Black.cgColor
    }
    
    func setup(number: Int) {
        numberLabel.text = "\(Constants.Format.PlayerNumber(number))"
    }
    
    var highlightColor: UIColor = Constants.Color.Black
    var isCustomHighlighted: Bool = false {
        didSet(oldVal) {
            if oldVal == isCustomHighlighted { return }
            self.backgroundColor = isCustomHighlighted ? highlightColor : Constants.Color.White
            underBarView.backgroundColor = isCustomHighlighted ? Constants.Color.White : highlightColor
            numberLabel.textColor = isCustomHighlighted ? Constants.Color.White: Constants.Color.Black
        }
    }
}
