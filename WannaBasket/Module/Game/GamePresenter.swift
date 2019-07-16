//
//  GamePresenter.swift
//  WannaBasket
//
//  Created Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GamePresenter: GamePresenterProtocol {

    // --------------------------------------------------
    // MARK: Connect Module Components
    // --------------------------------------------------
    weak var view: GameViewProtocol?
    var interactor: GameInteractorInputProtocol?
    var wireframe: GameWireframeProtocol?
    
    // --------------------------------------------------
    // MARK: Manage Game Informations
    // --------------------------------------------------
    var game: (GameManageable & GameRecordable)!
    var isSubstituting: (home: Bool, away: Bool) = (false, false) {
        didSet(oldVal) {
            if oldVal.home != isSubstituting.home {
                if isSubstituting.home {
                    view?.updatePlayerTableView(players: game.team.home.players, of: true)
                } else {
                    view?.updatePlayerTableView(players: game.floorPlayers.home, of: true)
                }
                view?.updateSubstituteButton(bool: isSubstituting.home, of: true)
                view?.enableScrollingPlayerTableView(of: true, bool: isSubstituting.home)
            }
            if oldVal.away != isSubstituting.away {
                if isSubstituting.away {
                    view?.updatePlayerTableView(players: game.team.away.players, of: false)
                } else {
                    view?.updatePlayerTableView(players: game.floorPlayers.away, of: false)
                }
                view?.updateSubstituteButton(bool: isSubstituting.away, of: false)
                view?.enableScrollingPlayerTableView(of: false, bool: isSubstituting.away)
            }
        }
    }
    
    // --------------------------------------------------
    // MARK: Game View Events
    // --------------------------------------------------
    func viewDidLoad() {
        game.time.delegate = self
        game.recordableDelegate = self
        game.manageableDelegate = self
        for i in 0...4 {
            game.substitutePlayer(index: i, of: true)
            game.substitutePlayer(index: i, of: false)
        }
        
        view?.updateTeamNameLabel(name: game.team.home.name, of: true)
        view?.updateTeamNameLabel(name: game.team.away.name, of: false)
        view?.updatePlayerTableView(players: game.floorPlayers.home, of: true)
        view?.updatePlayerTableView(players: game.floorPlayers.away, of: false)
        view?.updateQuarterLabel(game.time.currentQuarter)
    }
    
    // --------------------------------------------------
    // MARK: Quarter View Events
    // --------------------------------------------------
    func didTapQuarterLabel() {
        view?.showQuarterSelectView(maxRegularQuarterNum: game.time.maxRegularQuarterNum,
                                    overtimeQuarterCount: 0,
                                    currentQuarter: game.time.currentQuarter,
                                    bool: true)
    }
    
    func didSelectQuarter(quarterType: Quarter) {
        game.time.updateQuarter(quarter: quarterType)
        view?.showQuarterSelectView(maxRegularQuarterNum: game.time.maxRegularQuarterNum,
                                    overtimeQuarterCount: 0,
                                    currentQuarter: game.time.currentQuarter,
                                    bool: false)
    }
    
    func didSelectRecord() {
        game.time.isGameClockRunning = false
        game.time.isShotClockRunning = false
        view?.showQuarterSelectView(maxRegularQuarterNum: game.time.maxRegularQuarterNum,
                                    overtimeQuarterCount: 0,
                                    currentQuarter: game.time.currentQuarter,
                                    bool: false)
        wireframe?.presentModule(source: view!, module: Module.Record(game: game as! Game))
    }
    
    func didSelectExit() {
        view?.dismiss(animated: true) {}
    }
    
    // --------------------------------------------------
    // MARK: Clock View Events
    // --------------------------------------------------
    func didTapGameClockLabel() {
        game.time.isGameClockRunning = !game.time.isGameClockRunning
    }
    
    func didTapShotClockLabel() {
        game.time.isShotClockRunning = !game.time.isShotClockRunning
    }
    
    func didTapReset14Button() {
        game.time.resetShotClock(14.0)
    }
    
    func didTapReset24Button() {
        game.time.resetShotClock(24.0)
    }
    
    func didTapClockControlButton(control: ClockControl) {
        switch control {
        case .GameMinPlus:
            let bool = (game.time.currentTime.gameClock > 60.0)
            game.time.addGameClock(bool ? 60.0 : 1.0)
        case .GameMinMinus:
            let bool = (game.time.currentTime.gameClock > 61.0)
            game.time.addGameClock(bool ? -60.0 : -1.0)
        case .GameSecPlus:
            let bool = (game.time.currentTime.gameClock >= 60.0)
            game.time.addGameClock(bool ? 1.0 : 0.1)
        case .GameSecMinus:
            let bool = (game.time.currentTime.gameClock > 60.0)
            game.time.addGameClock(bool ? -1.0 : -0.1)
        case .ShotSecPlus:
            game.time.addShotClock(1.0)
        case .ShotSecMinus:
            game.time.addShotClock(-1.0)
        case .ShotPointPlus:
            game.time.addShotClock(0.1)
        case .ShotPointMinus:
            game.time.addShotClock(-0.1)
        }
    }
    
    // --------------------------------------------------
    // MARK: Stat View Events
    // --------------------------------------------------
    func didSelectStat(stat: Stat) {
        if let current = game.currentStat, current == stat {
            game.currentStat = nil
        } else {
            game.currentStat = stat
        }
    }
    
    func didSelectUndo() {
        game.removeLastRecord()
    }
    
    // --------------------------------------------------
    // MARK: Player Table View Events
    // --------------------------------------------------
    func didDequeuePlayerCell(of home: Bool) -> [Int] {
        let isSbsting = home ? isSubstituting.home : isSubstituting.away
        if isSbsting {
            return home ? game.floorPlayerIndexes.home : game.floorPlayerIndexes.away
        } else {
            return []
        }
    }
    
    func didTapPlayerCell(at index: Int, of home: Bool) {
        let isSbsting = home ? isSubstituting.home : isSubstituting.away
        if isSbsting {
            game.substitutePlayer(index: index, of: home)
        } else {
            if let current = game.currentPlayerTuple, current == (home, index) {
                game.currentPlayerTuple = nil
            } else {
                game.currentPlayerTuple = (home, index)
            }
        }
    }
    
    func didTapSubstituteButton(of home: Bool) {
        if let currentPlayerHome = game.currentPlayerTuple?.home, currentPlayerHome == home {
            game.currentPlayerTuple = nil
        }
        if home { isSubstituting.home = !isSubstituting.home }
        else { isSubstituting.away = !isSubstituting.away }
    }
}

