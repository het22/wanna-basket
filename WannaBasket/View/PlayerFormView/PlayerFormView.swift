//
//  PlayerFormView.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol PlayerFormViewDelegate {
    func didPlayerFormCancelButtonTap()
    func didPlayerFormCompleteButtonTap(name: String?)
}

class PlayerFormView: UIView, NibLoadable {
    
    var delegate: PlayerFormViewDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    
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
        layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.didPlayerFormCancelButtonTap()
    }
    
    @IBAction func completeButtonTapped() {
        delegate?.didPlayerFormCompleteButtonTap(name: nameTextField.text)
    }
}
