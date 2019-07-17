//
//  TeamCell.swift
//  WannaBasket
//
//  Created by Het Song on 24/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell, NibLoadable, Reusable {
    
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
        rightArrow.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        leftArrow.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
            leftArrow.layer.borderWidth = newVal ? 1 : 0
        }
    }
    
    var highlightOnRight: Bool = false {
        willSet(newVal) {
            if newVal == highlightOnRight { return }
            rightArrow.textColor = newVal ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            rightArrow.backgroundColor = newVal ? Constants.Color.AwayDefault : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            rightArrow.layer.borderWidth = newVal ? 1 : 0
        }
    }
    
    enum Section {
        case Left
        case Middle
        case Right
    }
    var tapSection: Section = .Middle
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let width = self.bounds.width
            if 0...width/3 ~= location.x { tapSection = .Left }
            else if width/3...width*2/3 ~= location.x { tapSection = .Middle }
            else if width*2/3...width ~= location.x { tapSection = .Right }
        }
        super.touchesEnded(touches, with: event)
    }
}
