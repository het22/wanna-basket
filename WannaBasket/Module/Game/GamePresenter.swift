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
        }
    }
    
    func viewDidLoad() {
        view?.updateHomeTeam(game.homeTeam)
        view?.updateAwayTeam(game.awayTeam)
        view?.updateQuarterLabel(game.timeManager.currentQuarter)
    }
    
    func didPlayerCellTap(at index: Int, of home: Bool) {
        if let current = game.currentPlayerTuple, current == (home, index) {
            game.currentPlayerTuple = nil
        } else {
            game.currentPlayerTuple = (home, index)
        }
    }
    
    func didBenchButtonTap(of home: Bool) {
        print("bench")
    }
    
    func didQuarterLabelTap() {
        view?.showQuarterSelectView(maxRegularQuarterNum: game.timeManager.maxRegularQuarterNum,
                                    overtimeQuarterCount: 0,
                                    currentQuarter: game.timeManager.currentQuarter,
                                    bool: true)
    }
    
    func didQuarterSelect(quarterType: Quarter) {
        game.timeManager.updateQuarter(quarter: quarterType)
        view?.showQuarterSelectView(maxRegularQuarterNum: game.timeManager.maxRegularQuarterNum,
                                    overtimeQuarterCount: 0,
                                    currentQuarter: game.timeManager.currentQuarter,
                                    bool: false)
    }
    
    func didExitSelect() {
        view?.dismiss(animated: true, completion: nil)
    }
    
    func didGameClockLabelTap() {
        game.timeManager.isGameClockRunning = !game.timeManager.isGameClockRunning
    }
    
    func didShotClockLabelTap() {
        game.timeManager.isShotClockRunning = !game.timeManager.isShotClockRunning
    }
    
    func didClockControlButtonTap(control: ClockControl) {
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
    
    func didReset14ButtonTap() {
        game.timeManager.resetShotClock(14.0)
    }
    
    func didReset24ButtonTap() {
        game.timeManager.resetShotClock(24.0)
    }
    
    func didStatSelect(stat: Stat.Score) {
        if let current = game.currentStat, current == stat {
            game.currentStat = nil
        } else {
            game.currentStat = stat
        }
    }
    
    func didUndoSelect() {
        print("undo")
    }
}

extension GamePresenter: GameDelegate {
    
    func didCurrentPlayerTupleSet(oldTuple: (home: Bool, index: Int)?,
                                  newTuple: (home: Bool, index: Int)?) {
        if let oldTuple = oldTuple {
            view?.highlightPlayerCell(at: oldTuple.index, of: oldTuple.home, bool: false)
        }
        if let newTuple = newTuple {
            view?.highlightPlayerCell(at: newTuple.index, of: newTuple.home, bool: true)
        }
    }
    
    func didCurrentStatSet(oldStat: Stat.Score?, newStat: Stat.Score?) {
        if let oldStat = oldStat {
            view?.highlightStatCell(of: oldStat, bool: false)
        }
        if let newStat = newStat {
            view?.highlightStatCell(of: newStat, bool: true)
        }
    }
    
    func didPlayerAndStatSet(playerTuple: (home: Bool, index: Int), stat: Stat.Score) {
        game.addRecords()
        view?.blinkPlayerCell(at: playerTuple.index, of: playerTuple.home) { bool in
            self.game.currentPlayerTuple = nil
        }
        view?.blinkStatCell(of: stat) { bool in
            self.game.currentStat = nil
        }
    }
}

extension GamePresenter: GameTimeDelegate {
    
    func didQuarterUpdate(quarter: Quarter) {
        view?.updateQuarterLabel(quarter)
    }
    
    func didGameClockUpdate(gameClock: Float, isRunning: Bool) {
        view?.updateGameClockLabel(gameClock, isRunning: isRunning)
    }
    
    func didShotClockUpdate(shotClock: Float, isRunning: Bool) {
        view?.updateShotClockLabel(shotClock, isRunning: isRunning)
    }
}

extension GamePresenter: GameInteractorOutputProtocol {
    
}