// --------------------------------------------------
// MARK: Game Manageable Delegate
// --------------------------------------------------
extension GamePresenter: GameManageableDelegate {
    
    func didSubstitutePlayer(index: Int, of home: Bool, floor: Bool) {
        view?.highlightPlayerCell(at: index, of: home, bool: floor)
    }
    
    func didSetCurrentPlayerTuple(oldTuple: (home: Bool, index: Int)?,
                                  newTuple: (home: Bool, index: Int)?) {
        if let oldTuple = oldTuple {
            view?.highlightPlayerCell(at: oldTuple.index, of: oldTuple.home, bool: false)
        }
        if let newTuple = newTuple {
            view?.highlightPlayerCell(at: newTuple.index, of: newTuple.home, bool: true)
        }
    }
    
    func didSetCurrentStat(oldStat: Stat?, newStat: Stat?) {
        if let oldStat = oldStat {
            view?.highlightStatCell(of: oldStat, bool: false)
        }
        if let newStat = newStat {
            view?.highlightStatCell(of: newStat, bool: true)
        }
    }
    
    func didSetPlayerAndStat(playerTuple: (home: Bool, index: Int), stat: Stat) {
        view?.blinkPlayerCell(at: playerTuple.index, of: playerTuple.home) { bool in
            self.game.currentPlayerTuple = nil
        }
        view?.blinkStatCell(of: stat) { bool in
            self.game.currentStat = nil
        }
    }
}

// --------------------------------------------------
// MARK: Game Recordable Delegate
// --------------------------------------------------
extension GamePresenter: GameRecordableDelegate {
    
    func didAddRecord(record: Record, score: (home: Int, away: Int)) {
        switch record.stat {
        case .Score(_):
            let home = record.home
            let score = home ? score.home : score.away
            view?.updateTeamScoreLabel(score: score, of: home)
            view?.blinkScoreLabel(of: home, completion: nil)
        case .Assist :
            break
        case .Block :
            break
        case .Rebound :
            break
        case .Foul:
            break
        }
    }
    
    func didRemoveLastRecord(record: Record, score: (home: Int, away: Int)) {
        switch record.stat {
        case .Score(_):
            let home = record.home
            let score = home ? score.home : score.away
            view?.updateTeamScoreLabel(score: score, of: home)
            view?.blinkScoreLabel(of: home, completion: nil)
            view?.blinkStatCell(of: nil, completion: nil)
        case .Assist :
            break
        case .Block :
            break
        case .Rebound :
            break
        case .Foul:
            break
        }
    }
}

// --------------------------------------------------
// MARK: Game Time Delegate
// --------------------------------------------------
extension GamePresenter: GameTimeDelegate {
    
    func didSetQuarter(quarter: Quarter) {
        view?.updateQuarterLabel(quarter)
    }
    
    func didSetGameClock(gameClock: Float, isRunning: Bool) {
        view?.updateGameClockLabel(gameClock, isRunning: isRunning)
    }
    
    func didSetShotClock(shotClock: Float, isRunning: Bool) {
        view?.updateShotClockLabel(shotClock, isRunning: isRunning)
    }
}

// --------------------------------------------------
// MARK: Game Interactor Output Protocol
// --------------------------------------------------
extension GamePresenter: GameInteractorOutputProtocol {
    
}
