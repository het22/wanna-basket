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
    func didSetCurrentStat(oldStat: Stat?, newStat: Stat?)
    func didSetPlayerAndStat(playerTuple: (home: Bool, index: Int), stat: Stat)
    
    func didSubstitutePlayer(index: Int, of home: Bool, floor: Bool)
    
    func didAddRecord(record: RecordModel)
    func didRemoveLastRecord(record: RecordModel)
}

class Game {
    
    var delegate: GameDelegate?
    
    var timeManager: TimeManager = TimeManager(maxRegularQuarterNum: 4)
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
    
    init(homeTeam: Team, awayTeam: Team) {
        self.teams = (homeTeam, awayTeam)
    }
    
    var currentPlayerTuple: (home: Bool, index: Int)? {
        didSet(oldTuple) {
            delegate?.didSetCurrentPlayerTuple(oldTuple: oldTuple, newTuple: currentPlayerTuple)
            if let playerTuple = currentPlayerTuple, let stat = currentStat {
                delegate?.didSetPlayerAndStat(playerTuple: playerTuple, stat: stat)
            }
        }
    }
    var currentStat: Stat? {
        didSet(oldStat) {
            delegate?.didSetCurrentStat(oldStat: oldStat, newStat: currentStat)
            if let playerTuple = currentPlayerTuple, let stat = currentStat {
                delegate?.didSetPlayerAndStat(playerTuple: playerTuple, stat: stat)
            }
        }
    }
    
    let maxFloorPlayerCount = 5
    var floorPlayerIndexes: (home: [Int], away: [Int]) = ([],[])
    var floorPlayers: (home: [Player], away: [Player]) {
        let homeFloorPlayers = teams.home.getPlayers(with: floorPlayerIndexes.home)
        let awayFloorPlayers = teams.away.getPlayers(with: floorPlayerIndexes.away)
        return (homeFloorPlayers, awayFloorPlayers)
    }
    func substitutePlayer(index: Int, of home: Bool) {
        var indexes = home ? floorPlayerIndexes.home : floorPlayerIndexes.away
        if let i = indexes.firstIndex(of: index) {
            indexes.remove(at: i)
            delegate?.didSubstitutePlayer(index: index, of: home, floor: false)
        } else {
            if indexes.count <= maxFloorPlayerCount {
                indexes.append(index)
                delegate?.didSubstitutePlayer(index: index, of: home, floor: true)
            }
        }
        if home { floorPlayerIndexes.home = indexes }
        else { floorPlayerIndexes.away = indexes }
    }
    
    var records: [RecordModel] = []
    func addRecord(playerTuple: (home: Bool, index: Int), stat: Stat) {
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
