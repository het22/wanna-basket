//
//  QuarterScoreView.swift
//  WannaBasket
//
//  Created by Het Song on 16/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class QuarterScoreView: UIView, NibLoadable {
    
    @IBOutlet weak var barStackView: UIStackView!
    @IBOutlet weak var homeStackView: UIStackView!
    @IBOutlet weak var awayStackView: UIStackView!
    
    @IBOutlet weak var teamLabel: UILabel! {
        didSet { teamLabel.text = "TEAM".localized }
    }
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel! {
        didSet { totalLabel.text = "TOTAL".localized }
    }
    @IBOutlet weak var homeScoreLabel: UILabel!
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
            let barView = QuarterScoreCell(frame: CGRect.zero)
            barView.setup(text: "\($0.quarter)", color: Constants.Color.Black, fontSize: 30)
            barStackView.insertArrangedSubview(barView, at: barStackView.subviews.count-1)
            barView.widthAnchor.constraint(equalTo: barStackView.subviews.first!.widthAnchor, multiplier: 1.0).isActive = true
            
            let homeView = QuarterScoreCell(frame: CGRect.zero)
            homeView.setup(text: "\($0.home)", color: Constants.Color.HomeDefault, fontSize: 40)
            homeStackView.insertArrangedSubview(homeView, at: homeStackView.subviews.count-1)
            homeView.widthAnchor.constraint(equalTo: homeStackView.subviews.first!.widthAnchor, multiplier: 1.0).isActive = true
            
            let awayView = QuarterScoreCell(frame: CGRect.zero)
            awayView.setup(text: "\($0.away)", color: Constants.Color.AwayDefault, fontSize: 40)
            awayStackView.insertArrangedSubview(awayView, at: awayStackView.subviews.count-1)
            awayView.widthAnchor.constraint(equalTo: awayStackView.subviews.first!.widthAnchor, multiplier: 1.0).isActive = true
        }
    }
}
