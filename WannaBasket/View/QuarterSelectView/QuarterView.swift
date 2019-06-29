//
//  QuarterView.swift
//  WannaBasket
//
//  Created by Het Song on 28/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol QuarterViewDelegate {
    func didQuarterViewTap(id: ObjectIdentifier)
}

class QuarterView: UIView, NibLoadable {
    
    var delegate: QuarterViewDelegate?
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadViewFromNib()
        textLabel.layer.borderWidth = 1
        textLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let gesture = UITapGestureRecognizerWithClosure { self.delegate?.didQuarterViewTap(id: ObjectIdentifier(self)) }
        gesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(gesture)
    }
    
    private var quarter: Quarter?
    func setup(quarter: Quarter) {
        self.quarter = quarter
        textLabel.text = quarter.description
    }
    
    private var _isHighlighted: Bool = false
    var isHighlighted: Bool {
        get { return _isHighlighted }
        set(newVal) {
            textLabel.backgroundColor = newVal ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            textLabel.layer.borderColor = newVal ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textLabel.textColor = newVal ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            _isHighlighted = newVal
        }
    }
}
