//
//  HomePresenter.swift
//  WannaBasket
//
//  Created Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class HomePresenter: HomePresenterProtocol {
    
    // --------------------------------------------------
    // MARK: Connect Module Components
    // --------------------------------------------------
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var wireframe: HomeWireframeProtocol?
    
    // --------------------------------------------------
    // MARK: Manage Game Setting Information
    // --------------------------------------------------
    var gameSetting: GameSetting! {
        didSet { gameSetting.delegate = self }
    }
    var isEdittingHome: Bool = true
    
    // --------------------------------------------------
    // MARK: View Events
    // --------------------------------------------------
    func viewDidLoad() {
        view?.updateTeamTableView(teams: gameSetting.teams)
        gameSetting.currentTeamIndex = (0, 1)
    }
    
    func didTapStartButton() {
        guard let homeTeamIndex = gameSetting.currentTeamIndex.home,
                let awayTeamIndex = gameSetting.currentTeamIndex.away else { return }
        let game = Game(homeTeam: gameSetting.teams[homeTeamIndex],
                        awayTeam: gameSetting.teams[awayTeamIndex])
        wireframe?.presentModule(source: view!, module: Module.Game(game: game))
    }
    
    func didTapNewTeamButton() {
        view?.showTeamFormView(isEditMode: false, name: nil, index: nil, bool: true)
    }
    
    func didTapNewPlayerButton(of home: Bool) {
        isEdittingHome = home
        view?.showPlayerFormView(isEditMode: false, player: nil, index: nil, bool: true)
    }
    
    // --------------------------------------------------
    // MARK: Team Form View Events
    // --------------------------------------------------
    func didTapTeamFormCancelButton() {
        view?.showTeamFormView(isEditMode: false, name: nil, index: nil, bool: false)
    }
    
    func didTapTeamFormDeleteButton(index: Int) {
        gameSetting.removeTeam(at: index)
    }
    
    func didTapTeamFormCompleteButton(name: String) {
        let team = Team(name: name)
        gameSetting.addTeam(team: team)
    }
    
    func didTapTeamFormEditButton(name: String, index: Int) {
        gameSetting.editTeam(at: index, editName: name)
    }
    
    // --------------------------------------------------
    // MARK: Player Form View Events
    // --------------------------------------------------
    func didTapPlayerFormCancelButton() {
        view?.showPlayerFormView(isEditMode: false, player: nil, index: nil, bool: false)
    }
    
    func didTapPlayerFormDeleteButton(index: Int) {
        if let teamIndex = isEdittingHome ? gameSetting.currentTeamIndex.home : gameSetting.currentTeamIndex.away  {
            gameSetting.removePlayer(at: index, teamIndex: teamIndex)
        }
    }
    
    func didTapPlayerFormCompleteButton(player: Player) {
        if let teamIndex = isEdittingHome ? gameSetting.currentTeamIndex.home : gameSetting.currentTeamIndex.away  {
            gameSetting.addPlayer(player: player, teamIndex: teamIndex)
        }
    }
    
    func didTapPlayerFormEditButton(player: Player, index: Int) {
        if let teamIndex = isEdittingHome ? gameSetting.currentTeamIndex.home : gameSetting.currentTeamIndex.away  {
            gameSetting.editPlayer(at: index, teamIndex: teamIndex, editPlayer: player)
        }
    }
    
    func didTapPlayerNumberButton() -> [Bool] {
        if let index = isEdittingHome ? gameSetting.currentTeamIndex.home : gameSetting.currentTeamIndex.away {
            let team = gameSetting.teams[index]
            return team.isNumberAssigned
        } else {
            return []
        }
    }
    
    // --------------------------------------------------
    // MARK: Team Table View Events
    // --------------------------------------------------
    func didTapTeamCell(at index: Int, tapSection: TeamTableViewCell.Section) {
        switch tapSection {
        case .Middle:
            let team = gameSetting.teams[index]
            view?.showTeamFormView(isEditMode: true, name: team.name, index: index, bool: true)
        case .Left:
            let oldIndex = gameSetting.currentTeamIndex.home
            gameSetting.currentTeamIndex.home = (index == oldIndex) ? nil : index
        case .Right:
            let oldIndex = gameSetting.currentTeamIndex.away
            gameSetting.currentTeamIndex.away = (index == oldIndex) ? nil : index
        }
    }
    
    func didDeleteTeamAction(at index: Int) {
        gameSetting.removeTeam(at: index)
    }
    
    func didDequeueTeamCell() -> (home: Int?, away: Int?) {
        return gameSetting.currentTeamIndex
    }
    
    // --------------------------------------------------
    // MARK: Player Table View Events
    // --------------------------------------------------
    func didTapPlayerCell(at index: Int, of home: Bool) {
        isEdittingHome = home
        if let teamIndex = home ? gameSetting.currentTeamIndex.home : gameSetting.currentTeamIndex.away,
           let player = gameSetting.teams[teamIndex].players[safe: index] {
            view?.showPlayerFormView(isEditMode: true, player: player, index: index, bool: true)
        }
    }
    
    func didDeletePlayerAction(at index: Int, of home: Bool) {
        isEdittingHome = home
        if let teamIndex = home ? gameSetting.currentTeamIndex.home : gameSetting.currentTeamIndex.away {
            gameSetting.removePlayer(at: index, teamIndex: teamIndex)
        }
    }
}


