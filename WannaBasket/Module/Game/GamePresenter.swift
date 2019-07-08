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
            game.time.delegate = self
        }
    }
    
    func viewDidLoad() {
        view?.updateHomeTeam(game.homeTeam)
        view?.updateAwayTeam(game.awayTeam)
        view?.updateQuarter(quarterNum: game.time.currentQuarterNum)
    }
    
    func didPlayerCellTap(at index: Int, of home: Bool) {
        if let current = game.currentPlayerTuple, current == (home, index) {
            game.currentPlayerTuple = nil
        } else {
            game.currentPlayerTuple = (home, index)
        }
    }
    
    func didBenchButtonTap(of home: Bool) {
        print(home)
    }
    
    func didQuarterLabelTap() {
        view?.showQuarterSelectView(maxRegularQuarterNum: game.time.maxRegularQuarterNum,
                                    overtimeQuarterCount: 0,
                                    currentQuarterNum: game.time.currentQuarterNum,
                                    bool: true)
    }
    
    func didQuarterSelect(quarterNum: Int?) {
        if let quarterNum = quarterNum {
            if quarterNum != game.time.currentQuarterNum {
                game.time.updateQuarter(quarterNum: quarterNum)
                view?.updateQuarter(quarterNum: quarterNum)
            }
            view?.showQuarterSelectView(maxRegularQuarterNum: game.time.maxRegularQuarterNum,
                                        overtimeQuarterCount: 0,
                                        currentQuarterNum: game.time.currentQuarterNum,
                                        bool: false)
        } else {
            view?.dismiss(animated: true, completion: nil)
        }
    }
    
    func didGameClockLabelTap() {
        game.time.isGameClockRunning = !game.time.isGameClockRunning
    }
    
    func didShotClockLabelTap() {
        game.time.isShotClockRunning = !game.time.isShotClockRunning
    }
    
    func didClockControlButtonTap(control: ClockControl) {
        switch control {
        case .GameMinPlus:
            let bool = (game.time.currentQuarter.gameClock > 60.0)
            game.time.addGameClock(bool ? 60.0 : 1.0)
        case .GameMinMinus:
            let bool = (game.time.currentQuarter.gameClock > 61.0)
            game.time.addGameClock(bool ? -60.0 : -1.0)
        case .GameSecPlus:
            let bool = (game.time.currentQuarter.gameClock >= 60.0)
            game.time.addGameClock(bool ? 1.0 : 0.1)
        case .GameSecMinus:
            let bool = (game.time.currentQuarter.gameClock > 60.0)
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
    
    func didReset14ButtonTap() {
        game.time.resetShotClock(14.0)
    }
    
    func didReset24ButtonTap() {
        game.time.resetShotClock(24.0)
    }
    
    func didStatSelect(stat: Stat.Score?) {
        if let current = game.currentStat, current == stat {
            game.currentStat = nil
        } else {
            game.currentStat = stat
        }
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
    
    func didCurrentStat(oldStat: Stat.Score?, newStat: Stat.Score?) {
        if let oldStat = oldStat {
            view?.highlightStatsCell(of: oldStat, bool: false)
        }
        if let newStat = newStat {
            view?.highlightStatsCell(of: newStat, bool: true)
        }
    }
    
    func didSelectPlayerAndStat(playerTuple: (home: Bool, index: Int), stat: Stat.Score) {
        print(playerTuple, stat)
        game.currentPlayerTuple = nil
        game.currentStat = nil
    }
}

extension GamePresenter: GameTimeDelegate {
    
    func didGameClockUpdate(gameClock: Float, isRunning: Bool) {
        view?.updateGameClock(gameClock, isRunning: isRunning)
    }
    
    func didShotClockUpdate(shotClock: Float, isRunning: Bool) {
        view?.updateShotClock(shotClock, isRunning: isRunning)
    }
}

extension GamePresenter: GameInteractorOutputProtocol {
    
}
