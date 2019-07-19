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
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    @IBOutlet weak var gameNameTextField: UITextField! {
        didSet { gameNameTextField.delegate = self }
    }
    @IBOutlet weak var dateLabel: UILabel!
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
        presenter?.didTapSaveButton()
    }
    
    @IBAction func backButtonTapped() {
        presenter?.didTapBackButton()
    }
    
    @IBAction func exitButtonTapped() {
        presenter?.didTapExitButton()
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
        if error == nil {
            let ac = UIAlertController(title: "저장 완료", message: "기록을 앨범에서 확인하세요", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "저장 실패", message: "사진 추가 권한을 설정해주세요", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
}

extension RecordView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
