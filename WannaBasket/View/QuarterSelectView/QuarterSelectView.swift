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
        isShowingWarningView = true
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
    
    private var backgroundView: UIView?
    private var warningView: WarningView?
    private var isShowingWarningView: Bool = false {
        willSet(newVal) {
            if newVal == isShowingWarningView { return }
            guard let superview = superview else { return }
            if newVal {
                let dismissGesture = UITapGestureRecognizerWithClosure { [weak self] in
                    self?.isShowingWarningView = false
                }
                
                backgroundView = UIView(frame: superview.bounds)
                backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
                backgroundView!.addGestureRecognizer(dismissGesture)
                superview.addSubview(backgroundView!)
                
                warningView = WarningView(frame: CGRect.zero)
                warningView?.delegate = self
                warningView?.translatesAutoresizingMaskIntoConstraints = false
                superview.addSubview(warningView!)
                
                NSLayoutConstraint.activate([
                    warningView!.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                    warningView!.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0),
                    warningView!.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.6),
                    warningView!.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.5)])
            } else {
                backgroundView?.removeFromSuperview()
                warningView?.removeFromSuperview()
                backgroundView = nil
                warningView = nil
            }
        }
    }
}

extension QuarterSelectView: WarningViewDelegate {
    
    func didTapBackButton() {
        isShowingWarningView = false
    }
    
    func didTapExitButton() {
        isShowingWarningView = false
        delegate?.didSelectExit()
    }
}
