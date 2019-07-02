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
    
    @IBOutlet weak var teamTableView: TeamTableView!
    @IBOutlet weak var homePlayerTableView: PlayerTableView!
    @IBOutlet weak var awayPlayerTableView: PlayerTableView!
    
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!

	override func viewDidLoad() {
        super.viewDidLoad()
        
        teamTableView._delegate = self
        homePlayerTableView._delegate = self
        awayPlayerTableView._delegate = self
        
        presenter?.viewDidLoad()
    }
    
    @IBAction func startButtonTapped() {
        presenter?.startButtonTapped()
    }
    
    private var backgroundView: UIView?
    private var addTeamView: AddTeamView?
    private var _showAddTeamView: Bool = false
    var showAddTeamView: Bool {
        get { return _showAddTeamView }
        set(newVal) {
            if newVal == showAddTeamView { return }
            if newVal {
                let dismissGesture = UITapGestureRecognizerWithClosure { self.showAddTeamView = false }
                dismissGesture.numberOfTapsRequired = 1
                
                backgroundView = UIView(frame: view.bounds)
                backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
                backgroundView!.addGestureRecognizer(dismissGesture)
                view.addSubview(backgroundView!)
                
                addTeamView = AddTeamView(frame: CGRect.zero)
                addTeamView?.delegate = self
                view.addSubview(addTeamView!)
                
                addTeamView!.translatesAutoresizingMaskIntoConstraints = false
                addTeamView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                addTeamView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
                addTeamView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
                addTeamView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
            } else {
                backgroundView?.removeFromSuperview()
                addTeamView?.removeFromSuperview()
            }
            _showAddTeamView = newVal
        }
    }
    
    private var addPlayerView: AddPlayerView?
    private var _showAddPlayerView: Bool = false
    var showAddPlayerView: Bool {
        get { return _showAddPlayerView }
        set(newVal) {
            if newVal == showAddPlayerView { return }
            if newVal {
                let dismissGesture = UITapGestureRecognizerWithClosure { self.showAddPlayerView = false }
                dismissGesture.numberOfTapsRequired = 1
                
                backgroundView = UIView(frame: view.bounds)
                backgroundView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
                backgroundView!.addGestureRecognizer(dismissGesture)
                view.addSubview(backgroundView!)
                
                addPlayerView = AddPlayerView(frame: CGRect.zero)
                addPlayerView?.delegate = self
                view.addSubview(addPlayerView!)
                
                addPlayerView!.translatesAutoresizingMaskIntoConstraints = false
                addPlayerView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                addPlayerView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
                addPlayerView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
                addPlayerView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
            } else {
                backgroundView?.removeFromSuperview()
                addPlayerView?.removeFromSuperview()
            }
            _showAddPlayerView = newVal
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
        homeTeamLabel.text = team?.name ?? "홈팀"
        homePlayerTableView.reloadData(with: team?.players ?? nil)
    }
    
    func updateAwayTeam(_ team: Team?) {
        awayTeamLabel.text = team?.name ?? "원정팀"
        awayPlayerTableView.reloadData(with: team?.players ?? nil)
    }
}

extension HomeView: AddTeamViewDelegate, AddPlayerViewDelegate {
    
    func didCancelButtonTap() {
        showAddTeamView = false
        showAddPlayerView = false
    }
    
    func didAddTeamCompleteButtonTap(name: String?) {
        presenter?.didAddTeamCompleteButtonTap(name: name)
    }
    
    func didAddPlayerCompleteButtonTap(name: String?) {
        presenter?.didAddPlayerCompleteButtonTap(name: name)
    }
}

extension HomeView: TeamTableViewDelegate {
    
    func didAddTeamButtonTap() {
        presenter?.didAddTeamButtonTap()
    }
    
    func didDeleteTeamButtonTap() {
        
    }
    
    func didTeamCellTap(at indexPath: IndexPath, onLeft: Bool) {
        presenter?.didTeamCellTap(at: indexPath.section - 1, onLeft: onLeft)
    }
}

extension HomeView: PlayerTableViewDelegate {

    func didAddPlayerButtonTap(id: ObjectIdentifier) {
        let home = (id == ObjectIdentifier(homePlayerTableView))
        presenter?.didAddPlayerButtonTap(home: home)
    }

    func didDeletePlayerButtonTap() {

    }
    
    func didPlayerCellTap(at indexPath: IndexPath) {
        
    }
}
