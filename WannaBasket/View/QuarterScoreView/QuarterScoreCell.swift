//
//  QuarterScoreCell.swift
//  WannaBasket
//
//  Created by Het Song on 16/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class QuarterScoreCell: UIView, NibLoadable {

    @IBOutlet weak var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func setup(text: String, color: UIColor, fontSize: CGFloat) {
        textLabel.text = text
        textLabel.textColor = color
        textLabel.font = UIFont(name: textLabel.font.fontName, size: fontSize)
    }
}
