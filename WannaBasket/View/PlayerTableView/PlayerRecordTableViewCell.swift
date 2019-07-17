//
//  PlayerRecordTableViewCell.swift
//  WannaBasket
//
//  Created by Het Song on 16/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class PlayerRecordTableViewCell: UITableViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var hStack: UIStackView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
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
    
    func setup(home: Bool, player: Player, records: [Record], highlightColor: UIColor) {
        if !home {
            hStack.removeArrangedSubview(numberLabel)
            hStack.removeArrangedSubview(nameLabel)
            hStack.addArrangedSubview(nameLabel)
            hStack.addArrangedSubview(numberLabel)
        }
        nameLabel.text = player.name
        numberLabel.text = "\(player.number)"
        let score = records.reduce(0) {
            var point = 0
            if case Stat.Score(let Point) = $1.stat {
                point += Point.rawValue
            }
            return $0 + point
        }
        scoreLabel.text = "\(score)점"
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
