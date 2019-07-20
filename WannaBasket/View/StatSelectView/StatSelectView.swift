//
//  StatSelectView.swift
//  WannaBasket
//
//  Created by Het Song on 06/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol StatSelectViewDelegate: class {
    func didSelectStat(stat: Stat)
    func didSelectUndo()
}

class StatSelectView: UIView, NibLoadable {
    
    weak var delegate: StatSelectViewDelegate?
    
    @IBOutlet weak var undoToggleView: ToggleView!
    @IBOutlet weak var pt1ToggleView: ToggleView!
    @IBOutlet weak var pt2ToggleView: ToggleView!
    @IBOutlet weak var pt3ToggleView: ToggleView!
    
    lazy var views = [undoToggleView, pt1ToggleView, pt2ToggleView, pt3ToggleView]
    lazy var stats = [nil, Stat.Score(.One), Stat.Score(.Two), Stat.Score(.Three)]
    
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
        for i in 0...views.count-1 {
            views[i]?.setup(name: i==0 ? Constants.Text.Undo : (stats[i]?.description ?? ""),
                            highlightColor: i==0 ? Constants.Color.Steel : Constants.Color.Black)
            let gesture = UITapGestureRecognizerWithClosure { [weak self] in
                if let stat = self?.stats[i] {
                    self?.delegate?.didSelectStat(stat: stat)
                } else {
                    self?.delegate?.didSelectUndo()
                }
            }
            gesture.numberOfTapsRequired = 1
            views[i]?.addGestureRecognizer(gesture)
        }
    }
    
    func highlightCell(of stat: Stat?, bool: Bool) {
        if let index = stats.firstIndex(where: { $0==stat }), let view = views[index] {
            view.isHighlighted = bool
        }
    }
    
    func blinkStatCell(of stat: Stat?, completion: ((Bool)->Void)?) {
        if let index = stats.firstIndex(where: { $0==stat }), let view = views[index] {
            self.isUserInteractionEnabled = false
            view.animateBlink { bool in
                completion?(bool)
                self.isUserInteractionEnabled = true
            }
        }
    }
}
