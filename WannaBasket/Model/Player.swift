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

class Player: PlayerModel {
    var uuid: String
    var name: String
    var number: Int
    
    init(name: String) {
        self.uuid = ""
        self.name = name
        self.number = 0
    }
}
