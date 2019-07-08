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
    var currentTeamIndex: (home: Int?, away: Int?) = (nil, nil) {
        didSet {
            view?.enableHomePlayerAddButton(bool: (currentTeamIndex.home == nil) ? false : true)
            view?.enableAwayPlayerAddButton(bool: (currentTeamIndex.away == nil) ? false : true)
            view?.enableGameStartButton(bool: (currentTeamIndex.home == nil || currentTeamIndex.away == nil) ? false : true)
        }
    }
    var isAddingHomePlayer: Bool = true
    
    func viewDidLoad() {
        // Temp Data
        let temp1 = Team(name: "쿠스켓")
        temp1.players.append(contentsOf: [Player(name: "유현석"),Player(name: "정상빈"), Player(name: "이재원"), Player(name: "송해찬"), Player(name: "박진모")])
        let temp2 = Team(name: "마하맨")
        temp2.players.append(contentsOf: [Player(name: "송호철"),Player(name: "백승희"), Player(name: "박건"), Player(name: "송해찬"), Player(name: "한수흠")])
        teams.append(contentsOf: [temp1, temp2])
        teams.append(Team(name: "업템포"))
        teams.append(Team(name: "LP SUPPORT"))
        teams.append(Team(name: "아울스"))
        teams.append(Team(name: "화우"))
        teams.append(Team(name: "MSA"))
        
        view?.updateTeams(teams)
        view?.updateHomeTeam(nil)
        view?.updateAwayTeam(nil)
        currentTeamIndex = (nil, nil)
    }
    
    func didStartButtonTap() {
        guard let homeTeamIndex = currentTeamIndex.home,
                let awayTeamIndex = currentTeamIndex.away else { return }
        wireframe?.presentModule(source: view!,
                                 module: Module.Game(game: Game(homeTeam: teams[homeTeamIndex],
                                                                awayTeam: teams[awayTeamIndex])))
    }
    
    func didNewTeamButtonTap() {
        view?.showTeamFormView = true
    }
    
    func didNewHomePlayerButtonTap() {
        isAddingHomePlayer = true
        view?.showPlayerFormView = true
    }
    
    func didNewAwayPlayerButtonTap() {
        isAddingHomePlayer = false
        view?.showPlayerFormView = true
    }
    
    func didAddTeamCompleteButtonTap(name: String?) {
        if let name = name, name != "" {
            let team = Team(name: name)
            teams.append(team)
            view?.updateTeams(teams)
        }
        view?.showTeamFormView = false
    }
    
    func didPlayerFormCompleteButtonTap(name: String?) {
        if let name = name, name != "", let index = isAddingHomePlayer ? currentTeamIndex.home : currentTeamIndex.away  {
            let player = Player(name: name)
            teams[index].players.append(player)
            if currentTeamIndex.home == currentTeamIndex.away {
                view?.updateHomeTeam(teams[index])
                view?.updateAwayTeam(teams[index])
            }
            if isAddingHomePlayer { view?.updateHomeTeam(teams[index]) }
            else { view?.updateAwayTeam(teams[index]) }
        }
        view?.showPlayerFormView = false
    }
    
    func didTeamCellTap(at index: Int, onLeft: Bool) {
        if onLeft {if let homeTeamIndex = currentTeamIndex.home {
                if homeTeamIndex == index {
                    self.currentTeamIndex.home = nil
                    view?.highlightTeam(at: index, onLeft: onLeft, bool: false)
                    view?.updateHomeTeam(nil)
                } else {
                    self.currentTeamIndex.home = index
                    view?.highlightTeam(at: homeTeamIndex, onLeft: onLeft, bool: false)
                    view?.highlightTeam(at: index, onLeft: onLeft, bool: true)
                    view?.updateHomeTeam(teams[index])
                }
            } else {
                currentTeamIndex.home = index
                view?.highlightTeam(at: index, onLeft: onLeft, bool: true)
                view?.updateHomeTeam(teams[index])
            }
        } else {
            if let awayTeamIndex = currentTeamIndex.away {
                if awayTeamIndex == index {
                    self.currentTeamIndex.away = nil
                    view?.highlightTeam(at: index, onLeft: onLeft, bool: false)
                    view?.updateAwayTeam(nil)
                } else {
                    self.currentTeamIndex.away = index
                    view?.highlightTeam(at: awayTeamIndex, onLeft: onLeft, bool: false)
                    view?.highlightTeam(at: index, onLeft: onLeft, bool: true)
                    view?.updateAwayTeam(teams[index])
                }
            } else {
                currentTeamIndex.away = index
                view?.highlightTeam(at: index, onLeft: onLeft, bool: true)
                view?.updateAwayTeam(teams[index])
            }
        }
    }
    
    func didTeamCellDequeue() -> (home: Int?, away: Int?) {
        return currentTeamIndex
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    
}
