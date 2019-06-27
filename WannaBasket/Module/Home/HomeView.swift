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
    private var _hideAddTeamView: Bool = true
    var hideAddTeamView: Bool {
        get { return _hideAddTeamView }
        set(newVal) {
            if newVal == hideAddTeamView { return }
            if newVal {
                backgroundView?.removeFromSuperview()
                addTeamView?.removeFromSuperview()
            } else {
                let dismissGesture = UITapGestureRecognizerWithClosure { self.hideAddTeamView = true }
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
                addTeamView!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                addTeamView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
                addTeamView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
            }
            _hideAddTeamView = newVal
        }
    }
    
    @objc func execute() {
        
    }
    
    private var addPlayerView: AddPlayerView?
    private var _hideAddPlayerView: Bool = true
    var hideAddPlayerView: Bool {
        get { return _hideAddPlayerView }
        set(newVal) {
            if newVal == hideAddPlayerView { return }
            if newVal {
                backgroundView?.removeFromSuperview()
                addPlayerView?.removeFromSuperview()
            } else {
                let dismissGesture = UITapGestureRecognizerWithClosure { self.hideAddPlayerView = true }
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
                addPlayerView!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                addPlayerView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
                addPlayerView!.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
            }
            _hideAddPlayerView = newVal
        }
    }
    
}

extension HomeView: HomeViewProtocol {
    
    func showTeams(_ teams: [Team]) {
        teamTableView.reloadData(with: teams)
    }
    
    func highlightTeam(at index: Int, bool: Bool) {
        teamTableView.highlightCell(at: index, bool: bool)
    }
    
    func showHomeTeam(_ team: Team?) {
        homeTeamLabel.text = team?.name ?? "홈팀"
        homePlayerTableView.reloadData(with: team?.players ?? nil)
    }
    
    func showAwayTeam(_ team: Team?) {
        awayTeamLabel.text = team?.name ?? "원정팀"
        awayPlayerTableView.reloadData(with: team?.players ?? nil)
    }
}

extension HomeView: AddTeamViewDelegate, AddPlayerViewDelegate {
    
    func didCancelButtonTap() {
        hideAddTeamView = true
        hideAddPlayerView = true
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
    
    func didTeamCellTap(at index: Int) {
        presenter?.didTeamCellTap(at: index)
    }
}

extension HomeView: PlayerTableViewDelegate {

    func didAddPlayerButtonTap(id: ObjectIdentifier) {
        let home = (id == ObjectIdentifier(homePlayerTableView))
        presenter?.didAddPlayerButtonTap(home: home)
    }

    func didDeletePlayerButtonTap() {

    }
}
