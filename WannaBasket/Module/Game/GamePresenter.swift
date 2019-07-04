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
    var gameTime = GameTime(numberOfQuarter: 4)
    
    func viewDidLoad() {
        view?.updateHomeTeam(game.homeTeam)
        view?.updateAwayTeam(game.awayTeam)
        view?.updateQuarter(quarterNum: gameTime.currentQuarterNum)
        gameTime.delegate = self
    }
    
    func didQuarterLabelTap() {
        
    }
    
    func didGameClockLabelTap() {
        gameTime.isGameClockRunning = !gameTime.isGameClockRunning
    }
    
    func didShotClockLabelTap() {
        gameTime.isShotClockRunning = !gameTime.isShotClockRunning
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
