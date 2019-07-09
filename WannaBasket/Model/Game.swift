//
//  GameModel.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func didSetCurrentPlayerTuple(oldTuple: (home: Bool, index: Int)?, newTuple: (home: Bool, index: Int)?)
    func didSetCurrentStat(oldStat: Stat.Score?, newStat: Stat.Score?)
    func didSetPlayerAndStat(playerTuple: (home: Bool, index: Int), stat: Stat.Score)
}

class Game {
    
    var delegate: GameDelegate?
    
    var homeTeam: Team
    var awayTeam: Team
    
    init(homeTeam: Team, awayTeam: Team) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
    
    var timeManager: TimeManager = TimeManager(maxRegularQuarterNum: 4)
    
    var currentPlayerTuple: (home: Bool, index: Int)? {
        didSet(oldTuple) {
            delegate?.didSetCurrentPlayerTuple(oldTuple: oldTuple, newTuple: currentPlayerTuple)
            if let playerTuple = currentPlayerTuple, let stat = currentStat {
                delegate?.didSetPlayerAndStat(playerTuple: playerTuple, stat: stat)
            }
        }
    }
    var currentStat: Stat.Score? {
        didSet(oldStat) {
            delegate?.didSetCurrentStat(oldStat: oldStat, newStat: currentStat)
            if let playerTuple = currentPlayerTuple, let stat = currentStat {
                delegate?.didSetPlayerAndStat(playerTuple: playerTuple, stat: stat)
            }
        }
    }
    
    var records: [RecordModel] = []
    func addRecords() {
        guard let playerTuple = currentPlayerTuple, let stat = currentStat else {
            return
        }
        let team = playerTuple.home ? homeTeam : awayTeam
        let record = Record(quarter: timeManager.currentTime,
                            home: playerTuple.home,
                            team: team,
                            player: team.players[playerTuple.index],
                            stat: stat)
        records.append(record)
        print(record)
    }
}
