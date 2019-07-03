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

class Team: TeamModel {
    var uuid: String
    var name: String
    var players: [Player]
    
    init(name: String) {
        self.uuid = ""
        self.name = name
        players = []
    }
}