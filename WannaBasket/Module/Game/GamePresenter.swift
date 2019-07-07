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
        didSet(oldVal) {
            game.time.delegate = self
        }
    }
    var currentPlayerIndexPath: (home: Bool, indexPath: IndexPath)?
    var currentStat: Stat.Score?
    
    func viewDidLoad() {
        view?.updateHomeTeam(game.homeTeam)
        view?.updateAwayTeam(game.awayTeam)
        view?.updateQuarter(quarterNum: game.time.currentQuarterNum)
    }
    
    func didPlayerCellTap(of home: Bool, at indexPath: IndexPath) {
        if let current = currentPlayerIndexPath {
            currentPlayerIndexPath = nil
            view?.highlightPlayerCell(of: current.home, at: current.indexPath, bool: false)
            if current == (home, indexPath) { return }
        }
        currentPlayerIndexPath = (home, indexPath)
        view?.highlightPlayerCell(of: home, at: indexPath, bool: true)
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
            game.time.addGameClock(60.0)
        case .GameMinMinus:
            game.time.addGameClock(-60.0)
        case .GameSecPlus:
            game.time.addGameClock(1.0)
        case .GameSecMinus:
            game.time.addGameClock(-1.0)
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
        if stat == nil {
            print("취소")
            return
        }
        if currentStat != nil {
            view?.highlightStatsCell(of: currentStat, bool: false)
            if currentStat == stat {
                currentStat = nil
                return
            }
        }
        currentStat = stat
        view?.highlightStatsCell(of: stat, bool: true)
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
