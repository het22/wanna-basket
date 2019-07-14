//
//  TeamFormView.swift
//  WannaBasket
//
//  Created by Het Song on 26/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

// --------------------------------------------------
// MARK: TeamFormView Delegate
// --------------------------------------------------
protocol TeamFormViewDelegate: class {
    func didTapTeamFormCancelButton()
    func didTapTeamFormDeleteButton(index: Int)
    func didTapTeamFormCompleteButton(name: String)
    func didTapTeamFormEditButton(name: String, index: Int)
}

// --------------------------------------------------
// MARK: TeamFormView
// --------------------------------------------------
class TeamFormView: UIView, NibLoadable {
    
    weak var delegate: TeamFormViewDelegate?
    
    // --------------------------------------------------
    // MARK: IBOutlet Variables
    // --------------------------------------------------
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // --------------------------------------------------
    // MARK: Initialize
    // --------------------------------------------------
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
    }
    
    // --------------------------------------------------
    // MARK: IBActions
    // --------------------------------------------------
    @IBAction func leftButtonTapped() {
        if isEditMode, let index = index {
            delegate?.didTapTeamFormDeleteButton(index: index)
        } else {
            delegate?.didTapTeamFormCancelButton()
        }
    }
    @IBAction func rightButtonTapped() {
        if let name = validatedName {
            if isEditMode {
                if let index = index {
                    delegate?.didTapTeamFormEditButton(name: name, index: index)
                } else {
                    animateShake(completion: nil)
                }
            } else {
                delegate?.didTapTeamFormCompleteButton(name: name)
            }
        } else {
            animateShake(completion: nil)
        }
    }
    
    // --------------------------------------------------
    // MARK: Validate Input Values
    // --------------------------------------------------
    private var trimmedName: String? {
        return nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var validatedName: String? {
        let regex = Constants.Regex.TeamName
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: trimmedName)
        return isValid ? trimmedName : nil
    }
    
    // --------------------------------------------------
    // MARK: Setup EditMode
    // --------------------------------------------------
    private var isEditMode = false {
        didSet(oldVal) {
            if oldVal == isEditMode { return }
            leftButton.setTitle(isEditMode ? Constants.Text.Delete : Constants.Text.Cancel,
                                for: .normal)
            rightButton.setTitle(isEditMode ? Constants.Text.Edit : Constants.Text.Complete,
                                 for: .normal)
        }
    }
    private var index: Int?
    func setup(isEditMode: Bool, name: String?, index: Int?) {
        self.isEditMode = isEditMode
        self.nameTextField.text = name
        self.index = index
    }
    
    // --------------------------------------------------
    // MARK: Setup Keyboard Movement
    // --------------------------------------------------
    private var centerYConstraint: NSLayoutConstraint?
    private var spacing: CGFloat = 0.0
    private var moveHeight: CGFloat = 0.0
    func setupKeyboard(with centerYConstraint: NSLayoutConstraint, spacing: CGFloat) {
        self.centerYConstraint = centerYConstraint
        self.spacing = spacing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let centerYConstraint = centerYConstraint {
            let screenHeight = UIScreen.main.bounds.height
            moveHeight = screenHeight - keyboardHeight - self.frame.maxY - spacing
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
}

// --------------------------------------------------
// MARK: UITextFieldDelegate
// --------------------------------------------------
extension TeamFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rightButtonTapped()
        return true
    }
}
