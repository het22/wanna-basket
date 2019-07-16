//
//  QuarterSelectView.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol QuarterSelectViewDelegate: class {
    func didSelectQuarter(quarterType: Quarter)
    func didSelectRecord()
    func didSelectExit()
}

class QuarterSelectView: UIView, NibLoadable {
    
    weak var delegate: QuarterSelectViewDelegate?
    
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
        layer.borderColor = Constants.Color.Black.cgColor
        layer.borderWidth = 1
    }
    
    @IBAction func recordButtonTapped() {
        delegate?.didSelectRecord()
    }
    
    @IBAction func exitButtonTapped() {
        delegate?.didSelectExit()
    }
    
    func setup(maxRegularQuarterNum: Int, overtimeQuarterCount: Int, currentQuarter: Quarter) {
        
        var firstView: ToggleView?
        for i in 1...maxRegularQuarterNum {
            let quarterType = Quarter.Regular(i)
            let quarterView = ToggleView(frame: CGRect.zero)
            quarterView.setup(name: quarterType.description,
                              highlightColor: Constants.Color.Black)
            quarterView.isHighlighted = (currentQuarter == Quarter.Regular(i))
            hStack.insertArrangedSubview(quarterView, at: i-1)
            let gesture = UITapGestureRecognizerWithClosure { [weak self] in
                self?.delegate?.didSelectQuarter(quarterType: quarterType)
            }
            quarterView.addGestureRecognizer(gesture)
            if let firstView = firstView {
                quarterView.widthAnchor.constraint(equalTo: firstView.widthAnchor, multiplier: 1.0).isActive = true
            } else {
                firstView = quarterView
            }
        }
    }
}
