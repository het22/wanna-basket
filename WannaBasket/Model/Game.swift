//
//  GameModel.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func didCurrentPlayerTupleSet(oldTuple: (home: Bool, index: Int)?,
                                  newTuple: (home: Bool, index: Int)?)
    func didCurrentStat(oldStat: Stat.Score?, newStat: Stat.Score?)
    func didSelectPlayerAndStat(playerTuple: (home: Bool, index: Int), stat: Stat.Score)
}

class Game {
    
    var delegate: GameDelegate?
    
    var homeTeam: Team
    var awayTeam: Team
    
    var time: GameTime = GameTime(maxRegularQuarterNum: 4)
    
    var currentPlayerTuple: (home: Bool, index: Int)? {
        didSet(oldTuple) {
            delegate?.didCurrentPlayerTupleSet(oldTuple: oldTuple, newTuple: currentPlayerTuple)
            if let playerTuple = currentPlayerTuple, let stat = currentStat {
                delegate?.didSelectPlayerAndStat(playerTuple: playerTuple, stat: stat)
            }
        }
    }
    var currentStat: Stat.Score? {
        didSet(oldStat) {
            delegate?.didCurrentStat(oldStat: oldStat, newStat: currentStat)
            if let playerTuple = currentPlayerTuple, let stat = currentStat {
                delegate?.didSelectPlayerAndStat(playerTuple: playerTuple, stat: stat)
            }
        }
    }
    
    init(homeTeam: Team, awayTeam: Team) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
}
