//
//  QuarterScoreView.swift
//  WannaBasket
//
//  Created by Het Song on 16/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class QuarterScoreView: UIView, NibLoadable {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var baseView: UIStackView!
    
    @IBOutlet weak var teamLabel: UILabel! {
        didSet { teamLabel.text = "TEAM".localized }
    }
    @IBOutlet weak var totalLabel: UILabel! {
        didSet { totalLabel.text = "TOTAL".localized }
    }
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        commonInit()
    }
    
    func commonInit() {
        
    }
    
    func setup(name: (home: String, away: String), scores: [(quarter: Quarter, home: Int, away: Int)]) {
        homeTeamNameLabel.text = name.home
        awayTeamNameLabel.text = name.away
        homeScoreLabel.text = "\(scores.reduce(0) { return $0 + $1.home })"
        awayScoreLabel.text = "\(scores.reduce(0) { return $0 + $1.away })"
        
        scores.forEach {
            let cell = QuarterScoreCell(frame: .zero)
            cell.setup(quarter: $0.quarter, homeScore: $0.home, awayScore: $0.away)
            stackView.insertArrangedSubview(cell, at: stackView.arrangedSubviews.count-1)
            cell.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 1.0).isActive = true
        }
    }
}
