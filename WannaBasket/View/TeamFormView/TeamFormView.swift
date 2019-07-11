//
//  TeamFormView.swift
//  WannaBasket
//
//  Created by Het Song on 26/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol TeamFormViewDelegate {
    func didTapTeamFormCancelButton()
    func didTapTeamFormCompleteButton(name: String?)
}

class TeamFormView: UIView, NibLoadable {
    
    var delegate: TeamFormViewDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var leftArrowLabel: UILabel!
    @IBOutlet weak var rightArrowLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
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
        nameTextField.delegate = self
        [self, buttonView].forEach {
            $0?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0?.layer.borderWidth = 1
        }
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.didTapTeamFormCancelButton()
    }
    
    @IBAction func completeButtonTapped() {
        delegate?.didTapTeamFormCompleteButton(name: nameTextField.text)
    }
}

extension TeamFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didTapTeamFormCompleteButton(name: textField.text)
        return true
    }
}
