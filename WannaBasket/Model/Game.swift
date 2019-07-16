//
//  Game.swift
//  WannaBasket
//
//  Created by Het Song on 15/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

// --------------------------------------------------
// MARK: Game Model Protocol
// --------------------------------------------------
protocol GameModel {
    var team: (home: Team, away: Team) { get set }
    var players: (home: [Player], away: [Player]) { get set }
    var records: [Record] { get set }
}

// --------------------------------------------------
// MARK: Game Class
// --------------------------------------------------
class Game: GameModel {
    
    // --------------------------------------------------
    // MARK: Game Model
    // --------------------------------------------------
    var team: (home: Team, away: Team)
    var players: (home: [Player], away: [Player]) = ([],[])
    var records: [Record] = []
    
    init(home: Team, away: Team) {
        self.team.home = home
        self.team.away = away
    }
    
    // --------------------------------------------------
    // MARK: Game Configurable
    // --------------------------------------------------
    weak var congifureDelegate: GameConfigurableDelegate?
    
    var maxFloorPlayerCount: Int = 5
    var maxRegularQuarterCount: Int = 4
    var maxOverTimeQuarterCount: Int = 0
    
    // --------------------------------------------------
    // MARK: Game Manageable
    // --------------------------------------------------
    weak var manageableDelegate: GameManageableDelegate?
    
    var time: TimeManager = TimeManager(maxRegularQuarterNum: 4)
    
    var floorPlayerIndexes: (home: [Int], away: [Int]) = ([],[])
    
    var currentPlayerTuple: (home: Bool, index: Int)? {
        didSet(oldTuple) {
            manageableDelegate?.didSetCurrentPlayerTuple(oldTuple: oldTuple, newTuple: currentPlayerTuple)
            if let playerTuple = currentPlayerTuple, let stat = currentStat {
                addRecord(playerTuple: playerTuple, stat: stat)
                manageableDelegate?.didSetPlayerAndStat(playerTuple: playerTuple, stat: stat)
            }
        }
    }
    var currentStat: Stat? {
        didSet(oldStat) {
            manageableDelegate?.didSetCurrentStat(oldStat: oldStat, newStat: currentStat)
            if let playerTuple = currentPlayerTuple, let stat = currentStat {
                addRecord(playerTuple: playerTuple, stat: stat)
                manageableDelegate?.didSetPlayerAndStat(playerTuple: playerTuple, stat: stat)
            }
        }
    }
    
    // --------------------------------------------------
    // MARK: Game Recordable
    // --------------------------------------------------
    var recordableDelegate: GameRecordableDelegate?
}



// --------------------------------------------------
// MARK: Game Configurable Protocol & Extension
// --------------------------------------------------
protocol GameConfigurableDelegate: class { }

protocol GameConfigurable {
    var congifureDelegate: GameConfigurableDelegate? { get set }
    
    var maxFloorPlayerCount: Int { get set }
    var maxRegularQuarterCount: Int { get set }
    var maxOverTimeQuarterCount: Int { get set }
}

extension Game: GameConfigurable {
    
}



// --------------------------------------------------
// MARK: Game Manageable Protocol & Extension
// --------------------------------------------------
protocol GameManageableDelegate: class {
    func didSubstitutePlayer(index: Int, of home: Bool, floor: Bool)
    
    func didSetCurrentPlayerTuple(oldTuple: (home: Bool, index: Int)?, newTuple: (home: Bool, index: Int)?)
    func didSetCurrentStat(oldStat: Stat?, newStat: Stat?)
    func didSetPlayerAndStat(playerTuple: (home: Bool, index: Int), stat: Stat)
}

protocol GameManageable {
    var manageableDelegate: GameManageableDelegate? { get set }
    
    var time: TimeManager { get set }
    var team: (home: Team, away: Team) { get }
    var players: (home: [Player], away: [Player]) { get }
    
    var floorPlayerIndexes: (home: [Int], away: [Int]) { get set }
    var floorPlayers: (home: [Player], away: [Player]) { get }
    func substitutePlayer(index: Int, of home: Bool)
    
    var currentPlayerTuple: (home: Bool, index: Int)? { get set }
    var currentStat: Stat? { get set }
}

extension Game: GameManageable {
    
    var floorPlayers: (home: [Player], away: [Player]) {
        let homeFloorPlayers = team.home.getPlayers(with: floorPlayerIndexes.home)
        let awayFloorPlayers = team.away.getPlayers(with: floorPlayerIndexes.away)
        return (homeFloorPlayers, awayFloorPlayers)
    }
    
    func substitutePlayer(index: Int, of home: Bool) {
        if index >= (home ? team.home.players.count : team.away.players.count) { return }
        var indexes = home ? floorPlayerIndexes.home : floorPlayerIndexes.away
        if let i = indexes.firstIndex(of: index) {
            indexes.remove(at: i)
            manageableDelegate?.didSubstitutePlayer(index: index, of: home, floor: false)
        } else {
            if indexes.count < maxFloorPlayerCount {
                indexes.append(index)
                manageableDelegate?.didSubstitutePlayer(index: index, of: home, floor: true)
            }
        }
        if home { floorPlayerIndexes.home = indexes }
        else { floorPlayerIndexes.away = indexes }
    }
}



// --------------------------------------------------
// MARK: Game Recordable Protocol & Extension
// --------------------------------------------------
protocol GameRecordableDelegate: class {
    func didAddRecord(record: Record, score: (home: Int, away: Int))
    func didRemoveLastRecord(record: Record, score: (home: Int, away: Int))
}

protocol GameRecordable {
    var recordableDelegate: GameRecordableDelegate? { get set }
    
    var team: (home: Team, away: Team) { get }
    var records: [Record]  { get set }
    func addRecord(playerTuple: (home: Bool, index: Int), stat: Stat)
    func removeLastRecord()
    
    var score: (home: Int, away: Int)  { get }
}

extension Game: GameRecordable {
    
    var score: (home: Int, away: Int) {
        return records.reduce((0,0)) { (scores, record) -> (Int, Int) in
            if case let .Score(Score) = record.stat {
                let score = Score.rawValue
                let home = record.home
                return home ? (scores.0 + score, scores.1) : (scores.0, scores.1 + score)
            }
            return scores
        }
    }
    
    func addRecord(playerTuple: (home: Bool, index: Int), stat: Stat) {
        let team = playerTuple.home ? self.team.home : self.team.away
        let record = Record(quarter: time.currentTime,
                            home: playerTuple.home,
                            team: team,
                            player: team.players[playerTuple.index],
                            stat: stat)
        records.append(record)
        recordableDelegate?.didAddRecord(record: record, score: score)
    }
    
    func removeLastRecord() {
        if records.count > 0 {
            let record = records.removeLast()
            recordableDelegate?.didRemoveLastRecord(record: record, score: score)
        }
    }
}


