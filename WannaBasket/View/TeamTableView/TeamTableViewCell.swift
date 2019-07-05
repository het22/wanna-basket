//
//  TeamTableViewCell.swift
//  WannaBasket
//
//  Created by Het Song on 24/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rightArrow: UILabel!
    @IBOutlet weak var leftArrow: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectionStyle = .none
    }
    
    func setup(name: String) {
        nameLabel.text = name
    }
    
    var highlightOnLeft: Bool = false {
        willSet(newVal) {
            if newVal == highlightOnLeft { return }
            leftArrow.textColor = newVal ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            leftArrow.backgroundColor = newVal ? Constants.Color.HomeDefault : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    var highlightOnRight: Bool = false {
        willSet(newVal) {
            if newVal == highlightOnRight { return }
            rightArrow.textColor = newVal ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            rightArrow.backgroundColor = newVal ? Constants.Color.AwayDefault : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }

    var tapOnLeft: Bool = true
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            tapOnLeft = location.x < (self.bounds.width / 2)
        }
        super.touchesEnded(touches, with: event)
    }
}
