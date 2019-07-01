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
    var quarter: Quarter = .First
    
    func viewDidLoad() {
        view?.updateHomeTeam(game.homeTeam)
        view?.updateAwayTeam(game.awayTeam)
        view?.updateQuarter(quarter: quarter)
    }
    
    func didQuarterButtonTap() {
        view?.showQuarterSelectView(quarter: quarter, bool: true)
    }
    
    func didQuarterSelect(quarter: Quarter) {
        self.quarter = quarter
        view?.showQuarterSelectView(quarter: quarter, bool: false)
        view?.updateQuarter(quarter: quarter)
    }
}

extension GamePresenter: GameInteractorOutputProtocol {
    
}
