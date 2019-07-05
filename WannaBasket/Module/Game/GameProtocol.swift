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
    
    func didPlayerCellTap(of home: Bool, at indexPath: IndexPath)
    func didBenchButtonTap(of home: Bool)
    
    func didQuarterLabelTap()
    func didQuarterSelect(quarterNum: Int?)
    
    func didGameClockLabelTap()
    func didShotClockLabelTap()
    func didReset14ButtonTap()
    func didReset24ButtonTap()
}

protocol GameViewProtocol: class {

    var presenter: GamePresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
    
    func updateHomeTeam(_ team: Team)
    func updateAwayTeam(_ team: Team)
    func highlightPlayerCell(of home: Bool, at indexPath: IndexPath, bool: Bool)
    
    func showQuarterSelectView(maxRegularQuarterNum: Int, overtimeQuarterCount: Int,currentQuarterNum: Int, bool: Bool)
    func updateQuarter(quarterNum: Int)
    
    func updateGameClock(_ gameClock: Float, isRunning: Bool)
    func updateShotClock(_ shotClock: Float, isRunning: Bool)
}
