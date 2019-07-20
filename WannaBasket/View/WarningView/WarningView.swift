//
//  WarningView.swift
//  WannaBasket
//
//  Created by Het Song on 19/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol WarningViewDelegate: class {
    func didTapExitButton()
    func didTapBackButton()
}

class WarningView: UIView, NibLoadable {
    
    weak var delegate: WarningViewDelegate?
    
    @IBOutlet weak var mainLabel: UILabel! {
        didSet { mainLabel.text = Constants.Text.Message.ExitWarning }
    }
    @IBOutlet weak var subLabel: UILabel! {
        didSet { subLabel.text = Constants.Text.Message.RecordWarning }
    }
    
    @IBOutlet weak var exitButton: UIButton! {
        didSet { exitButton.setTitle(Constants.Text.Exit, for: .normal)}
    }
    @IBOutlet weak var backButton: UIButton! {
        didSet { backButton.setTitle(Constants.Text.Back, for: .normal)}
    }
    
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
    
    @IBAction func exitButtonTapped() {
        delegate?.didTapExitButton()
    }
    
    @IBAction func backButtonTapped() {
        delegate?.didTapBackButton()
    }
}
