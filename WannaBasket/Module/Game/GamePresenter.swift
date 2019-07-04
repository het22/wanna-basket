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
    
    var game: Game!
    lazy var gameTime: GameTime = {
        let time = GameTime(numberOfQuarter: 4)
        time.delegate = self
        return time
    }()
    
    func viewDidLoad() {
        view?.updateHomeTeam(game.homeTeam)
        view?.updateAwayTeam(game.awayTeam)
        view?.updateQuarter(quarter: gameTime.currentQuarter)
    }
    
    func didQuarterLabelTap() {
        view?.showQuarterSelectView(currentQuarter: gameTime.currentQuarter, bool: true)
    }
    
    func didQuarterButtonTap(quarter: Int?) {
        if let quarter = quarter {
            gameTime.updateQuarter(newQuarter: quarter)
            view?.updateQuarter(quarter: quarter)
            view?.showQuarterSelectView(currentQuarter: quarter, bool: false)
        } else {
            view?.dismiss(animated: true, completion: nil)
        }
    }
    
    func didGameClockLabelTap() {
        gameTime.isGameClockRunning = !gameTime.isGameClockRunning
    }
    
    func didShotClockLabelTap() {
        gameTime.isShotClockRunning = !gameTime.isShotClockRunning
    }
    
    func didReset14ButtonTap() {
        gameTime.resetShotClock(shotClock: 14.0)
    }
    
    func didReset24ButtonTap() {
        gameTime.resetShotClock(shotClock: 24.0)
    }
    
    func didPlayerCellTap(of home: Bool, at indexPath: IndexPath) {
        view?.highlightPlayerCell(of: home, at: indexPath, bool: true)
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
