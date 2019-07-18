//
//  GameSetting.swift
//  WannaBasket
//
//  Created by Het Song on 13/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol PlayerTeamManagerDelegate: class {
    func didSetCurrentTeamIndex(oldVal: (home: Int?, away: Int?), newVal: (home: Int?, away: Int?))
    
    func didAddTeam()
    func didEditTeam(at index: Int)
    func didRemoveTeam(at index: Int)
    
    func didAddPlayer(of team: Team)
    func didEditPlayer(of team: Team)
    func didRemovePlayer(of team: Team)
}

class PlayerTeamManager {
    
    weak var delegate: PlayerTeamManagerDelegate?
    
    var teams: [Team] = []
    var currentTeamIndex: (home: Int?, away: Int?) = (nil, nil) {
        didSet(oldVal) {
            delegate?.didSetCurrentTeamIndex(oldVal: oldVal, newVal: currentTeamIndex)
        }
    }
    
    init() {
        var temp1 = Team(uuid: "쿠스켓", name: "쿠스켓")
        temp1.register(player: Player(uuid: "송해찬", name: "송해찬"), number: 22)
        temp1.register(player: Player(uuid: "이재원", name: "이재원"), number: 2)
        temp1.register(player: Player(uuid: "정상빈", name: "정상빈"), number: 8)
        temp1.register(player: Player(uuid: "유현석", name: "유현석"), number: 9)
        temp1.register(player: Player(uuid: "박진모", name: "박진모"), number: 3)
        temp1.register(player: Player(uuid: "김남규", name: "김남규"), number: 10)
        var temp2 = Team(uuid: "마하맨", name: "마하맨")
        temp2.register(player: Player(uuid: "송해찬", name: "송해찬"), number: 22)
        temp2.register(player: Player(uuid: "송호철", name: "송호철"), number: 2)
        temp2.register(player: Player(uuid: "백승희", name: "백승희"), number: 24)
        temp2.register(player: Player(uuid: "한수흠", name: "한수흠"), number: 10)
        temp2.register(player: Player(uuid: "박건", name: "박건"), number: 1)
        temp2.register(player: Player(uuid: "박희영", name: "박희영"), number: 9)
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
    
    func addPlayer(player: PlayerOfTeam, teamIndex: Int) {
        teams[teamIndex].register(player: Player(uuid: player.uuid, name: player.name), number: player.number)
        delegate?.didAddPlayer(of: teams[teamIndex])
    }
    
    func editPlayer(at index: Int, teamIndex: Int, player: PlayerOfTeam) {
        if teamIndex < teams.count {
            let oldPlayer = teams[teamIndex].players[index]
            teams[teamIndex].eject(numbers: oldPlayer.number)
            teams[teamIndex].register(player: Player(uuid: player.uuid, name: player.name), number: player.number)
            delegate?.didEditPlayer(of: teams[teamIndex])
        }
    }
    
    func removePlayer(at index: Int, teamIndex: Int) {
        if teamIndex < teams.count {
            let player = teams[teamIndex].players[index]
            teams[teamIndex].eject(numbers: player.number)
            delegate?.didRemovePlayer(of: teams[teamIndex])
        }
    }
}
