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
                view?.updatePlayerTableView(players: nil, of: true)
                view?.updateTeamNameLabel(name: nil, of: true)
            }
            if let newIndex = currentTeamIndex.home {
                let team = teams[newIndex]
                view?.highlightTeam(at: newIndex, onLeft: true, bool: true)
                view?.updatePlayerTableView(players: team.players, of: true)
                view?.updateTeamNameLabel(name: team.name, of: true)
            }
            
            if let oldIndex = oldVal.away {
                view?.highlightTeam(at: oldIndex, onLeft: false, bool: false)
                view?.updatePlayerTableView(players: nil, of: false)
                view?.updateTeamNameLabel(name: nil, of: false)
            }
            if let newIndex = currentTeamIndex.away {
                let team = teams[newIndex]
                view?.highlightTeam(at: newIndex, onLeft: false, bool: true)
                view?.updatePlayerTableView(players: team.players, of: false)
                view?.updateTeamNameLabel(name: team.name, of: false)
            }
        }
    }
    var isAddingHomePlayer: Bool = true
    
    func viewDidLoad() {
        // Temp Data
        let temp1 = Team(name: "쿠스켓")
        temp1.players.append(contentsOf: [Player(name: "유현석", number: 10),
                                          Player(name: "정상빈", number: 8),
                                          Player(name: "이재원", number: 2),
                                          Player(name: "송해찬", number: 3),
                                          Player(name: "박진모", number: 12),
                                          Player(name: "임민규", number: 21),
                                          Player(name: "김태희", number: 66),
                                          Player(name: "안정우", number: 34),
                                          Player(name: "김남규", number: 30)])
        let temp2 = Team(name: "마하맨")
        temp2.players.append(contentsOf: [Player(name: "송호철", number: 22),
                                          Player(name: "백승희", number: 23),
                                          Player(name: "박건", number: 9),
                                          Player(name: "송해찬", number: 49),
                                          Player(name: "한수흠", number: 12)])
        teams.append(contentsOf: [temp1, temp2])
        
        view?.updateTeamTableView(teams: teams)
        currentTeamIndex = (0, 1)
    }
    
    func didTapStartButton() {
        guard let homeTeamIndex = currentTeamIndex.home,
                let awayTeamIndex = currentTeamIndex.away else { return }
        wireframe?.presentModule(source: view!,
                                 module: Module.Game(game: Game(homeTeam: teams[homeTeamIndex],
                                                                awayTeam: teams[awayTeamIndex])))
    }
    
    func didTapNewTeamButton() {
        view?.isShowingTeamFormView = true
    }
    
    func didTapNewPlayerButton(of home: Bool) {
        isAddingHomePlayer = home
        view?.isShowingPlayerFormView = true
    }
    
    func didTapTeamFormCompleteButton(name: String?) {
        if let name = name, name != "" {
            let team = Team(name: name)
            teams.append(team)
            view?.updateTeamTableView(teams: teams)
        }
        view?.isShowingTeamFormView = false
    }
    
    func didTapPlayerFormCompleteButton(name: String?, number: Int?) {
        if let name = name, let number = number, let index = isAddingHomePlayer ? currentTeamIndex.home : currentTeamIndex.away  {
            let team = teams[index]
            let player = Player(name: name, number: number)
            team.players.append(player)
            if currentTeamIndex.home == currentTeamIndex.away {
                view?.updatePlayerTableView(players: team.players, of: true)
                view?.updateTeamNameLabel(name: team.name, of: true)
                view?.updatePlayerTableView(players: team.players, of: false)
                view?.updateTeamNameLabel(name: team.name, of: false)
            } else {
                view?.updatePlayerTableView(players: team.players, of: isAddingHomePlayer)
                view?.updateTeamNameLabel(name: team.name, of: isAddingHomePlayer)
            }
        }
        view?.isShowingPlayerFormView = false
    }
    
    func didDeleteTeamAction(at index: Int) {
        teams.remove(at: index)
        var newTeamIndex: (home: Int?, away: Int?)
        if let homeIndex = currentTeamIndex.home {
            if index == homeIndex { newTeamIndex.home = nil }
            if index < homeIndex { newTeamIndex.home = homeIndex-1 }
        }
        if let awayIndex = currentTeamIndex.away {
            if index == awayIndex { newTeamIndex.away = nil }
            if index < awayIndex { newTeamIndex.away = awayIndex-1 }
        }
        currentTeamIndex = newTeamIndex
        view?.updateTeamTableView(teams: teams)
    }
    
    func didDeletePlayerAction(at index: Int, of home: Bool) {
        if let teamIndex = home ? currentTeamIndex.home : currentTeamIndex.away {
            let team = teams[teamIndex]
            team.players.remove(at: index)
            if currentTeamIndex.home == currentTeamIndex.away {
                view?.updatePlayerTableView(players: team.players, of: true)
                view?.updateTeamNameLabel(name: team.name, of: true)
                view?.updatePlayerTableView(players: team.players, of: false)
                view?.updateTeamNameLabel(name: team.name, of: false)
            } else {
                view?.updatePlayerTableView(players: team.players, of: isAddingHomePlayer)
                view?.updateTeamNameLabel(name: team.name, of: isAddingHomePlayer)
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
