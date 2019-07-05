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
    
    func didReset14ButtonTap() {
        game.time.resetShotClock(14.0)
    }
    
    func didReset24ButtonTap() {
        game.time.resetShotClock(24.0)
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
