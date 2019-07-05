//
//  GameModel.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol GameModel {
    
    // Team & Player Info
    var homeTeam: Team { get set }
    var awayTeam: Team { get set }
    var homeOnFloorIndexes: [Int] { get set }
    var awayOnFloorIndexes: [Int] { get set }
    
    // Quarter & Time Info
    var time: GameTime { get set }
    
    // Record
    
}

class Game: GameModel {
    
    var homeTeam: Team
    var awayTeam: Team
    var homeOnFloorIndexes: [Int] = []
    var awayOnFloorIndexes: [Int] = []
    
    var time: GameTime = GameTime(numberOfQuarter: 4)
    
    init(homeTeam: Team, awayTeam: Team) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
}
