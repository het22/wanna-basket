//
//  StatSelectView.swift
//  WannaBasket
//
//  Created by Het Song on 06/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol StatSelectViewDelegate {
    func didStatSelect(stat: Stat.Score?)
}

class StatSelectView: UIView, NibLoadable {
    
    var delegate: StatSelectViewDelegate?
    
    @IBOutlet weak var undoToggleView: ToggleView!
    @IBOutlet weak var score1ToggleView: ToggleView!
    @IBOutlet weak var score2ToggleView: ToggleView!
    @IBOutlet weak var score3ToggleView: ToggleView!
    
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
        let views = [undoToggleView, score1ToggleView, score2ToggleView, score3ToggleView]
        let stats = [nil, Stat.Score.One, Stat.Score.Two, Stat.Score.Three]
        let names = ["취소", "1점", "2점", "3점"]
        
        for i in 0...views.count-1 {
            views[i]?.setup(name: names[i],
                            highlightColor: i==0 ? Constants.Color.Steel : highlightColor)
            let gesture = UITapGestureRecognizerWithClosure {
                self.delegate?.didStatSelect(stat: stats[i])
            }
            gesture.numberOfTapsRequired = 1
            views[i]?.addGestureRecognizer(gesture)
        }
    }
    
    let highlightColor = Constants.Color.Black
    func highlightCell(of stat: Stat.Score?, bool: Bool) {
        let views = [undoToggleView, score1ToggleView, score2ToggleView, score3ToggleView]
        let stats = [nil, Stat.Score.One, Stat.Score.Two, Stat.Score.Three]
        if let index = stats.firstIndex(of: stat) {
            views[index]?.isHighlighted = bool
        }
    }
}
