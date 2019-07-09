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
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    
    @IBOutlet weak var quarterLabel: UILabel!
    @IBOutlet weak var gameClockLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    
    @IBOutlet weak var statSelectView: StatSelectView! {
        didSet { statSelectView.delegate = self }
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        updateTeamScoreLabel(score: 22, of: true)
    }
    
    @IBAction func quarterLabelTapped() {
        presenter?.didTapQuarterLabel()
    }
    
    @IBAction func gameClockLabelTapped() {
        presenter?.didTapGameClockLabel()
    }
    
    @IBAction func shotClockLabelTapped() {
        presenter?.didTapShotClockLabel()
    }
    
    @IBAction func clockControlButtonTapped(sender: UIButton) {
        guard let id = sender.accessibilityIdentifier,
              let control = ClockControl(rawValue: id) else { return }
        presenter?.didTapClockControlButton(control: control)
    }
    
    @IBAction func reset14ButtonTapped() {
        presenter?.didTapReset14Button()
    }
    
    @IBAction func reset24ButtonTapped() {
        presenter?.didTapReset24Button()
    }
    
    @IBAction func homeBenchButtonTapped() {
        presenter?.didTapBenchButton(of: true)
    }
    
    @IBAction func awayBenchButtonTapped() {
        presenter?.didTapBenchButton(of: false)
    }
    
    private var backgroundView: UIView?
    private var quarterSelectView: QuarterSelectView?
    private var isShowingQuaterSelectView: Bool = false
    func showQuarterSelectView(maxRegularQuarterNum: Int, overtimeQuarterCount: Int,currentQuarter: Quarter, bool: Bool) {
        if bool == isShowingQuaterSelectView { return }
        isShowingQuaterSelectView = bool
        if bool {
            let dismissGesture = UITapGestureRecognizerWithClosure {
                self.showQuarterSelectView(maxRegularQuarterNum: maxRegularQuarterNum,
                                           overtimeQuarterCount: overtimeQuarterCount,
                                           currentQuarter: currentQuarter,
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
                                     currentQuarter: currentQuarter)
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
    
    func updatePlayerTableView(players: [Player], of home: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.reloadData(with: players)
    }
    
    func updateTeamNameLabel(name: String, of home: Bool) {
        let teamNameLabel = home ? homeTeamNameLabel : awayTeamNameLabel
        teamNameLabel?.text = name
    }
    
    func updateTeamScoreLabel(score: Int, of home: Bool) {
        let teamScoreLabel = home ? homeTeamScoreLabel : awayTeamScoreLabel
        teamScoreLabel?.text = scoreFormat.string(from: NSNumber(value: score))!
    }
    
    func updateQuarterLabel(_ quarter: Quarter) {
        quarterLabel.text = "\(quarter)"
    }
    
    func updateGameClockLabel(_ gameClock: Float, isRunning: Bool) {
        gameClockLabel.text = "\(Time.Description.GameClock(gameClock))"
        gameClockLabel.textColor = isRunning ? Constants.Color.Black : Constants.Color.Silver
    }
    
    func updateShotClockLabel(_ shotClock: Float, isRunning: Bool) {
        shotClockLabel.text = "\(Time.Description.ShotClock(shotClock))"
        shotClockLabel.textColor = isRunning ? Constants.Color.Black : Constants.Color.Silver
    }
    
    func highlightPlayerCell(at index: Int, of home: Bool, bool: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.highlightCell(at: index, bool: bool)
    }
    
    func highlightStatCell(of stat: Stat.Score?, bool: Bool) {
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
    
    func didTapPlayerCell(at index: Int, of objectIdHash: Int) {
        let home = (objectIdHash == ObjectIdentifier(homePlayerTableView).hashValue)
        presenter?.didTapPlayerCell(at: index, of: home)
    }
}

extension GameView: QuarterSelectViewDelegate {
    
    func didSelectQuarter(quarterType: Quarter) {
        presenter?.didSelectQuarter(quarterType: quarterType)
    }
    
    func didSelectExit() {
        presenter?.didSelectExit()
    }
}

extension GameView: StatSelectViewDelegate {
    
    func didSelectStat(stat: Stat.Score) {
        presenter?.didSelectStat(stat: stat)
    }
    
    func didSelectUndo() {
        presenter?.didSelectUndo()
    }
}
