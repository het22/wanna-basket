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
    
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    @IBOutlet weak var quarterLabel: UILabel!
    
    @IBOutlet weak var gameClockLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    
    private var backgroundView: UIView?
    
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
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
    
    func updateGameClock(gameClock: Float, isRunning: Bool) {
        if gameClock >= 60.0 {
            let min = Int(gameClock) / 60
            let sec = Int(gameClock) % 60
            gameClockLabel.text = gameClockFormat.string(from: NSNumber(integerLiteral: min))! + ":" + gameClockFormat.string(from: NSNumber(integerLiteral: sec))!
        } else {
            gameClockLabel.text = shotClockFormat.string(from: NSNumber(value: gameClock))
        }
        gameClockLabel.textColor = isRunning ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
    func updateShotClock(shotClock: Float, isRunning: Bool) {
        shotClockLabel.text = shotClockFormat.string(from: NSNumber(value: shotClock))
        shotClockLabel.textColor = isRunning ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
    func updateQuarter(quarterNum: Int) {
        let quarterDescription = (quarterNum < 4) ? "\(quarterNum+1)쿼터" : "연장\(quarterNum-3)차"
        quarterLabel.text = quarterDescription
    }
}

extension GameView: PlayerTableViewDelegate {
    
    func didDeletePlayerButtonTap() {
        
    }
    
    func didPlayerCellTap(at indexPath: IndexPath) {
        
    }
}
