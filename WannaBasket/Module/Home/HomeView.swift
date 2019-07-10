//
//  HomeView.swift
//  WannaBasket
//
//  Created Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class HomeView: UIViewController {

	var presenter: HomePresenterProtocol?
    
    @IBOutlet weak var teamTableView: TeamTableView! {
        didSet { teamTableView._delegate = self }
    }
    @IBOutlet weak var homePlayerTableView: PlayerTableView! {
        didSet { homePlayerTableView._delegate = self }
    }
    @IBOutlet weak var awayPlayerTableView: PlayerTableView! {
        didSet { awayPlayerTableView._delegate = self }
    }
    
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    
    @IBOutlet weak var gameStartButton: UIButton!
    @IBOutlet weak var homePlayerAddButton: UIButton!
    @IBOutlet weak var awayPlayerAddButton: UIButton!

	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    @IBAction func startButtonTapped() {
        presenter?.didTapStartButton()
    }
    
    @IBAction func newTeamButtonTapped() {
        presenter?.didTapNewTeamButton()
    }
    
    @IBAction func newPlayerButtonTapped(sender: UIButton) {
        let home = (sender == homePlayerAddButton)
        presenter?.didTapNewPlayerButton(of: home)
    }
    
    private var backgroundView: UIView?
    private var teamFormView: TeamFormView?
    var showTeamFormView: Bool = false {
        willSet(newVal) {
            if newVal == showTeamFormView { return }
            if newVal {
                let dismissGesture = UITapGestureRecognizerWithClosure { self.showTeamFormView = false }
                dismissGesture.numberOfTapsRequired = 1
                
                backgroundView = UIView(frame: view.bounds)
                backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
                backgroundView!.addGestureRecognizer(dismissGesture)
                view.addSubview(backgroundView!)
                
                teamFormView = TeamFormView(frame: CGRect.zero)
                teamFormView?.delegate = self
                view.addSubview(teamFormView!)
                
                teamFormView!.translatesAutoresizingMaskIntoConstraints = false
                teamFormView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                teamFormView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
                teamFormView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
                teamFormView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
            } else {
                backgroundView?.removeFromSuperview()
                teamFormView?.removeFromSuperview()
            }
        }
    }
    
    private var playerFormView: PlayerFormView?
    var showPlayerFormView: Bool = false {
        willSet(newVal) {
            if newVal == showPlayerFormView { return }
            if newVal {
                let dismissGesture = UITapGestureRecognizerWithClosure { self.showPlayerFormView = false }
                dismissGesture.numberOfTapsRequired = 1
                
                backgroundView = UIView(frame: view.bounds)
                backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
                backgroundView!.addGestureRecognizer(dismissGesture)
                view.addSubview(backgroundView!)
                
                playerFormView = PlayerFormView(frame: CGRect.zero)
                playerFormView?.delegate = self
                view.addSubview(playerFormView!)
                
                playerFormView!.translatesAutoresizingMaskIntoConstraints = false
                playerFormView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                playerFormView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
                playerFormView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
                playerFormView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
            } else {
                backgroundView?.removeFromSuperview()
                playerFormView?.removeFromSuperview()
            }
        }
    }
    
}

extension HomeView: HomeViewProtocol {
    
    func updateTeamTableView(with teams: [Team]) {
        teamTableView.reloadData(with: teams)
    }
    
    func highlightTeam(at index: Int, onLeft: Bool, bool: Bool) {
        teamTableView.highlightCell(at: index, onLeft: onLeft, bool: bool)
    }
    
    func updateHomeTeam(_ team: Team?) {
        homeTeamLabel.text = team?.name ?? Constants.Text.HomeDefault
        homePlayerTableView.reloadData(with: team?.players ?? nil)
    }
    
    func updateAwayTeam(_ team: Team?) {
        awayTeamLabel.text = team?.name ?? Constants.Text.AwayDefault
        awayPlayerTableView.reloadData(with: team?.players ?? nil)
    }
    
    func enableGameStartButton(bool: Bool) {
        gameStartButton.isEnabled = bool
        gameStartButton.alpha = bool ? 1.0 : 0.5
    }
    
    func enableHomePlayerAddButton(bool: Bool) {
        homePlayerAddButton.isEnabled = bool
        homePlayerAddButton.alpha = bool ? 1.0 : 0.5
    }
    
    func enableAwayPlayerAddButton(bool: Bool) {
        awayPlayerAddButton.isEnabled = bool
        awayPlayerAddButton.alpha = bool ? 1.0 : 0.5
    }
}

extension HomeView: TeamFormViewDelegate {
    
    func didTapTeamFormCancelButton() {
        showTeamFormView = false
    }
    
    func didTapTeamFormCompleteButton(name: String?) {
        presenter?.didTapTeamFormCompleteButton(name: name)
    }
}

extension HomeView: PlayerFormViewDelegate {
    
    func didTapPlayerFormCancelButton() {
        showPlayerFormView = false
    }
    
    func didTapPlayerFormCompleteButton(name: String?, number: Int?) {
        presenter?.didTapPlayerFormCompleteButton(name: name, number: number)
    }
}

extension HomeView: TeamTableViewDelegate {
    
    func didDeleteTeamAction(at index: Int) {
        presenter?.didDeleteTeamAction(at: index)
    }
    
    func didDequeueTeamCell() -> (home: Int?, away: Int?) {
        return presenter?.didDequeueTeamCell() ?? (nil, nil)
    }
    
    func didTapTeamCell(at index: Int, onLeft: Bool) {
        presenter?.didTapTeamCell(at: index, onLeft: onLeft)
    }
}

extension HomeView: PlayerTableViewDelegate {
    
    func didDeletePlayerAction(at index: Int, of home: Bool) {
        presenter?.didDeletePlayerAction(at: index, of: home)
    }
    
    func didTapPlayerCell(at index: Int, of home: Bool) {
        
    }
}
