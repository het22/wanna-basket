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
        layer.borderColor = Constants.Color.Black.cgColor
        layer.borderWidth = 1
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    var centerYConstraint: NSLayoutConstraint?
    var moveHeight: CGFloat = 0.0
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let centerYConstraint = centerYConstraint {
            let screenHeight = UIScreen.main.bounds.height
            moveHeight = screenHeight - keyboardHeight - self.frame.maxY - 10
            centerYConstraint.constant += moveHeight
            UIView.animate(withDuration: 0.5) { self.superview?.layoutIfNeeded() }
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let centerYConstraint = centerYConstraint {
            centerYConstraint.constant -= moveHeight
            UIView.animate(withDuration: 0.5) { self.superview?.layoutIfNeeded() }
        }
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.didTapTeamFormCancelButton()
    }
    
    private var trimmedName: String? {
        return nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var isNameValid: Bool {
        let regex = "[가-힣A-Za-z0-9\\s]{2,6}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: trimmedName)
        return isValid
    }
    @IBAction func completeButtonTapped() {
        if isNameValid { delegate?.didTapTeamFormCompleteButton(name: trimmedName) }
        else { animateShake(completion: nil) }
    }
}

extension TeamFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isNameValid { delegate?.didTapTeamFormCompleteButton(name: trimmedName) }
        else { animateShake(completion: nil) }
        return true
    }
}
