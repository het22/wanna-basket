//
//  PlayerFormView.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

// --------------------------------------------------
// MARK: PlayerFormView Delegate
// --------------------------------------------------
protocol PlayerFormViewDelegate: class {
    func didTapPlayerFormCancelButton()
    func didTapPlayerFormDeleteButton(player: PlayerOfTeam)
    func didTapPlayerFormCompleteButton(player: PlayerOfTeam)
    func didTapPlayerFormEditButton(player: PlayerOfTeam)
    func didTapPlayerNumberButton() -> [Bool]
}

// --------------------------------------------------
// MARK: PlayerFormView
// --------------------------------------------------
class PlayerFormView: UIView, NibLoadable {
    
    weak var delegate: PlayerFormViewDelegate?
    
    // --------------------------------------------------
    // MARK: IBOutlet Variables
    // --------------------------------------------------
    @IBOutlet weak var nameTextField: UITextField! {
        didSet { nameTextField.placeholder = Constants.Text.Message.EnterPlayerName }
    }
    @IBOutlet weak var numberButton: UIButton!
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
    // MARK: Setup
    // --------------------------------------------------
    private var player = PlayerOfTeam(uuid: "", name: "", teamID: "", number: -1)
    private var name: String? {
        get { return validatedName }
        set { nameTextField.text = newValue }
    }
    private var number: Int? {
        didSet {
            guard let num = number else { return }
            numberButton.setTitle((num==100) ? "00" : "\(num)", for: .normal)
            numberButton.setTitleColor(Constants.Color.Black, for: .normal)
        }
    }
    private var isEditMode = false {
        didSet(oldVal) {
            leftButton.setTitle(isEditMode ? Constants.Text.Delete : Constants.Text.Cancel,
                                for: .normal)
            rightButton.setTitle(isEditMode ? Constants.Text.Edit : Constants.Text.Complete,
                                 for: .normal)
        }
    }
    func setup(player: PlayerOfTeam?) {
        if let player = player {
            self.isEditMode = true
            self.player = player
            self.name = player.name
            self.number = player.number
        } else {
            self.isEditMode = false
        }
    }
    
    // --------------------------------------------------
    // MARK: IBActions
    // --------------------------------------------------
    @IBAction func numberButtonTapped() {
        nameTextField.resignFirstResponder()
        isShowingNumberSelectView = true
    }
    @IBAction func leftButtonTapped() {
        if isEditMode {
            delegate?.didTapPlayerFormDeleteButton(player: player)
        } else {
            delegate?.didTapPlayerFormCancelButton()
        }
    }
    @IBAction func rightButtonTapped() {
        if let name = name, let number = number {
            let editedPlayer = PlayerOfTeam(uuid: player.uuid,
                                            name: name,
                                            teamID: player.teamID,
                                            number: number)
            if isEditMode {
                delegate?.didTapPlayerFormEditButton(player: editedPlayer)
            } else {
                delegate?.didTapPlayerFormCompleteButton(player: editedPlayer)
            }
        } else {
            animateShake(completion: nil)
        }
    }
    
    // --------------------------------------------------
    // MARK: Validate Input Values
    // --------------------------------------------------
    private var validatedName: String? {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let regex = Constants.Regex.PlayerName
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: trimmedName)
        return isValid ? trimmedName : nil
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
            if moveHeight > 0 { moveHeight = 0 }
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
    
    // --------------------------------------------------
    // MARK: Show Number Select View
    // --------------------------------------------------
    private var backgroundView: UIView?
    private var numberSelectView: NumberSelectView?
    private var isShowingNumberSelectView: Bool = false {
        willSet(newVal) {
            if newVal == isShowingNumberSelectView { return }
            guard let superview = superview else { return }
            if newVal {
                let dismissGesture = UITapGestureRecognizerWithClosure { [weak self] in
                    self?.isShowingNumberSelectView = false
                }
                
                backgroundView = UIView(frame: superview.bounds)
                backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
                backgroundView!.addGestureRecognizer(dismissGesture)
                superview.addSubview(backgroundView!)
                
                numberSelectView = NumberSelectView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
                numberSelectView?._delegate = self
                numberSelectView?.isNumberAssigned = delegate?.didTapPlayerNumberButton() ?? []
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
}

// --------------------------------------------------
// MARK: UITextField Delegate
// --------------------------------------------------
extension PlayerFormView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rightButtonTapped()
        return true
    }
}

// --------------------------------------------------
// MARK: NumberSelectView Delegate
// --------------------------------------------------
extension PlayerFormView: NumberSelectViewDelegate {
    
    func didSelectItem(at indexPath: IndexPath) {
        number = indexPath.row
        isShowingNumberSelectView = false
    }
}
