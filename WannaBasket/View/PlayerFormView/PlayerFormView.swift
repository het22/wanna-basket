//
//  PlayerFormView.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol PlayerFormViewDelegate: class {
    func didTapPlayerFormCancelButton()
    func didTapPlayerFormDeleteButton(index: Int)
    func didTapPlayerFormCompleteButton(player: PlayerOfTeam)
    func didTapPlayerFormEditButton(player: PlayerOfTeam, index: Int)
    func didTapPlayerNumberButton() -> [Bool]
}

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
    // MARK: IBActions
    // --------------------------------------------------
    @IBAction func numberButtonTapped() {
        nameTextField.resignFirstResponder()
        isShowingNumberSelectView = true
    }
    @IBAction func leftButtonTapped() {
        if isEditMode, let index = index {
            delegate?.didTapPlayerFormDeleteButton(index: index)
        } else {
            delegate?.didTapPlayerFormCancelButton()
        }
    }
    @IBAction func rightButtonTapped() {
        if let name = validatedName, self.player != nil {
            self.player!.name = name
            if isEditMode {
                if let index = index {
                    delegate?.didTapPlayerFormEditButton(player: self.player!, index: index)
                } else {
                    animateShake(completion: nil)
                }
            } else {
                delegate?.didTapPlayerFormCompleteButton(player: self.player!)
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
            leftButton.setTitle(isEditMode ? Constants.Text.Delete : Constants.Text.Cancel,
                                for: .normal)
            rightButton.setTitle(isEditMode ? Constants.Text.Edit : Constants.Text.Complete,
                                 for: .normal)
        }
    }
    private var index: Int?
    private var player: PlayerOfTeam? {
        didSet {
            if let player = player {
                nameTextField.text = player.name
                numberButton.setTitle((player.number==100) ? "00" : "\(player.number)", for: .normal)
                numberButton.setTitleColor(Constants.Color.Black, for: .normal)
            }
        }
    }
    func setup(isEditMode: Bool, player: PlayerOfTeam?, index: Int?) {
        self.isEditMode = isEditMode
        self.index = index
        self.player = player
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

extension PlayerFormView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rightButtonTapped()
        return true
    }
}

extension PlayerFormView: NumberSelectViewDelegate {
    
    func didSelectItem(at indexPath: IndexPath) {
        if let player = self.player {
            self.player = PlayerOfTeam(uuid: player.uuid,
                                       name: player.name,
                                       teamID: player.teamID,
                                       number: indexPath.row)
        } else {
            let name = nameTextField.text ?? ""
            player = PlayerOfTeam(uuid: name,
                                  name: name,
                                  teamID: "",
                                  number: indexPath.row)
        }
        isShowingNumberSelectView = false
    }
}