// --------------------------------------------------
// MARK: Game Setting Delegate
// --------------------------------------------------
extension HomePresenter: GameSettingDelegate {
    
    func didSetCurrentTeamIndex(oldVal: (home: Int?, away: Int?), newVal: (home: Int?, away: Int?)) {
        view?.enableHomePlayerAddButton(bool: (newVal.home == nil) ? false : true)
        view?.enableAwayPlayerAddButton(bool: (newVal.away == nil) ? false : true)
        view?.enableGameStartButton(bool: (newVal.home == nil || newVal.away == nil) ? false : true)
        
        if let oldIndex = oldVal.home {
            view?.highlightTeam(at: oldIndex, onLeft: true, bool: false)
            view?.updatePlayerTableView(players: nil, of: true)
            view?.updateTeamNameLabel(name: nil, of: true)
        }
        if let newIndex = newVal.home {
            let team = gameSetting.teams[newIndex]
            view?.highlightTeam(at: newIndex, onLeft: true, bool: true)
            view?.updatePlayerTableView(players: team.players, of: true)
            view?.updateTeamNameLabel(name: team.name, of: true)
        }
        
        if let oldIndex = oldVal.away {
            view?.highlightTeam(at: oldIndex, onLeft: false, bool: false)
            view?.updatePlayerTableView(players: nil, of: false)
            view?.updateTeamNameLabel(name: nil, of: false)
        }
        if let newIndex = newVal.away {
            let team = gameSetting.teams[newIndex]
            view?.highlightTeam(at: newIndex, onLeft: false, bool: true)
            view?.updatePlayerTableView(players: team.players, of: false)
            view?.updateTeamNameLabel(name: team.name, of: false)
        }
    }
    
    func didAddTeam() {
        view?.updateTeamTableView(teams: gameSetting.teams)
        view?.showTeamFormView(isEditMode: false, name: nil, index: nil, bool: false)
    }
    
    func didEditTeam(at index: Int) {
        view?.updateTeamTableView(teams: gameSetting.teams)
        let team = gameSetting.teams[index]
        if let homeIndex = gameSetting.currentTeamIndex.home, homeIndex == index {
            view?.updateTeamNameLabel(name: team.name, of: true)
        }
        if let awayIndex = gameSetting.currentTeamIndex.away, awayIndex == index {
            view?.updateTeamNameLabel(name: team.name, of: false)
        }
        view?.showTeamFormView(isEditMode: true, name: nil, index: nil, bool: false)
    }
    
    func didRemoveTeam(at index: Int) {
        view?.updateTeamTableView(teams: gameSetting.teams)
        var newIndex: (home: Int?, away: Int?)
        if let homeIndex = gameSetting.currentTeamIndex.home {
            if index == homeIndex { newIndex.home = nil }
            if index < homeIndex { newIndex.home = homeIndex-1 }
        }
        if let awayIndex = gameSetting.currentTeamIndex.away {
            if index == awayIndex { newIndex.away = nil }
            if index < awayIndex { newIndex.away = awayIndex-1 }
        }
        gameSetting.currentTeamIndex = newIndex
        view?.showTeamFormView(isEditMode: true, name: nil, index: nil, bool: false)
    }
    
    func didAddPlayer(of team: Team) {
        if gameSetting.currentTeamIndex.home == gameSetting.currentTeamIndex.away {
            view?.updatePlayerTableView(players: team.players, of: true)
            view?.updatePlayerTableView(players: team.players, of: false)
        } else {
            view?.updatePlayerTableView(players: team.players, of: isEdittingHome)
        }
        view?.showPlayerFormView(isEditMode: false, player: nil, index: nil, bool: false)
    }
    
    func didEditPlayer(of team: Team) {
        view?.updatePlayerTableView(players: team.players, of: isEdittingHome)
        view?.showPlayerFormView(isEditMode: true, player: nil, index: nil, bool: false)
    }
    
    func didRemovePlayer(of team: Team) {
        if gameSetting.currentTeamIndex.home == gameSetting.currentTeamIndex.away {
            view?.updatePlayerTableView(players: team.players, of: true)
            view?.updateTeamNameLabel(name: team.name, of: true)
            view?.updatePlayerTableView(players: team.players, of: false)
            view?.updateTeamNameLabel(name: team.name, of: false)
        } else {
            view?.updatePlayerTableView(players: team.players, of: isEdittingHome)
            view?.updateTeamNameLabel(name: team.name, of: isEdittingHome)
        }
        view?.showPlayerFormView(isEditMode: true, player: nil, index: nil, bool: false)
    }
}

// --------------------------------------------------
// MARK: Home Interactor Output Protocol
// --------------------------------------------------
extension HomePresenter: HomeInteractorOutputProtocol {
    
}
