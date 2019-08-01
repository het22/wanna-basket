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
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel! {
        didSet { gameNameLabel.text = Constants.Text.Game }
    }
    
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    @IBOutlet weak var quarterLabel: UILabel!
    
    @IBOutlet weak var homeSubstituteButton: UIButton! {
        didSet { homeSubstituteButton.setTitle(Constants.Text.Substitute, for: .normal) }
    }
    @IBOutlet weak var awaySubstituteButton: UIButton! {
        didSet { awaySubstituteButton.setTitle(Constants.Text.Substitute, for: .normal) }
    }
    @IBOutlet weak var homePlayerTableView: PlayerTableView! {
        didSet { homePlayerTableView._delegate = self }
    }
    @IBOutlet weak var awayPlayerTableView: PlayerTableView! {
        didSet { awayPlayerTableView._delegate = self }
    }
    
    @IBOutlet weak var gameClockLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    @IBOutlet weak var reset14Button: UIButton! {
        didSet { reset14Button.setTitle("14S".localized, for: .normal) }
    }
    @IBOutlet weak var reset24Button: UIButton! {
        didSet { reset24Button.setTitle("24S".localized, for: .normal) }
    }
    @IBOutlet weak var statSelectView: StatSelectView! {
        didSet { statSelectView.delegate = self }
    }
    
    deinit { print( "Deinit: ", self) }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
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
    
    @IBAction func substituteButtonTapped(sender: UIButton) {
        let home = (sender == homeSubstituteButton)
        presenter?.didTapSubstituteButton(of: home)
    }
    
    private var backgroundView: UIView?
    private var quarterSelectView: QuarterSelectView?
    func showQuarterSelectView(maxRegularQuarterNum: Int, overtimeQuarterCount: Int, currentQuarter: Quarter, bool: Bool) {
        if bool == (quarterSelectView != nil) { return }
        if bool {
            let dismissGesture = UITapGestureRecognizerWithClosure { [weak self] in
                self?.showQuarterSelectView(maxRegularQuarterNum: maxRegularQuarterNum,
                                           overtimeQuarterCount: overtimeQuarterCount,
                                           currentQuarter: currentQuarter,
                                           bool: false)
            }
            backgroundView = UIView(frame: view.bounds)
            backgroundView!.backgroundColor = Constants.Color.Background
            backgroundView!.addGestureRecognizer(dismissGesture)
            self.view.addSubview(backgroundView!)
            
            quarterSelectView = QuarterSelectView(frame: CGRect.zero)
            quarterSelectView?.delegate = self
            quarterSelectView?.translatesAutoresizingMaskIntoConstraints = false
            quarterSelectView?.setup(maxRegularQuarterNum: maxRegularQuarterNum,
                                     overtimeQuarterCount: overtimeQuarterCount,
                                     currentQuarter: currentQuarter)
            self.view.addSubview(quarterSelectView!)
            
            NSLayoutConstraint.activate([
                quarterSelectView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                quarterSelectView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
                quarterSelectView!.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.65),
                quarterSelectView!.heightAnchor.constraint(equalTo: quarterSelectView!.widthAnchor, multiplier: 0.4)])
        } else {
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            quarterSelectView?.removeFromSuperview()
            quarterSelectView = nil
        }
    }
}

extension GameView: GameViewProtocol {
    
    func updatePlayerTableView(players: [PlayerOfTeam], of home: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.playerTuples = players.compactMap{ return ($0, []) }
    }
    
    func updateTeamNameLabel(name: String, of home: Bool) {
        let teamNameLabel = home ? homeTeamNameLabel : awayTeamNameLabel
        teamNameLabel?.text = name
    }
    
    func updateTeamScoreLabel(score: Int, of home: Bool) {
        let teamScoreLabel = home ? homeTeamScoreLabel : awayTeamScoreLabel
        teamScoreLabel?.text = scoreFormat.string(from: NSNumber(value: score))!
    }
    
    func updateSubstituteButton(bool: Bool, of home: Bool) {
        let button = home ? homeSubstituteButton : awaySubstituteButton
        button?.setTitle(bool ? Constants.Text.SubstituteComplete : Constants.Text.Substitute, for: .normal)
    }
    
    func updateQuarterLabel(_ quarter: Quarter) {
        quarterLabel.text = "\(quarter)"
    }
    
    func updateGameClockLabel(_ gameClock: Float, isRunning: Bool) {
        gameClockLabel.text = "\(Constants.Format.GameClock(gameClock))"
        gameClockLabel.textColor = isRunning ? Constants.Color.Black : Constants.Color.Silver
    }
    
    func updateShotClockLabel(_ shotClock: Float, isRunning: Bool) {
        shotClockLabel.text = "\(Constants.Format.ShotClock(shotClock))"
        shotClockLabel.textColor = isRunning ? Constants.Color.Black : Constants.Color.Silver
    }
    
    func highlightPlayerCell(at index: Int, of home: Bool, bool: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.highlightCell(at: index, bool: bool)
    }
    
    func highlightStatCell(of stat: Stat?, bool: Bool) {
        statSelectView.highlightCell(of: stat, bool: bool)
    }
    
    func blinkScoreLabel(of home: Bool, completion: ((Bool)->Void)?) {
        let scoreLabel = home ? homeTeamScoreLabel : awayTeamScoreLabel
        scoreLabel?.animateBlink(completion: completion)
    }
    
    func blinkPlayerCell(at index: Int, of home: Bool, completion: ((Bool)->Void)?) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.blinkCell(at: index, completion: completion)
    }
    
    func blinkStatCell(of stat: Stat?, completion: ((Bool)->Void)?) {
        statSelectView.blinkStatCell(of: stat, completion: completion)
    }
    
    func enableScrollingPlayerTableView(of home: Bool, bool: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.isCustomScrollEnabled = bool
    }
}

extension GameView: PlayerTableViewDelegate {
    
    func didTapPlayerCell(at index: Int, of home: Bool) {
        presenter?.didTapPlayerCell(at: index, of: home)
    }
    
    func didDequeuePlayerCell(of home: Bool) -> [Int] {
        return presenter?.didDequeuePlayerCell(of: home) ?? []
    }
}

extension GameView: QuarterSelectViewDelegate {
    
    func didSelectQuarter(quarterType: Quarter) {
        presenter?.didSelectQuarter(quarterType: quarterType)
    }
    
    func didSelectRecord() {
        presenter?.didSelectRecord()
    }
    
    func didSelectExit() {
        presenter?.didSelectExit()
    }
}

extension GameView: StatSelectViewDelegate {
    
    func didSelectStat(stat: Stat) {
        presenter?.didSelectStat(stat: stat)
    }
    
    func didSelectUndo() {
        presenter?.didSelectUndo()
    }
}
