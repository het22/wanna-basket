//
//  GameProtocol.swift
//  WannaBasket
//
//  Created Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol GameWireframeProtocol: class {
    static func createModule(with game: Game) -> UIViewController
}

protocol GameInteractorInputProtocol: class {
    
    var presenter: GameInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol GameInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol GamePresenterProtocol: class {
    
    var view: GameViewProtocol? { get set }
    var wireframe: GameWireframeProtocol? { get set }
    var interactor: GameInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func didQuarterLabelTap()
    func didGameClockLabelTap()
    func didShotClockLabelTap()
}

protocol GameViewProtocol: class {

    var presenter: GamePresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    func updateHomeTeam(_ team: Team)
    func updateAwayTeam(_ team: Team)
    func updateGameClock(gameClock: Float, isRunning: Bool)
    func updateShotClock(shotClock: Float, isRunning: Bool)
    func updateQuarter(quarterNum: Int)
}
