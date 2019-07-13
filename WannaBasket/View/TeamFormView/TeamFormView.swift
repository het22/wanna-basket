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
    func didTapTeamFormDeleteButton(index: Int)
    func didTapTeamFormCompleteButton(name: String)
    func didTapTeamFormEditButton(name: String, index: Int)
}

class TeamFormView: UIView, NibLoadable {
    
    var delegate: TeamFormViewDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var leftArrowLabel: UILabel!
    @IBOutlet weak var rightArrowLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
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
    
    var isEditMode = false {
        didSet(oldVal) {
            if oldVal == isEditMode { return }
            leftButton.setTitle(isEditMode ? "삭제" : "취소", for: .normal)
            rightButton.setTitle(isEditMode ? "수정" : "완료", for: .normal)
        }
    }
    var index: Int?
    func setup(isEditMode: Bool, name: String?, index: Int?) {
        self.isEditMode = isEditMode
        self.nameTextField.text = name
        self.index = index
    }
    
    @IBAction func leftButtonTapped() {
        if isEditMode, let index = index {
            delegate?.didTapTeamFormDeleteButton(index: index)
        } else {
            delegate?.didTapTeamFormCancelButton()
        }
    }
    
    @IBAction func rightButtonTapped() {
        if let name = validatedName, let index = index {
            if isEditMode {
                delegate?.didTapTeamFormEditButton(name: name, index: index)
            } else {
                delegate?.didTapTeamFormCompleteButton(name: name)
            }
        } else {
            animateShake(completion: nil)
        }
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
    
    private var trimmedName: String? {
        return nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var isNameValid: Bool {
        let regex = Constants.Regex.TeamName
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: trimmedName)
        return isValid
    }
    private var validatedName: String? {
        if isNameValid { return trimmedName }
        else { return nil }
    }
}

extension TeamFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rightButtonTapped()
        return true
    }
}
