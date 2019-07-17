//
//  PlayerCell.swift
//  WannaBasket
//
//  Created by Het Song on 25/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var hStack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 1
        layer.borderColor = Constants.Color.Black.cgColor
        numberLabel.layer.borderWidth = 1
        numberLabel.layer.borderColor = Constants.Color.Black.cgColor
        selectionStyle = .none
    }
    
    func setup(home: Bool, player: Player, highlightColor: UIColor) {
        if !home {
            hStack.removeArrangedSubview(numberLabel)
            hStack.addArrangedSubview(numberLabel)
        }
        nameLabel.text = player.name
        numberLabel.text = "\(player.number)"
        self.highlightColor = highlightColor
    }
    
    var highlightColor: UIColor = Constants.Color.Black {
        didSet {
            numberLabel.backgroundColor = highlightColor
        }
    }
    var isCustomHighlighted: Bool = false {
        didSet(oldVal) {
            if oldVal == isCustomHighlighted { return }
            nameLabel.backgroundColor = isCustomHighlighted ? highlightColor : Constants.Color.White
            nameLabel.textColor = isCustomHighlighted ? Constants.Color.White: Constants.Color.Black
        }
    }
}
