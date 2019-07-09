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
    
    func didAddRecord(record: RecordModel)
    func didRemoveLastRecord(record: RecordModel)
}

class Game {
    
    var delegate: GameDelegate?
    
    var teams: (home: Team, away: Team)
    var scores: (home: Int, away: Int) {
        return records.reduce((0,0)) { (scores, record) -> (Int, Int) in
            let score = record.stat.rawValue
            let home = record.home
            return home ? (scores.0 + score, scores.1) : (scores.0, scores.1 + score)
        }
    }
    
    init(homeTeam: Team, awayTeam: Team) {
        self.teams = (homeTeam, awayTeam)
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
    func addRecord(playerTuple: (home: Bool, index: Int), stat: Stat.Score) {
        let team = playerTuple.home ? teams.home : teams.away
        let record = Record(quarter: timeManager.currentTime,
                            home: playerTuple.home,
                            team: team,
                            player: team.players[playerTuple.index],
                            stat: stat)
        records.append(record)
        delegate?.didAddRecord(record: record)
    }
    
    func removeLastRecord() {
        if records.count > 0 {
            let record = records.removeLast()
            delegate?.didRemoveLastRecord(record: record)
        }
    }
}
