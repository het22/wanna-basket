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
    var number: Int?
    
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
    
    private var backgroundView: UIView?
    private var numberSelectView: NumberSelectView?
    var isShowingNumberSelectView: Bool = false {
        willSet(newVal) {
            if newVal == isShowingNumberSelectView { return }
            guard let superview = superview else { return }
            if newVal {
                let dismissGesture = UITapGestureRecognizerWithClosure { self.isShowingNumberSelectView = false }
                
                backgroundView = UIView(frame: superview.bounds)
                backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
                backgroundView!.addGestureRecognizer(dismissGesture)
                superview.addSubview(backgroundView!)
                
                numberSelectView = NumberSelectView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
                numberSelectView?._delegate = self
                numberSelectView?.translatesAutoresizingMaskIntoConstraints = false
                superview.addSubview(numberSelectView!)
                
                NSLayoutConstraint.activate([
                    numberSelectView!.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                    numberSelectView!.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0),
                    numberSelectView!.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.75),
                    numberSelectView!.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.75)])
            } else {
                backgroundView?.removeFromSuperview()
                numberSelectView?.removeFromSuperview()
                backgroundView = nil
                numberSelectView = nil
            }
        }
    }
    
    @IBAction func numberButtonTapped() {
        nameTextField.resignFirstResponder()
        isShowingNumberSelectView = true
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.didTapPlayerFormCancelButton()
    }
    
    @IBAction func completeButtonTapped() {
        if isNameValid { delegate?.didTapPlayerFormCompleteButton(name: trimmedName, number: number) }
        else { animateShake(completion: nil) }
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
        let regex = Constants.Regex.PlayerName
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: trimmedName)
        return isValid
    }
}

extension PlayerFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        completeButtonTapped()
        return true
    }
}

extension PlayerFormView: NumberSelectViewDelegate {
    
    func didSelectItem(at indexPath: IndexPath) {
        number = indexPath.row
        numberButton.setTitle((number==100) ? "00" : "\(number!)", for: .normal)
        numberButton.setTitleColor(Constants.Color.Black, for: .normal)
        isShowingNumberSelectView = false
    }
}
