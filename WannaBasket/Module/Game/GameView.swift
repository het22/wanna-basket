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
    
    @IBOutlet weak var homePlayerTableView: PlayerTableView! {
        didSet { homePlayerTableView._delegate = self }
    }
    @IBOutlet weak var awayPlayerTableView: PlayerTableView! {
        didSet { awayPlayerTableView._delegate = self }
    }
    
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    @IBOutlet weak var quarterLabel: UILabel!
    
    @IBOutlet weak var gameClockLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    
    @IBOutlet weak var statSelectView: StatSelectView! {
        didSet { statSelectView.delegate = self }
    }
    
    
	override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func clockControlButtonTapped(sender: UIButton) {
        guard let id = sender.accessibilityIdentifier,
              let control = ClockControl(rawValue: id) else { return }
        presenter?.didClockControlButtonTap(control: control)
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
            quarterSelectView!.delegate = self
            quarterSelectView!.setup(maxRegularQuarterNum: maxRegularQuarterNum,
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
            backgroundView = nil
            quarterSelectView?.removeFromSuperview()
            quarterSelectView = nil
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
        gameClockLabel.textColor = isRunning ? Constants.Color.Black : Constants.Color.Silver
    }
    
    func updateShotClock(_ shotClock: Float, isRunning: Bool) {
        shotClockLabel.text = shotClockFormat.string(from: NSNumber(value: shotClock))
        shotClockLabel.textColor = isRunning ? Constants.Color.Black : Constants.Color.Silver
    }
    
    func updateQuarter(quarterNum: Int) {
        let quarterDescription = (quarterNum < 4) ? "\(quarterNum+1)쿼터" : "연장\(quarterNum-3)차"
        quarterLabel.text = quarterDescription
    }
    
    func highlightPlayerCell(at index: Int, of home: Bool, bool: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.highlightCell(at: index, bool: bool)
    }
    
    func highlightStatsCell(of stat: Stat.Score?, bool: Bool) {
        statSelectView.highlightCell(of: stat, bool: bool)
    }
    
    func blinkPlayerCell(at index: Int, of home: Bool, completion: @escaping (Bool)->Void) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.blinkCell(at: index, completion: completion)
    }
    
    func blinkStatCell(of stat: Stat.Score?, completion: @escaping (Bool)->Void) {
        statSelectView.blinkStatCell(of: stat, completion: completion)
    }
}

extension GameView: PlayerTableViewDelegate {
    
    func didPlayerCellTap(at index: Int, of objectIdHash: Int) {
        let home = (objectIdHash == ObjectIdentifier(homePlayerTableView).hashValue)
        presenter?.didPlayerCellTap(at: index, of: home)
    }
}

extension GameView: QuarterSelectViewDelegate {
    
    func didQuarterSelect(quarterNum: Int?) {
        presenter?.didQuarterSelect(quarterNum: quarterNum)
    }
}

extension GameView: StatSelectViewDelegate {
    
    func didStatSelect(stat: Stat.Score?) {
        presenter?.didStatSelect(stat: stat)
    }
}
