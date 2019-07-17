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
    @IBOutlet weak var scoreDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 1
        layer.borderColor = Constants.Color.Black.cgColor
        selectionStyle = .none
    }
    
    func setup(home: Bool, player: Player, records: [Record], highlightColor: UIColor) {
        if !home {
            hStack.removeArrangedSubview(numberLabel)
            hStack.removeArrangedSubview(nameLabel)
            hStack.addArrangedSubview(nameLabel)
            hStack.addArrangedSubview(numberLabel)
        }
        self.highlightColor = highlightColor
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
        
        var pt1 = 0, pt2 = 0, pt3 = 0
        records.forEach {
            if case Stat.Score(let Point) = $0.stat {
                switch Point {
                case .One: pt1 += 1
                case .Two: pt2 += 1
                case .Three: pt3 += 1
                }
            }
        }
        let pt1Text = (pt1==0) ? "" : " 자유투(\(pt1)) "
        let pt2Text = (pt2==0) ? "" : " 2점(\(pt2)) "
        let pt3Text = (pt3==0) ? "" : " 3점(\(pt3)) "
        scoreDetailLabel.text = (pt1==0 && pt2==0 && pt3==0) ? "-" : pt1Text + pt2Text + pt3Text
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
