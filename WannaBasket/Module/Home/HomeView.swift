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
        presenter?.didStartButtonTap()
    }
    
    @IBAction func newTeamButtonTapped() {
        presenter?.didNewTeamButtonTap()
    }
    
    @IBAction func newHomePlayerButtonTapped() {
        presenter?.didNewHomePlayerButtonTap()
    }
    
    @IBAction func newAwayPlayerButtonTapped() {
        presenter?.didNewAwayPlayerButtonTap()
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
    
    func updateTeams(_ teams: [Team]) {
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
    
    func didTeamFormCancelButtonTap() {
        showTeamFormView = false
    }
    
    func didTeamFormCompleteButtonTap(name: String?) {
        presenter?.didTeamFormCompleteButtonTap(name: name)
    }
}

extension HomeView: PlayerFormViewDelegate {
    
    func didPlayerFormCancelButtonTap() {
        showPlayerFormView = false
    }
    
    func didPlayerFormCompleteButtonTap(name: String?) {
        presenter?.didPlayerFormCompleteButtonTap(name: name)
    }
}

extension HomeView: TeamTableViewDelegate {
    
    func didDeleteTeamAction(at indexPath: IndexPath) {
        presenter?.didDeleteTeamAction(at: indexPath.section)
    }
    
    func didTeamCellDequeue() -> (home: Int?, away: Int?) {
        return presenter?.didTeamCellDequeue() ?? (nil, nil)
    }
    
    func didTeamCellTap(at indexPath: IndexPath, onLeft: Bool) {
        presenter?.didTeamCellTap(at: indexPath.section, onLeft: onLeft)
    }
}

extension HomeView: PlayerTableViewDelegate {

    func didDeletePlayerButtonTap() {

    }
    
    func didPlayerCellTap(of objectID: ObjectIdentifier ,at indexPath: IndexPath) {
        
    }
}
