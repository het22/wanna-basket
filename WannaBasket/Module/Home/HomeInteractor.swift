//
//  HomeInteractor.swift
//  WannaBasket
//
//  Created Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class HomeInteractor: HomeInteractorInputProtocol {

    weak var presenter: HomeInteractorOutputProtocol?
    
    var teamDB: TeamDB!
    var playerDB: PlayerDB!
    
    func requestReadAllTeam() {
        let teams = teamDB.readAll()
            .map{ return Team(realmObject: $0) }
            .sorted{ return $0.name < $1.name }
        presenter?.didReadAllTeam(teams: teams)
    }
    
    func requestUpdateTeam(team: Team) {
        let realmTeam = team.realmObject()
        teamDB.update(realmTeam: realmTeam)
        presenter?.didUpdateTeam()
    }
    
    func requestDeleteTeam(team: Team) {
        let realmTeam = team.realmObject()
        realmTeam.playerInfors.forEach{
            if let realmPlayer = playerDB.read(with: $0.key) {
                playerDB.delete(realmPlayer: realmPlayer)
            }
        }
        teamDB.delete(realmTeam: realmTeam)
        presenter?.didDeleteTeam()
    }
    
    func requestRegisterPlayer(player: PlayerOfTeam, team: Team) {
        var newPlayer = Player(uuid: "", name: player.name)
        newPlayer.teamInfors[team.uuid] = player.number
        let realmPlayer = newPlayer.realmObject()
        playerDB.update(realmPlayer: realmPlayer)
        
        var editedTeam = team
        editedTeam.playerInfors[player.number] = Player(realmObject: realmPlayer)
        let realmTeam = editedTeam.realmObject()
        teamDB.update(realmTeam: realmTeam)
        
        presenter?.didUpdateTeam()
    }
    
    func requestUpdatePlayer(player: PlayerOfTeam) {
        if let realmPlayer = playerDB.read(with: player.uuid),
            let realmTeam = teamDB.read(with: player.teamID) {
            
            var editedPlayer = Player(realmObject: realmPlayer)
            guard let oldNumber = editedPlayer.teamInfors[player.teamID] else { return }
            editedPlayer.name = player.name
            editedPlayer.teamInfors[player.teamID] = player.number
            playerDB.update(realmPlayer: editedPlayer.realmObject())
            
            var editedTeam = Team(realmObject: realmTeam)
            editedTeam.playerInfors.removeValue(forKey: oldNumber)
            editedTeam.playerInfors[player.number] = editedPlayer
            teamDB.update(realmTeam: editedTeam.realmObject())
            
            presenter?.didUpdateTeam()
        }
    }
    
    func requestEjectPlayer(player: PlayerOfTeam, team: Team) {
        let realmPlayer = Player(uuid: player.uuid, name: player.name).realmObject()
        playerDB.delete(realmPlayer: realmPlayer)
        
        var editedTeam = team
        editedTeam.playerInfors[player.number] = nil
        let realmTeam = editedTeam.realmObject()
        teamDB.update(realmTeam: realmTeam)
        
        presenter?.didUpdateTeam()
    }
}
