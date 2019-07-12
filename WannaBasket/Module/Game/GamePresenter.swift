//
//  GamePresenter.swift
//  WannaBasket
//
//  Created Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GamePresenter: GamePresenterProtocol {

    weak var view: GameViewProtocol?
    var interactor: GameInteractorInputProtocol?
    var wireframe: GameWireframeProtocol?
    
    var game: Game! {
        didSet {
            game.delegate = self
            game.timeManager.delegate = self
            for i in 0...4 {
                game.substitutePlayer(index: i, of: true)
                game.substitutePlayer(index: i, of: false)
            }
        }
    }
    
    var isSubstituting: (home: Bool, away: Bool) = (false, false) {
        didSet(oldVal) {
            if oldVal.home != isSubstituting.home {
                if isSubstituting.home {
                    view?.updatePlayerTableView(players: game.teams.home.players, of: true)
                } else {
                    view?.updatePlayerTableView(players: game.floorPlayers.home, of: true)
                }
                view?.updateSubstituteButton(bool: isSubstituting.home, of: true)
                view?.enableScrollingPlayerTableView(of: true, bool: isSubstituting.home)
            }
            if oldVal.away != isSubstituting.away {
                if isSubstituting.away {
                    view?.updatePlayerTableView(players: game.teams.away.players, of: false)
                } else {
                    view?.updatePlayerTableView(players: game.floorPlayers.away, of: false)
                }
                view?.updateSubstituteButton(bool: isSubstituting.away, of: false)
                view?.enableScrollingPlayerTableView(of: false, bool: isSubstituting.away)
            }
        }
    }
    
    func viewDidLoad() {
        view?.updateTeamNameLabel(name: game.teams.home.name, of: true)
        view?.updateTeamNameLabel(name: game.teams.away.name, of: false)
        view?.updatePlayerTableView(players: game.floorPlayers.home, of: true)
        view?.updatePlayerTableView(players: game.floorPlayers.away, of: false)
        view?.updateQuarterLabel(game.timeManager.currentQuarter)
    }
    
    func didDequeuePlayerCell(of home: Bool) -> [Int] {
        let isSbsting = home ? isSubstituting.home : isSubstituting.away
        if isSbsting {
            return home ? game.floorPlayerIndexes.home : game.floorPlayerIndexes.away
        } else {
//            if let index = game.currentPlayerTuple?.index {
//                return [index]
//            } else {
//                return []
//            }
            return []
        }
    }
    
    func didTapSubstituteButton(of home: Bool) {
        if let currentPlayerHome = game.currentPlayerTuple?.home, currentPlayerHome == home {
            game.currentPlayerTuple = nil
        }
        if home { isSubstituting.home = !isSubstituting.home }
        else { isSubstituting.away = !isSubstituting.away }
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
    
    func didTapQuarterLabel() {
        view?.showQuarterSelectView(maxRegularQuarterNum: game.timeManager.maxRegularQuarterNum,
                                    overtimeQuarterCount: 0,
                                    currentQuarter: game.timeManager.currentQuarter,
                                    bool: true)
    }
    
    func didSelectQuarter(quarterType: Quarter) {
        game.timeManager.updateQuarter(quarter: quarterType)
        view?.showQuarterSelectView(maxRegularQuarterNum: game.timeManager.maxRegularQuarterNum,
                                    overtimeQuarterCount: 0,
                                    currentQuarter: game.timeManager.currentQuarter,
                                    bool: false)
    }
    
    func didSelectExit() {
        view?.dismiss(animated: true, completion: nil)
    }
    
    func didTapGameClockLabel() {
        game.timeManager.isGameClockRunning = !game.timeManager.isGameClockRunning
    }
    
    func didTapShotClockLabel() {
        game.timeManager.isShotClockRunning = !game.timeManager.isShotClockRunning
    }
    
    func didTapClockControlButton(control: ClockControl) {
        switch control {
        case .GameMinPlus:
            let bool = (game.timeManager.currentTime.gameClock > 60.0)
            game.timeManager.addGameClock(bool ? 60.0 : 1.0)
        case .GameMinMinus:
            let bool = (game.timeManager.currentTime.gameClock > 61.0)
            game.timeManager.addGameClock(bool ? -60.0 : -1.0)
        case .GameSecPlus:
            let bool = (game.timeManager.currentTime.gameClock >= 60.0)
            game.timeManager.addGameClock(bool ? 1.0 : 0.1)
        case .GameSecMinus:
            let bool = (game.timeManager.currentTime.gameClock > 60.0)
            game.timeManager.addGameClock(bool ? -1.0 : -0.1)
        case .ShotSecPlus:
            game.timeManager.addShotClock(1.0)
        case .ShotSecMinus:
            game.timeManager.addShotClock(-1.0)
        case .ShotPointPlus:
            game.timeManager.addShotClock(0.1)
        case .ShotPointMinus:
            game.timeManager.addShotClock(-0.1)
        }
    }
    
    func didTapReset14Button() {
        game.timeManager.resetShotClock(14.0)
    }
    
    func didTapReset24Button() {
        game.timeManager.resetShotClock(24.0)
    }
    
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
}

extension GamePresenter: GameDelegate {
    
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
        game.addRecord(playerTuple: playerTuple, stat: stat)
        view?.blinkPlayerCell(at: playerTuple.index, of: playerTuple.home) { bool in
            self.game.currentPlayerTuple = nil
        }
        view?.blinkStatCell(of: stat) { bool in
            self.game.currentStat = nil
        }
    }
    
    func didSubstitutePlayer(index: Int, of home: Bool, floor: Bool) {
        view?.highlightPlayerCell(at: index, of: home, bool: floor)
    }
    
    func didAddRecord(record: RecordModel) {
        switch record.stat {
        case .Score(_):
            let home = record.home
            let score = home ? game.scores.home : game.scores.away
            view?.updateTeamScoreLabel(score: score, of: home)
            view?.blinkScoreLabel(of: home, completion: nil)
        case .Assist :
            break
        case .Block :
            break
        case .Rebound :
            break
        }
    }
    
    func didRemoveLastRecord(record: RecordModel) {
        switch record.stat {
        case .Score(_):
            let home = record.home
            let score = home ? game.scores.home : game.scores.away
            view?.updateTeamScoreLabel(score: score, of: home)
            view?.blinkScoreLabel(of: home, completion: nil)
            view?.blinkStatCell(of: nil, completion: nil)
        case .Assist :
            break
        case .Block :
            break
        case .Rebound :
            break
        }
    }
}

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

extension GamePresenter: GameInteractorOutputProtocol {
    
}
