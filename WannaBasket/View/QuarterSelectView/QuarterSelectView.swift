//
//  QuarterSelectView.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol QuarterSelectViewDelegate {
    func didQuarterSelect(quarterType: Time.Quarter)
    func didExitSelect()
}

class QuarterSelectView: UIView, NibLoadable {
    
    var delegate: QuarterSelectViewDelegate?
    
    @IBOutlet weak var hStack: UIStackView!
    
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
        layer.borderColor = Constants.Color.Steel.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        hStack.spacing = 5
    }
    
    func setup(maxRegularQuarterNum: Int, overtimeQuarterCount: Int, currentQuarter: Time.Quarter) {
        
        let exitView: ToggleView = {
            let view = ToggleView(frame: CGRect.zero)
            view.setup(name: "나가기", highlightColor: Constants.Color.Silver)
            hStack.addArrangedSubview(view)
            let gesture = UITapGestureRecognizerWithClosure { self.delegate?.didExitSelect() }
            view.addGestureRecognizer(gesture)
            return view
        }()
        
        for i in 1...maxRegularQuarterNum {
            let quarterType = Time.Quarter.Regular(i)
            let quarterView = ToggleView(frame: CGRect.zero)
            quarterView.setup(name: quarterType.description,
                              highlightColor: Constants.Color.Black)
            quarterView.isHighlighted = (currentQuarter == Time.Quarter.Regular(i))
            hStack.insertArrangedSubview(quarterView, at: i-1)
            let gesture = UITapGestureRecognizerWithClosure {
                self.delegate?.didQuarterSelect(quarterType: quarterType)
            }
            quarterView.addGestureRecognizer(gesture)
            quarterView.widthAnchor.constraint(equalTo: exitView.widthAnchor, multiplier: 1.0).isActive = true
        }
    }
}
