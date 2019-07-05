//
//  GameView.swift
//  WannaBasket
//
//  Created Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GameView: UIViewController {

	var presenter: GamePresenterProtocol?
    
    @IBOutlet weak var homePlayerTableView: PlayerTableView!
    @IBOutlet weak var awayPlayerTableView: PlayerTableView!
    
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeBenchButton: UIButton!
    @IBOutlet weak var awayBenchButton: UIButton!
    
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    @IBOutlet weak var quarterLabel: UILabel!
    
    @IBOutlet weak var gameClockLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    
    
	override func viewDidLoad() {
        super.viewDidLoad()
        homePlayerTableView._delegate = self
        awayPlayerTableView._delegate = self
        presenter?.viewDidLoad()
    }
    
    @IBAction func quarterLabelTapped() {
        presenter?.didQuarterLabelTap()
    }
    
    @IBAction func gameClockLabelTapped() {
        presenter?.didGameClockLabelTap()
    }
    
    @IBAction func shotClockLabelTapped() {
        presenter?.didShotClockLabelTap()
    }
    
    @IBAction func reset14ButtonTapped() {
        presenter?.didReset14ButtonTap()
    }
    
    @IBAction func reset24ButtonTapped() {
        presenter?.didReset24ButtonTap()
    }
    
    @IBAction func homeBenchButtonTapped() {
        presenter?.didBenchButtonTap(of: true)
    }
    
    @IBAction func awayBenchButtonTapped() {
        presenter?.didBenchButtonTap(of: false)
    }
    
    private var backgroundView: UIView?
    private var quarterSelectView: QuarterSelectView?
    private var isShowingQuaterSelectView: Bool = false
    func showQuarterSelectView(maxRegularQuarterNum: Int, overtimeQuarterCount: Int,currentQuarterNum: Int, bool: Bool) {
        if bool == isShowingQuaterSelectView { return }
        isShowingQuaterSelectView = bool
        if bool {
            let dismissGesture = UITapGestureRecognizerWithClosure {
                self.showQuarterSelectView(maxRegularQuarterNum: maxRegularQuarterNum,
                                           overtimeQuarterCount: overtimeQuarterCount,
                                           currentQuarterNum: currentQuarterNum,
                                           bool: false)
            }
            dismissGesture.numberOfTapsRequired = 1
            
            backgroundView = UIView(frame: view.bounds)
            backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
            backgroundView!.addGestureRecognizer(dismissGesture)
            self.view.addSubview(backgroundView!)
            
            quarterSelectView = QuarterSelectView(frame: CGRect.zero)
            quarterSelectView?.delegate = self
            quarterSelectView?.setup(maxRegularQuarterNum: maxRegularQuarterNum,
                                     overtimeQuarterCount: overtimeQuarterCount,
                                     currentQuarterNum: currentQuarterNum)
            self.view.addSubview(quarterSelectView!)
            
            quarterSelectView!.translatesAutoresizingMaskIntoConstraints = false
            quarterSelectView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            quarterSelectView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
            quarterSelectView!.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
            quarterSelectView!.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        } else {
            backgroundView?.removeFromSuperview()
            quarterSelectView?.removeFromSuperview()
        }
    }
}

extension GameView: GameViewProtocol {
    
    func updateHomeTeam(_ team: Team) {
        homeTeamLabel.text = team.name
        homePlayerTableView.reloadData(with: team.players)
    }
    
    func updateAwayTeam(_ team: Team) {
        awayTeamLabel.text = team.name
        awayPlayerTableView.reloadData(with: team.players)
    }
    
    func updateGameClock(_ gameClock: Float, isRunning: Bool) {
        if gameClock >= 60.0 {
            let min = Int(gameClock) / 60
            let sec = Int(gameClock) % 60
            gameClockLabel.text = gameClockFormat.string(from: NSNumber(integerLiteral: min))! + ":" + gameClockFormat.string(from: NSNumber(integerLiteral: sec))!
        } else {
            gameClockLabel.text = shotClockFormat.string(from: NSNumber(value: gameClock))
        }
        gameClockLabel.textColor = isRunning ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
    func updateShotClock(_ shotClock: Float, isRunning: Bool) {
        shotClockLabel.text = shotClockFormat.string(from: NSNumber(value: shotClock))
        shotClockLabel.textColor = isRunning ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
    func updateQuarter(quarterNum: Int) {
        let quarterDescription = (quarterNum < 4) ? "\(quarterNum+1)쿼터" : "연장\(quarterNum-3)차"
        quarterLabel.text = quarterDescription
    }
    
    func highlightPlayerCell(of home: Bool, at indexPath: IndexPath, bool: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.highlightCell(at: indexPath, bool: bool)
    }
}

extension GameView: PlayerTableViewDelegate {
    
    func didDeletePlayerButtonTap() {
        
    }
    
    func didPlayerCellTap(of objectID: ObjectIdentifier ,at indexPath: IndexPath) {
        let home = (objectID == ObjectIdentifier(homePlayerTableView))
        presenter?.didPlayerCellTap(of: home, at: indexPath)
    }
}

extension GameView: QuarterSelectViewDelegate {
    
    func didQuarterSelect(quarterNum: Int?) {
        presenter?.didQuarterSelect(quarterNum: quarterNum)
    }
}
