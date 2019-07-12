//
//  PlayerFormView.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol PlayerFormViewDelegate {
    func didTapPlayerFormCancelButton()
    func didTapPlayerFormCompleteButton(name: String?, number: Int?)
}

class PlayerFormView: UIView, NibLoadable {
    
    var delegate: PlayerFormViewDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberButton: UIButton!
    
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
    
    @IBAction func numberButtonTapped() {
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.didTapPlayerFormCancelButton()
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
        if isNameValid { delegate?.didTapPlayerFormCompleteButton(name: trimmedName, number: nil) }
        else { animateShake(completion: nil) }
    }
}

extension PlayerFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isNameValid { delegate?.didTapPlayerFormCompleteButton(name: trimmedName, number: nil) }
        else { animateShake(completion: nil) }
        return true
    }
}
