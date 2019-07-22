//
//  QuarterScoreCell.swift
//  WannaBasket
//
//  Created by Het Song on 16/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class QuarterScoreCell: UIView, NibLoadable {

    @IBOutlet weak var quarterLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func setup(quarter: Quarter, homeScore: Int, awayScore: Int) {
        quarterLabel.text = "\(quarter)"
        homeScoreLabel.text = "\(homeScore)"
        awayScoreLabel.text = "\(awayScore)"
    }
}
