//
//  QuarterSelectView.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol QuarterSelectViewDelegate {
    func didQuarterButtonTap(quarterNum: Int?)
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
    
    func setup(currentQuarterNum: Int) {
        let count = 4
        var firstView: UIView?
        for i in 0...count {
            let view = ToggleView(frame: CGRect.zero)
            view.setup(name: (i==count) ? "나가기" : "\(i+1)쿼터",
                highlightColor: (i==count) ? Constants.Color.Silver : Constants.Color.Black)
            view.isHighlighted = (i==currentQuarterNum)
            hStack.addArrangedSubview(view)
            
            let gesture = UITapGestureRecognizerWithClosure {
                self.delegate?.didQuarterButtonTap(quarterNum: (i==count) ? nil : i)
            }
            gesture.numberOfTapsRequired = 1
            view.addGestureRecognizer(gesture)
            
            if i==0 { firstView = view }
            else {
                view.widthAnchor.constraint(equalTo: firstView!.widthAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
}
