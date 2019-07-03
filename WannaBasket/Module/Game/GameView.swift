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
    
    @IBOutlet weak var gameClockLabel: UILabel!
    @IBOutlet weak var shotClockLabel: UILabel!
    
    @IBOutlet weak var quarterButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pt1Button: UIButton!
    @IBOutlet weak var pt2Button: UIButton!
    @IBOutlet weak var pt3Button: UIButton!
    
    private var backgroundView: UIView?
    private var quarterSelectView: QuarterSelectView?
    
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        let buttons = [cancelButton, pt1Button, pt2Button, pt3Button]
        buttons.forEach {
            $0?.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            $0?.layer.borderWidth = 1
        }
    }

    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func quarterButtonTapped() {
        presenter?.didQuarterButtonTap()
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
    
    func showHomeTeamBench() {
        
    }
    
    func showAwayTeamBench() {
        
    }
    
    func highlightPlayerCell(ofHome: Bool, indexPath: IndexPath, bool: Bool) {
        let playerTableView = ofHome ? homePlayerTableView : awayPlayerTableView
        playerTableView?.highlightCell(at: indexPath, bool: bool)
    }
    
    func highlightStatCell(bool: Bool) {
        
    }
    
    func updateGameClock(gameTime: Float, go: Bool) {
        gameClockLabel.text = "10:00"
        gameClockLabel.textColor = go ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
    func updateShotClock(shotTime: Float, go: Bool) {
        shotClockLabel.text = "24.0"
        shotClockLabel.textColor = go ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
    func showQuarterSelectView(quarter: Quarter, bool: Bool) {
        let isShown = (quarterSelectView != nil)
        if isShown == bool { return }
        if bool {
            let dismissGesture = UITapGestureRecognizerWithClosure { self.showQuarterSelectView(quarter: quarter, bool: false) }
            dismissGesture.numberOfTapsRequired = 1
            
            backgroundView = UIView(frame: view.bounds)
            backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
            backgroundView!.addGestureRecognizer(dismissGesture)
            view.addSubview(backgroundView!)
            
            quarterSelectView = QuarterSelectView(frame: CGRect.zero)
            quarterSelectView?.setup(quarter: quarter)
            quarterSelectView?.delegate = self
            view.addSubview(quarterSelectView!)
            
            quarterSelectView!.translatesAutoresizingMaskIntoConstraints = false
            quarterSelectView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            quarterSelectView!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            quarterSelectView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
            quarterSelectView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        } else {
            backgroundView?.removeFromSuperview()
            quarterSelectView?.removeFromSuperview()
            quarterSelectView = nil
        }
    }
    
    func updateQuarter(quarter: Quarter) {
        UIView.performWithoutAnimation {
            quarterButton.setTitle(quarter.description, for: .normal)
            quarterButton.layoutIfNeeded()
        }
    }
}

extension GameView: PlayerTableViewDelegate {
    
    func didAddPlayerButtonTap(id: ObjectIdentifier) {
        
    }
    
    func didDeletePlayerButtonTap() {
        
    }
    
    func didPlayerCellTap(at indexPath: IndexPath) {
        
    }
}

extension GameView: QuarterSelectViewDelegate {
    
    func didQuarterSelect(quarter: Quarter) {
        presenter?.didQuarterSelect(quarter: quarter)
    }
}
