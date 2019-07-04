//
//  TeamFormView.swift
//  WannaBasket
//
//  Created by Het Song on 26/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol TeamFormViewDelegate {
    func didTeamFormCancelButtonTap()
    func didTeamFormCompleteButtonTap(name: String?)
}

class TeamFormView: UIView, NibLoadable {
    
    var delegate: TeamFormViewDelegate?
    
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
        layer.borderColor = Constants.Color.Steel.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.didTeamFormCancelButtonTap()
    }
    
    @IBAction func completeButtonTapped() {
        delegate?.didTeamFormCompleteButtonTap(name: nameTextField.text)
    }
}
