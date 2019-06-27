//
//  HomePresenter.swift
//  WannaBasket
//
//  Created Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class HomePresenter: HomePresenterProtocol {

    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var wireframe: HomeWireframeProtocol?
    
    var teams: [Team] = []
    var homeTeamIndex: Int?
    var awayTeamIndex: Int?
    var addHomePlayer: Bool = true
    
    func viewDidLoad() {
        let temp1 = Team(name: "쿠스켓")
        temp1.players.append(contentsOf: [Player(name: "유현석"),Player(name: "정상빈"), Player(name: "이재원"), Player(name: "송해찬"), Player(name: "박진모")])
        let temp2 = Team(name: "마하맨")
        temp2.players.append(contentsOf: [Player(name: "송호철"),Player(name: "백승희"), Player(name: "박건"), Player(name: "송해찬"), Player(name: "한수흠")])
        teams.append(contentsOf: [temp1, temp2])
        view?.showTeams(teams)
        view?.showHomeTeam(nil)
        view?.showAwayTeam(nil)
    }
    
    func startButtonTapped() {
        guard let view = view else { return }
        wireframe?.presentModule(source: view, module: Module.Game)
    }
    
    func didAddTeamButtonTap() {
        view?.hideAddTeamView = false
    }
    
    func didTeamCellTap(at index: Int) {
        if index == homeTeamIndex {
            homeTeamIndex = nil
            view?.highlightTeam(at: index, bool: false)
            view?.showHomeTeam(nil)
        } else if index == awayTeamIndex {
            awayTeamIndex = nil
            view?.highlightTeam(at: index, bool: false)
            view?.showAwayTeam(nil)
        } else {
            if homeTeamIndex == nil {
                homeTeamIndex = index
                view?.highlightTeam(at: index, bool: true)
                view?.showHomeTeam(teams[index])
            } else if awayTeamIndex == nil {
                awayTeamIndex = index
                view?.highlightTeam(at: index, bool: true)
                view?.showAwayTeam(teams[index])
            }
        }
    }
    
    func didAddPlayerButtonTap(home: Bool) {
        addHomePlayer = home
        view?.hideAddPlayerView = false
    }
    
    func didAddTeamCompleteButtonTap(name: String?) {
        if let name = name, name != "" {
            let team = Team(name: name)
            teams.append(team)
            view?.showTeams(teams)
        }
        view?.hideAddTeamView = true
    }
    
    func didAddPlayerCompleteButtonTap(name: String?) {
        if let name = name, name != "", let index = addHomePlayer ? homeTeamIndex : awayTeamIndex  {
            let player = Player(name: name)
            teams[index].players.append(player)
            if addHomePlayer { view?.showHomeTeam(teams[index]) }
            else { view?.showAwayTeam(teams[index]) }
        }
        view?.hideAddPlayerView = true
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    
}
