//
//  PlayerModel.swift
//  WannaBasket
//
//  Created by Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

struct Player: Equatable {
    var uuid: String
    var name: String
    var teamInfors: [String:Int]
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
        self.teamInfors = [:]
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

struct PlayerOfTeam: Equatable {
    var uuid: String
    var name: String
    var teamID: String
    var number: Int
    
    init(uuid: String, name: String, teamID: String, number: Int) {
        self.uuid = uuid
        self.name = name
        self.teamID = teamID
        self.number = number
    }
    
    init(player: Player, teamID: String, number: Int) {
        self.uuid = player.uuid
        self.name = player.name
        self.teamID = teamID
        self.number = number
    }
    
    static func == (lhs: PlayerOfTeam, rhs: PlayerOfTeam) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
