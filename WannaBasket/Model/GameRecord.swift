//
//  GameRecord.swift
//  WannaBasket
//
//  Created by Het Song on 15/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

struct GameRecord {
    
    var records: [Record]
    
    var teams: (home: Team, away: Team)
    
    var scores: (home: Int, away: Int) {
        return records.reduce((0,0)) { (scores, record) -> (Int, Int) in
            if case let .Score(Score) = record.stat {
                let score = Score.rawValue
                let home = record.home
                return home ? (scores.0 + score, scores.1) : (scores.0, scores.1 + score)
            }
            return scores
        }
    }
}
