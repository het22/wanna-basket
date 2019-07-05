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
        view?.updateQuarter(quarter: game.time.currentQuarter)
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
        view?.showQuarterSelectView(currentQuarter: game.time.currentQuarter, bool: true)
    }
    
    func didQuarterButtonTap(quarter: Int?) {
        if let quarter = quarter {
            game.time.updateQuarter(newQuarter: quarter)
            view?.updateQuarter(quarter: quarter)
            view?.showQuarterSelectView(currentQuarter: quarter, bool: false)
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
        game.time.resetShotClock(shotClock: 14.0)
    }
    
    func didReset24ButtonTap() {
        game.time.resetShotClock(shotClock: 24.0)
    }
}

extension GamePresenter: GameTimeDelegate {
    
    func didGameClockUpdate(gameClock: Float, isRunning: Bool) {
        view?.updateGameClock(gameClock: gameClock, isRunning: isRunning)
    }
    
    func didShotClockUpdate(shotClock: Float, isRunning: Bool) {
        view?.updateShotClock(shotClock: shotClock, isRunning: isRunning)
    }
}

extension GamePresenter: GameInteractorOutputProtocol {
    
}
