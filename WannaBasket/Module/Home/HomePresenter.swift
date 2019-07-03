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
        // Temp Data
        let temp1 = Team(name: "쿠스켓")
        temp1.players.append(contentsOf: [Player(name: "유현석"),Player(name: "정상빈"), Player(name: "이재원"), Player(name: "송해찬"), Player(name: "박진모")])
        let temp2 = Team(name: "마하맨")
        temp2.players.append(contentsOf: [Player(name: "송호철"),Player(name: "백승희"), Player(name: "박건"), Player(name: "송해찬"), Player(name: "한수흠")])
        teams.append(contentsOf: [temp1, temp2])
        
        view?.updateTeams(teams)
        view?.updateHomeTeam(nil)
        view?.updateAwayTeam(nil)
    }
    
    func didStartButtonTap() {
        guard let hti = homeTeamIndex, let ati = awayTeamIndex else { return }
        wireframe?.presentModule(source: view!,
                                 module: Module.Game(game: Game(homeTeam: teams[hti],
                                                                awayTeam: teams[ati])))
    }
    
    func didNewTeamButtonTap() {
        view?.showAddTeamView = true
    }
    
    func didNewHomePlayerButtonTap() {
        addHomePlayer = true
        view?.showAddPlayerView = true
    }
    
    func didNewAwayPlayerButtonTap() {
        addHomePlayer = false
        view?.showAddPlayerView = true
    }
    
    func didAddTeamCompleteButtonTap(name: String?) {
        if let name = name, name != "" {
            let team = Team(name: name)
            teams.append(team)
            view?.updateTeams(teams)
        }
        view?.showAddTeamView = false
    }
    
    func didAddPlayerCompleteButtonTap(name: String?) {
        if let name = name, name != "", let index = addHomePlayer ? homeTeamIndex : awayTeamIndex  {
            let player = Player(name: name)
            teams[index].players.append(player)
            if homeTeamIndex == awayTeamIndex {
                view?.updateHomeTeam(teams[index])
                view?.updateAwayTeam(teams[index])
            }
            if addHomePlayer { view?.updateHomeTeam(teams[index]) }
            else { view?.updateAwayTeam(teams[index]) }
        }
        view?.showAddPlayerView = false
    }
    
    func didTeamCellTap(at index: Int, onLeft: Bool) {
        if onLeft {
            if let homeTeamIndex = homeTeamIndex {
                if homeTeamIndex == index {
                    self.homeTeamIndex = nil
                    view?.highlightTeam(at: index, onLeft: onLeft, bool: false)
                    view?.updateHomeTeam(nil)
                } else {
                    self.homeTeamIndex = index
                    view?.highlightTeam(at: homeTeamIndex, onLeft: onLeft, bool: false)
                    view?.highlightTeam(at: index, onLeft: onLeft, bool: true)
                    view?.updateHomeTeam(teams[index])
                }
            } else {
                homeTeamIndex = index
                view?.highlightTeam(at: index, onLeft: onLeft, bool: true)
                view?.updateHomeTeam(teams[index])
            }
        } else {
            if let awayTeamIndex = awayTeamIndex {
                if awayTeamIndex == index {
                    self.awayTeamIndex = nil
                    view?.highlightTeam(at: index, onLeft: onLeft, bool: false)
                    view?.updateAwayTeam(nil)
                } else {
                    self.awayTeamIndex = index
                    view?.highlightTeam(at: awayTeamIndex, onLeft: onLeft, bool: false)
                    view?.highlightTeam(at: index, onLeft: onLeft, bool: true)
                    view?.updateAwayTeam(teams[index])
                }
            } else {
                awayTeamIndex = index
                view?.highlightTeam(at: index, onLeft: onLeft, bool: true)
                view?.updateAwayTeam(teams[index])
            }
        }
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    
}
