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
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    @IBOutlet weak var gameStartButton: UIButton!
    @IBOutlet weak var homePlayerAddButton: UIButton!
    @IBOutlet weak var awayPlayerAddButton: UIButton!
    
    private var backgroundView: UIView?
    private var teamFormView: TeamFormView?
    private var playerFormView: PlayerFormView?
    
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
}

extension HomeView: HomeViewProtocol {
    
    func updateTeamTableView(teams: [Team]) {
        teamTableView.teamList = teams
    }
    
    func updatePlayerTableView(players: [Player]?, of home: Bool) {
        let playerTableView = home ? homePlayerTableView : awayPlayerTableView
        playerTableView?.playerTuples = players?.compactMap{ return ($0, []) }
    }
    
    func updateTeamNameLabel(name: String?, of home: Bool) {
        let teamNameLabel = home ? homeTeamNameLabel : awayTeamNameLabel
        let defaultName = home ? Constants.Text.HomeDefault : Constants.Text.AwayDefault
        teamNameLabel?.text = name ?? defaultName
        teamNameLabel?.alpha = (name==nil) ? 0.5 : 1.0
    }
    
    func highlightTeam(at index: Int, onLeft: Bool, bool: Bool) {
        teamTableView.highlightCell(at: index, onLeft: onLeft, bool: bool)
    }
    
    func enableGameStartButton(bool: Bool) {
        gameStartButton.isEnabled = bool
        gameStartButton.alpha = bool ? 1.0 : 0.5
    }
    
    func enablePlayerAddButton(bool: Bool, of home: Bool) {
        let playerAddButton = home ? homePlayerAddButton : awayPlayerAddButton
        playerAddButton?.isEnabled = bool
        playerAddButton?.alpha = bool ? 1.0 : 0.5
    }
    
    func showTeamFormView(isEditMode: Bool, name: String?, index: Int?, bool: Bool) {
        if bool == (teamFormView != nil) { return }
        if bool {
            let dismissGesture = UITapGestureRecognizerWithClosure { [weak self] in
                self?.showTeamFormView(isEditMode: isEditMode, name: name, index: index, bool: false)
            }
            backgroundView = UIView(frame: view.bounds)
            backgroundView!.backgroundColor = Constants.Color.Background
            backgroundView!.addGestureRecognizer(dismissGesture)
            self.view.addSubview(backgroundView!)
            
            teamFormView = TeamFormView(frame: CGRect.zero)
            teamFormView?.delegate = self
            teamFormView?.translatesAutoresizingMaskIntoConstraints = false
            teamFormView?.setup(isEditMode: isEditMode, name: name, index: index)
            view.addSubview(teamFormView!)
            
            let centerYConstraint = teamFormView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0)
            teamFormView?.setupKeyboard(with: centerYConstraint, spacing: 10.0)
            NSLayoutConstraint.activate([
                teamFormView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                centerYConstraint,
                teamFormView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                teamFormView!.heightAnchor.constraint(equalTo: teamFormView!.widthAnchor, multiplier: 0.3)])
        } else {
            backgroundView?.removeFromSuperview()
            teamFormView?.removeFromSuperview()
            backgroundView = nil
            teamFormView = nil
        }
    }
    
    func showPlayerFormView(isEditMode: Bool, player: Player?, index: Int?, bool: Bool) {
        if bool == (playerFormView != nil) { return }
        if bool {
            let dismissGesture = UITapGestureRecognizerWithClosure { [weak self] in
                self?.showPlayerFormView(isEditMode: isEditMode, player: player, index: index, bool: false)
            }
            backgroundView = UIView(frame: view.bounds)
            backgroundView!.backgroundColor = Constants.Color.Background
            backgroundView!.addGestureRecognizer(dismissGesture)
            self.view.addSubview(backgroundView!)
            
            playerFormView = PlayerFormView(frame: CGRect.zero)
            playerFormView?.delegate = self
            playerFormView?.translatesAutoresizingMaskIntoConstraints = false
            playerFormView?.setup(isEditMode: isEditMode, player: player, index: index)
            view.addSubview(playerFormView!)
            
            let centerYConstraint = playerFormView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0)
            playerFormView?.setupKeyboard(with: centerYConstraint, spacing: 10.0)
            NSLayoutConstraint.activate([
                playerFormView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                centerYConstraint,
                playerFormView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                playerFormView!.heightAnchor.constraint(equalTo: playerFormView!.widthAnchor, multiplier: 0.3)])
        } else {
            backgroundView?.removeFromSuperview()
            playerFormView?.removeFromSuperview()
            backgroundView = nil
            playerFormView = nil
        }
    }
}

extension HomeView: TeamFormViewDelegate {
    
    func didTapTeamFormCancelButton() {
        presenter?.didTapTeamFormCancelButton()
    }
    
    func didTapTeamFormDeleteButton(index: Int) {
        presenter?.didTapTeamFormDeleteButton(index: index)
    }
    
    func didTapTeamFormCompleteButton(name: String) {
        presenter?.didTapTeamFormCompleteButton(name: name)
    }
    
    func didTapTeamFormEditButton(name: String, index: Int) {
        presenter?.didTapTeamFormEditButton(name: name, index: index)
    }
}

extension HomeView: PlayerFormViewDelegate {
    
    func didTapPlayerFormCancelButton() {
        presenter?.didTapPlayerFormCancelButton()
    }
    
    func didTapPlayerFormDeleteButton(index: Int) {
        presenter?.didTapPlayerFormDeleteButton(index: index)
    }
    
    func didTapPlayerFormCompleteButton(player: Player) {
        presenter?.didTapPlayerFormCompleteButton(player: player)
    }
    
    func didTapPlayerFormEditButton(player: Player, index: Int) {
        presenter?.didTapPlayerFormEditButton(player: player, index: index)
    }
    
    func didTapPlayerNumberButton() -> [Bool] {
        return presenter?.didTapPlayerNumberButton() ?? []
    }
}

extension HomeView: TeamTableViewDelegate {
    
    func didDeleteTeamAction(at index: Int) {
        presenter?.didDeleteTeamAction(at: index)
    }
    
    func didDequeueTeamCell() -> (home: Int?, away: Int?) {
        return presenter?.didDequeueTeamCell() ?? (nil, nil)
    }
    
    func didTapTeamCell(at index: Int, tapSection: TeamCell.Section) {
        presenter?.didTapTeamCell(at: index, tapSection: tapSection)
    }
}

extension HomeView: PlayerTableViewDelegate {
    
    func didDeletePlayerAction(at index: Int, of home: Bool) {
        presenter?.didDeletePlayerAction(at: index, of: home)
    }
    
    func didDequeuePlayerCell(of home: Bool) -> [Int] {
        return []
    }
    
    func didTapPlayerCell(at index: Int, of home: Bool) {
        presenter?.didTapPlayerCell(at: index, of: home)
    }
}
