//
//  PlayerModel.swift
//  WannaBasket
//
//  Created by Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol PlayerModel {
    var uuid: String {get set}
    var name: String {get set}
    var number: Int {get set}
}

struct Player: PlayerModel, Equatable {
    
    var uuid: String
    var name: String
    var number: Int
    
    init(name: String, number: Int) {
        self.uuid = ""
        self.name = name
        self.number = number
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name==rhs.name && lhs.number==rhs.number
    }
}
