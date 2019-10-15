//
//  RecordView.swift
//  WannaBasket
//
//  Created Het Song on 14/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class RecordView: UIViewController {

	var presenter: RecordPresenterProtocol?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIButton! {
        didSet { backButton.setTitle("< "+Constants.Text.Back, for: .normal) }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet { saveButton.setTitle(Constants.Text.SaveToAlbum, for: .normal) }
    }
    @IBOutlet weak var exitButton: UIButton! {
        didSet { exitButton.setTitle(Constants.Text.Exit+" >", for: .normal) }
    }
    
    @IBOutlet weak var gameNameTextField: UITextField! {
        didSet {
            gameNameTextField.delegate = self
            gameNameTextField.placeholder = Constants.Text.Message.EnterGameName
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var quarterScoreView: QuarterScoreView!
    
    @IBOutlet weak var homePlayerTableView: PlayerTableView!
    @IBOutlet weak var awayPlayerTableView: PlayerTableView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    deinit { print( "Deinit: ", self) }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizerWithClosure { [weak self] in
            self?.gameNameTextField.resignFirstResponder()
        }
        self.view.addGestureRecognizer(gesture)
        presenter?.viewDidLoad()
    }

    @IBAction func saveButtonTapped() {
        self.view.endEditing(true)
        presenter?.didTapSaveButton()
    }
    
    @IBAction func backButtonTapped() {
        presenter?.didTapBackButton()
    }
    
    @IBAction func exitButtonTapped() {
        isShowingWarningView = true
    }
    
    private var backgroundView: UIView?
    private var warningView: WarningView?
    private var isShowingWarningView: Bool = false {
        willSet(newVal) {
            if newVal == isShowingWarningView { return }
            if newVal {
                let dismissGesture = UITapGestureRecognizerWithClosure { [weak self] in
                    self?.isShowingWarningView = false
                }
                
                backgroundView = UIView(frame: self.view.bounds)
                backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
                backgroundView!.addGestureRecognizer(dismissGesture)
                self.view.addSubview(backgroundView!)
                
                warningView = WarningView(frame: CGRect.zero)
                warningView?.delegate = self
                warningView?.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(warningView!)
                
                NSLayoutConstraint.activate([
                    warningView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    warningView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
                    warningView!.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6),
                    warningView!.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)])
            } else {
                backgroundView?.removeFromSuperview()
                warningView?.removeFromSuperview()
                backgroundView = nil
                warningView = nil
            }
        }
    }
}

extension RecordView: RecordViewProtocol {
    
    func updateTeamNameLabel(name: String, of home: Bool) {
        let teamNameLabel = home ? homeTeamNameLabel : awayTeamNameLabel
        teamNameLabel?.text = name
    }
    
    func updateDateLabel(date: Date) {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        let weekday = Calendar.current.component(.weekday, from: date)
        let dateText = "\(year). \(month). \(day). \(Constants.Format.Weekday.init(rawValue: weekday)!)"
        dateLabel.text = dateText
    }
    
    func updateQuarterScoreView(name: (home: String, away: String), scores: [(quarter: Quarter, home: Int, away: Int)]) {
        quarterScoreView.setup(name: name, scores: scores)
    }
    
    func updateViewHeight(cellCount: Int) {
        if case .pad = UIDevice.current.userInterfaceIdiom {
            homePlayerTableView.cellSize = 100
            awayPlayerTableView.cellSize = 100
        }
        let size = homePlayerTableView.cellSize + homePlayerTableView.cellSpacing
        heightConstraint.constant = size * CGFloat(cellCount) + homePlayerTableView.cellSpacing
    }
    
    func updatePlayerTableView(playerTuples: [(player: PlayerOfTeam, records: [Record])], of home: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.playerTuples = playerTuples
    }
    
    func saveImageToAlbum() {
        if let image = scrollView.toImage() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: Constants.Text.Fail,
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: Constants.Text.Confirm,
                                       style: .default,
                                       handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: Constants.Text.Complete,
                                       message: Constants.Text.Message.CheckRecord,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: Constants.Text.Confirm,
                                       style: .default,
                                       handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
}

extension RecordView: WarningViewDelegate {
    
    func didTapBackButton() {
        isShowingWarningView = false
    }
    
    func didTapExitButton() {
        isShowingWarningView = false
        presenter?.didTapExitButton()
    }
}

extension RecordView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
