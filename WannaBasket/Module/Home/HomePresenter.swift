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
    // MARK: View Model
    // --------------------------------------------------
    /// 팀 목록을 저장하고 뷰에 업데이트한다.
    private var teams: [Team] = [] {
        didSet {
            // 1. 새로운 팀 목록을 받으면 기존에 선택되어있던 팀들의 uuid를 임시 저장한다.
            var uuid = (home: "", away: "")
            if let homeIndex = currentTeamIndexTuple.home,
                let homeTeam = oldValue[safe: homeIndex] {
                uuid.home = homeTeam.uuid
            }
            if let awayIndex = currentTeamIndexTuple.away,
                let awayTeam = oldValue[safe: awayIndex] {
                uuid.away = awayTeam.uuid
            }
            
            // 2. 선택되어있는 팀 튜플을 초기화한다.
            currentTeamIndexTuple = (nil, nil)
            
            // 3. 새로운 팀 목록에서 임시저장해둔 uuid를 통해 기존에 선택되어있던 팀들을 찾아 복구한다.
            if let newHomeIndex = teams.firstIndex(where: {$0.uuid==uuid.home}) {
                currentTeamIndexTuple.home = newHomeIndex
            }
            if let newAwayIndex = teams.firstIndex(where: {$0.uuid==uuid.away}) {
                currentTeamIndexTuple.away = newAwayIndex
            }
            
            // 4. 뷰에 새로운 팀 목록을 보여준다.
            view?.updateTeamTableView(teams: teams)
        }
    }
    
    /// 현재 선택한 홈팀과 원정팀의 인덱스를 저장하고 뷰를 업데이트 한다.
    var currentTeamIndexTuple: (home: Int?, away: Int?) = (nil, nil) {
        didSet {
            // 1. 선수 추가 버튼을 활성화/비활성화 한다.
            view?.enablePlayerAddButton(bool: (currentTeamIndexTuple.home != nil), of: true)
            view?.enablePlayerAddButton(bool: (currentTeamIndexTuple.away != nil), of: false)
            
            // 2. 게임 시작 버튼을 활성화/비활성화 한다.
            view?.enableGameStartButton(bool: (currentTeamIndexTuple.home == nil || currentTeamIndexTuple.away == nil) ? false : true)
            
            // 3. 기존에 선택된 팀이 있다면 비활성화한다.
            if let oldIndex = oldValue.home {
                view?.highlightTeam(at: oldIndex, onLeft: true, bool: false)
                view?.updatePlayerTableView(players: nil, of: true)
                view?.updateTeamNameLabel(name: nil, of: true)
            }
            if let oldIndex = oldValue.away {
                view?.highlightTeam(at: oldIndex, onLeft: false, bool: false)
                view?.updatePlayerTableView(players: nil, of: false)
                view?.updateTeamNameLabel(name: nil, of: false)
            }
            
            // 4. 새로 선택된 팀이 있다면 활성화한다.
            if let newIndex = currentTeamIndexTuple.home {
                let team = teams[newIndex]
                view?.highlightTeam(at: newIndex, onLeft: true, bool: true)
                view?.updatePlayerTableView(players: team.players, of: true)
                view?.updateTeamNameLabel(name: team.name, of: true)
            }
            if let newIndex = currentTeamIndexTuple.away {
                let team = teams[newIndex]
                view?.highlightTeam(at: newIndex, onLeft: false, bool: true)
                view?.updatePlayerTableView(players: team.players, of: false)
                view?.updateTeamNameLabel(name: team.name, of: false)
            }
        }
    }
    
    /// TeamFormView에 보여주고 있는 팀의 정보를 저장하고 뷰를 업데이트한다.
    var currentShowingTeamIndex: Int? {
        didSet {
            if let index = currentShowingTeamIndex, let team = teams[safe: index] {
                view?.showTeamFormView(isEditMode: true, name: team.name, index: index, bool: true)
            } else {
                view?.showTeamFormView(isEditMode: false, name: nil, index: nil, bool: false)
            }
        }
    }
    
    /// PlayerFormView에 보여주고 있는 선수의 정보를 저장하고 뷰를 업데이트한다.
    var currentShowingPlayerTuple: (index: Int?, home: Home)? {
        didSet {
            if let tuple = currentShowingPlayerTuple {
                if let index = tuple.index {
                    if let teamIndex = tuple.home ? currentTeamIndexTuple.home : currentTeamIndexTuple.away,
                        let player = teams[safe: teamIndex]?.players[safe: index] {
                        view?.showPlayerFormView(isEditMode: true, player: player, index: index, bool: true)
                    }
                } else {
                    view?.showPlayerFormView(isEditMode: false, player: nil, index: nil, bool: true)
                }
            } else {
                view?.showPlayerFormView(isEditMode: false, player: nil, index: nil, bool: false)
            }
        }
    }
    
    private var isEdittingHome: Bool = true
    
    // --------------------------------------------------
    // MARK: Home View Events
    // --------------------------------------------------
    func viewDidLoad() {
        // 1. 뷰를 초기 모습으로 설정
        view?.updateTeamTableView(teams: [])
        view?.updatePlayerTableView(players: nil, of: true)
        view?.updatePlayerTableView(players: nil, of: false)
        view?.enableGameStartButton(bool: false)
        view?.enablePlayerAddButton(bool: false, of: true)
        view?.enablePlayerAddButton(bool: false, of: false)
        view?.updateTeamNameLabel(name: nil, of: true)
        view?.updateTeamNameLabel(name: nil, of: false)
        view?.updateTeamTableView(teams: [])
        // 2. 로컬 DB에게 모든 팀 정보 요청
        interactor?.requestReadAllTeam()
    }
    
    func didTapStartButton() {
        guard
            let homeTeamIndex = currentTeamIndexTuple.home,
            let awayTeamIndex = currentTeamIndexTuple.away,
            let homeTeam = teams[safe: homeTeamIndex],
            let awayTeam = teams[safe: awayTeamIndex] else { return }
        
        let game: GameConfigurable = Game(home: homeTeam, away: awayTeam)
        wireframe?.presentModule(source: view!, module: Module.Game(game: game as! Game))
    }
    
    func didTapNewTeamButton() {
        view?.showTeamFormView(isEditMode: false, name: nil, index: nil, bool: true)
    }
    
    func didTapNewPlayerButton(of home: Home) {
        currentShowingPlayerTuple = (nil, home)
    }
    
    // --------------------------------------------------
    // MARK: Team Form View Events
    // --------------------------------------------------
    func didTapTeamFormCancelButton() {
        currentShowingTeamIndex = nil
    }
    
    func didTapTeamFormDeleteButton(index: Int) {
        if let team = teams[safe: index] {
            interactor?.requestDeleteTeam(team: team)
        }
    }
    
    func didTapTeamFormCompleteButton(name: String) {
        let newTeam = Team(uuid: "" ,name: name)
        interactor?.requestUpdateTeam(team: newTeam)
    }
    
    func didTapTeamFormEditButton(name: String, index: Int) {
        if let team = teams[safe: index] {
            var editedTeam = team
            editedTeam.name = name
            interactor?.requestUpdateTeam(team: editedTeam)
        }
    }
    
    // --------------------------------------------------
    // MARK: Player Form View Events
    // --------------------------------------------------
    func didTapPlayerFormCancelButton() {
        currentShowingPlayerTuple = nil
    }
    
    func didTapPlayerFormDeleteButton(index: Int) {
        if let home = currentShowingPlayerTuple?.home,
            let teamIndex = home ? currentTeamIndexTuple.home : currentTeamIndexTuple.away,
            let team = teams[safe: teamIndex],
            let player = team.players[safe: index] {
            interactor?.requestEjectPlayer(player: player, team: team)
        }
    }
    
    func didTapPlayerFormCompleteButton(player: PlayerOfTeam) {
        if let home = currentShowingPlayerTuple?.home,
            let teamIndex = home ? currentTeamIndexTuple.home : currentTeamIndexTuple.away,
            let team = teams[safe: teamIndex] {
            interactor?.requestRegisterPlayer(player: player, team: team)
        }
    }
    
    func didTapPlayerFormEditButton(player: PlayerOfTeam, index: Int) {
        interactor?.requestUpdatePlayer(player: player)
    }
    
    func didTapPlayerNumberButton() -> [Bool] {
        if let tuple = currentShowingPlayerTuple,
            let index = tuple.home ? currentTeamIndexTuple.home : currentTeamIndexTuple.away {
            let team = teams[index]
            return team.isNumberAssigned
        } else {
            print("Warning(\(self)): didTapPlayerNumberButton returned an empty collection.")
            return []
        }
    }
    
    // --------------------------------------------------
    // MARK: Team Table View Events
    // --------------------------------------------------
    func didTapTeamCell(at index: Int, tapSection: TeamCell.Section) {
        switch tapSection {
        case .Middle:
            currentShowingTeamIndex = index
        case .Left:
            let oldIndex = currentTeamIndexTuple.home
            currentTeamIndexTuple.home = (index == oldIndex) ? nil : index
        case .Right:
            let oldIndex = currentTeamIndexTuple.away
            currentTeamIndexTuple.away = (index == oldIndex) ? nil : index
        }
    }
    
    func didDeleteTeamAction(at index: Int) {
        if let team = teams[safe: index] {
            interactor?.requestDeleteTeam(team: team)
        }
    }
    
    func didDequeueTeamCell() -> (home: Int?, away: Int?) {
        return currentTeamIndexTuple
    }
    
    // --------------------------------------------------
    // MARK: Player Table View Events
    // --------------------------------------------------
    func didTapPlayerCell(at index: Int, of home: Home) {
        currentShowingPlayerTuple = (index, home)
    }
    
    func didDeletePlayerAction(at index: Int, of home: Home) {
        if let teamIndex = home ? currentTeamIndexTuple.home : currentTeamIndexTuple.away,
            let team = teams[safe: teamIndex],
            let player = team.players[safe: index] {
            interactor?.requestEjectPlayer(player: player, team: team)
        }
    }
}

// --------------------------------------------------
// MARK: Home Interactor Output Protocol
// --------------------------------------------------
extension HomePresenter: HomeInteractorOutputProtocol {
    
    func didReadAllTeam(teams: [Team]) {
        self.teams = teams
    }
    
    func didUpdateTeam() {
        interactor?.requestReadAllTeam()
        currentShowingTeamIndex = nil
        currentShowingPlayerTuple = nil
    }
    
    func didDeleteTeam() {
        interactor?.requestReadAllTeam()
        currentShowingTeamIndex = nil
    }
}
