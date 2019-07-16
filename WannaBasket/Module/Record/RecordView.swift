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
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var quarterScoreView: QuarterScoreView!
    
    @IBOutlet weak var homePlayerTableView: PlayerTableView!
    @IBOutlet weak var awayPlayerTableView: PlayerTableView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    deinit { print( "Deinit: ", self) }
    
	override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func updateScoreLabel(score: (home: Int, away: Int)) {
        let homeText = scoreFormat.string(from: NSNumber(value: score.home))!
        let awayText = scoreFormat.string(from: NSNumber(value: score.away))!
        let mutableString = NSMutableAttributedString(string: "\(homeText) : \(awayText)")
        mutableString.addAttribute(.foregroundColor,
                                   value: Constants.Color.HomeDefault,
                                   range: NSRange(location: 0, length: 3))
        mutableString.addAttribute(.foregroundColor,
                                   value: Constants.Color.AwayDefault,
                                   range: NSRange(location: 6, length: 3))
//        scoreLabel.attributedText = mutableString
    }
    
    func updateQuarterScoreView(name: (home: String, away: String), scores: [(quarter: Quarter, home: Int, away: Int)]) {
        quarterScoreView.setup(name: name, scores: scores)
    }
    
    func updateViewHeight(cellCount: Int) {
        let size = homePlayerTableView.cellSize + homePlayerTableView.cellSpacing
        heightConstraint.constant = size * CGFloat(cellCount) + homePlayerTableView.cellSpacing
    }
    
    func updatePlayerTableView(players: [Player], of home: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.playerList = players
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
            let ac = UIAlertController(title: "저장 실패", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
}
