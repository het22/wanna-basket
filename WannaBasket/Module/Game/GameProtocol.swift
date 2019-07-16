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
    func presentModule(source: GameViewProtocol, module: Module)
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
    
    func didTapQuarterLabel()
    func didSelectQuarter(quarterType: Quarter)
    func didSelectRecord()
    func didSelectExit()
    
    func didTapGameClockLabel()
    func didTapShotClockLabel()
    func didTapReset14Button()
    func didTapReset24Button()
    func didTapClockControlButton(control: ClockControl)
    
    func didSelectStat(stat: Stat)
    func didSelectUndo()
    
    func didDequeuePlayerCell(of home: Bool) -> [Int]
    func didTapPlayerCell(at index: Int, of home: Bool)
    func didTapSubstituteButton(of home: Bool)
}

protocol GameViewProtocol: class {

    var presenter: GamePresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    func updatePlayerTableView(players: [Player], of home: Bool)
    func updateTeamNameLabel(name: String, of home: Bool)
    func updateTeamScoreLabel(score: Int, of home: Bool)
    func updateSubstituteButton(bool: Bool, of home: Bool)
    
    func showQuarterSelectView(maxRegularQuarterNum: Int, overtimeQuarterCount: Int,currentQuarter: Quarter, bool: Bool)
    func updateQuarterLabel(_ quarter: Quarter)
    func updateGameClockLabel(_ gameClock: Float, isRunning: Bool)
    func updateShotClockLabel(_ shotClock: Float, isRunning: Bool)
    
    func highlightPlayerCell(at index: Int, of home: Bool, bool: Bool)
    func highlightStatCell(of stat: Stat?, bool: Bool)
    
    func blinkScoreLabel(of home: Bool, completion: ((Bool)->Void)?)
    func blinkPlayerCell(at index: Int, of home: Bool, completion: ((Bool)->Void)?)
    func blinkStatCell(of stat: Stat?, completion: ((Bool)->Void)?)
    
    func enableScrollingPlayerTableView(of home: Bool, bool: Bool)
    
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}
