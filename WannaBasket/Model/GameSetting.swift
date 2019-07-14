//
//  GameSetting.swift
//  WannaBasket
//
//  Created by Het Song on 13/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol GameSettingDelegate: class {
    func didSetCurrentTeamIndex(oldVal: (home: Int?, away: Int?), newVal: (home: Int?, away: Int?))
    
    func didAddTeam()
    func didEditTeam(at index: Int)
    func didRemoveTeam(at index: Int)
    
    func didAddPlayer(of team: Team)
    func didEditPlayer(of team: Team)
    func didRemovePlayer(of team: Team)
}

class GameSetting {
    
    weak var delegate: GameSettingDelegate?
    
    var teams: [Team] = []
    var currentTeamIndex: (home: Int?, away: Int?) = (nil, nil) {
        didSet(oldVal) {
            delegate?.didSetCurrentTeamIndex(oldVal: oldVal, newVal: currentTeamIndex)
        }
    }
    
    init() {
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
                                          Player(name: "한수흠", number: 12),
                                          Player(name: "이영한", number: 6),
                                          Player(name: "한승진", number: 2),
                                          Player(name: "김범철", number: 8)])
        teams.append(contentsOf: [temp1, temp2])
    }
    
    func addTeam(team: Team) {
        teams.append(team)
        delegate?.didAddTeam()
    }
    
    func editTeam(at index: Int, editName: String) {
        if index < teams.count {
            teams[index].name = editName
            delegate?.didEditTeam(at: index)
        }
    }
    
    func removeTeam(at index: Int) {
        if index < teams.count {
            teams.remove(at: index)
            delegate?.didRemoveTeam(at: index)
        }
    }
    
    func addPlayer(player: Player, teamIndex: Int) {
        if teamIndex < teams.count {
            teams[teamIndex].players.append(player)
            delegate?.didAddPlayer(of: teams[teamIndex])
        }
    }
    
    func editPlayer(at index: Int, teamIndex: Int, editPlayer: Player) {
        if teamIndex < teams.count, index < teams[teamIndex].players.count {
            let player = teams[teamIndex].players[index]
            player.number = editPlayer.number
            player.name = editPlayer.name
            delegate?.didEditPlayer(of: teams[teamIndex])
        }
    }
    
    func removePlayer(at index: Int, teamIndex: Int) {
        if teamIndex < teams.count, index < teams[teamIndex].players.count {
            teams[teamIndex].players.remove(at: index)
            delegate?.didRemovePlayer(of: teams[teamIndex])
        }
    }
}
