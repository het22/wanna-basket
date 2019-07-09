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
        didSet(oldVal) {
            view?.enableHomePlayerAddButton(bool: (currentTeamIndex.home == nil) ? false : true)
            view?.enableAwayPlayerAddButton(bool: (currentTeamIndex.away == nil) ? false : true)
            view?.enableGameStartButton(bool: (currentTeamIndex.home == nil || currentTeamIndex.away == nil) ? false : true)
            
            if let oldIndex = oldVal.home {
                view?.highlightTeam(at: oldIndex, onLeft: true, bool: false)
                view?.updateHomeTeam(nil)
            }
            if let newIndex = currentTeamIndex.home {
                view?.highlightTeam(at: newIndex, onLeft: true, bool: true)
                view?.updateHomeTeam(teams[newIndex])
            }
            
            if let oldIndex = oldVal.away {
                view?.highlightTeam(at: oldIndex, onLeft: false, bool: false)
                view?.updateAwayTeam(nil)
            }
            if let newIndex = currentTeamIndex.away {
                view?.highlightTeam(at: newIndex, onLeft: false, bool: true)
                view?.updateAwayTeam(teams[newIndex])
            }
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
        
        view?.updateTeamTableView(with: teams)
        currentTeamIndex = (nil, nil)
    }
    
    func didTapStartButton() {
        guard let homeTeamIndex = currentTeamIndex.home,
                let awayTeamIndex = currentTeamIndex.away else { return }
        wireframe?.presentModule(source: view!,
                                 module: Module.Game(game: Game(homeTeam: teams[homeTeamIndex],
                                                                awayTeam: teams[awayTeamIndex])))
    }
    
    func didTapNewTeamButton() {
        view?.showTeamFormView = true
    }
    
    func didTapNewPlayerButton(of home: Bool) {
        isAddingHomePlayer = home
        view?.showPlayerFormView = true
    }
    
    func didTapTeamFormCompleteButton(name: String?) {
        if let name = name, name != "" {
            let team = Team(name: name)
            teams.append(team)
            view?.updateTeamTableView(with: teams)
        }
        view?.showTeamFormView = false
    }
    
    func didTapPlayerFormCompleteButton(name: String?) {
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
    
    func didDeleteTeamAction(at index: Int) {
        teams.remove(at: index)
        if let homeIndex = currentTeamIndex.home {
            if index == homeIndex { currentTeamIndex.home = nil }
            if index < homeIndex { currentTeamIndex.home = homeIndex-1 }
        }
        if let awayIndex = currentTeamIndex.away {
            if index == awayIndex { currentTeamIndex.away = nil }
            if index < awayIndex { currentTeamIndex.away = awayIndex-1 }
        }
        view?.updateTeamTableView(with: teams)
    }
    
    func didDeletePlayerAction(at index: Int, of home: Bool) {
        if let teamIndex = home ? currentTeamIndex.home : currentTeamIndex.away {
            teams[teamIndex].players.remove(at: index)
            if teamIndex == (home ? currentTeamIndex.away : currentTeamIndex.home) {
                view?.updateHomeTeam(teams[teamIndex])
                view?.updateAwayTeam(teams[teamIndex])
            } else {
                if home { view?.updateHomeTeam(teams[teamIndex]) }
                else { view?.updateAwayTeam(teams[teamIndex]) }
            }
        }
    }
    
    func didTapTeamCell(at index: Int, onLeft: Bool) {
        if onLeft {
            currentTeamIndex.home = (currentTeamIndex.home==index) ? nil : index
        } else {
            currentTeamIndex.away = (currentTeamIndex.away==index) ? nil : index
        }
    }
    
    func didDequeueTeamCell() -> (home: Int?, away: Int?) {
        return currentTeamIndex
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    
}
