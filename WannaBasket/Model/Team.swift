//
//  TeamModel.swift
//  WannaBasket
//
//  Created by Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

struct Team {
    
    var uuid: String
    var name: String
    var playerInfors: [Int:Player]
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
        playerInfors = [:]
    }
    
    var players: [PlayerOfTeam] {
        return playerInfors
            .map{ return PlayerOfTeam(player: $0.value, teamID: self.uuid, number: $0.key) }
            .sorted{ return $0.number < $1.number }
    }
    
    var isNumberAssigned: [Bool] {
        var arr = [Bool].init(repeating: false, count: 101)
        playerInfors.forEach{ arr[$0.key] = true }
        return arr
    }
}

extension Team {
    
    mutating func register(player: Player, number: Int) {
        var player = player
        player.teamInfors[self.uuid] = number
        self.playerInfors[number] = player
    }
    
    mutating func eject(numbers: Int...) {
        numbers.forEach { playerInfors[$0] = nil }
    }
}

extension Team: Equatable {
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.name == rhs.name
    }
}
