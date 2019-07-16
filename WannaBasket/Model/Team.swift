//
//  TeamModel.swift
//  WannaBasket
//
//  Created by Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol TeamModel {
    var uuid: String {get set}
    var name: String {get set}
    var players: [Player] {get set}
}

class Team: TeamModel, Equatable {
    var uuid: String
    var name: String
    var players: [Player] {
        didSet { players.sort { return $0.number < $1.number } }
    }
    
    init(name: String) {
        self.uuid = ""
        self.name = name
        players = []
    }
    
    var isNumberAssigned: [Bool] {
        var arr = [Bool].init(repeating: false, count: 101)
        players.forEach { arr[$0.number] = true }
        return arr
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.name == rhs.name
    }
}
