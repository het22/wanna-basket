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
    
    func didTapPlayerCell(at index: Int, of home: Bool)
    func didTapBenchButton(of home: Bool)
    
    func didTapQuarterLabel()
    func didSelectQuarter(quarterType: Quarter)
    func didSelectExit()
    
    func didTapGameClockLabel()
    func didTapShotClockLabel()
    func didTapClockControlButton(control: ClockControl)
    func didTapReset14Button()
    func didTapReset24Button()
    
    func didSelectStat(stat: Stat.Score)
    func didSelectUndo()
}

protocol GameViewProtocol: class {

    var presenter: GamePresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
    
    func updatePlayerTableView(players: [Player], of home: Bool)
    func updateTeamNameLabel(name: String, of home: Bool)
    func updateTeamScoreLabel(score: Int, of home: Bool)
    
    func showQuarterSelectView(maxRegularQuarterNum: Int, overtimeQuarterCount: Int,currentQuarter: Quarter, bool: Bool)
    func updateQuarterLabel(_ quarter: Quarter)
    func updateGameClockLabel(_ gameClock: Float, isRunning: Bool)
    func updateShotClockLabel(_ shotClock: Float, isRunning: Bool)
    
    func highlightPlayerCell(at index: Int, of home: Bool, bool: Bool)
    func highlightStatCell(of stat: Stat.Score?, bool: Bool)
    func blinkPlayerCell(at index: Int, of home: Bool, completion: @escaping (Bool)->Void)
    func blinkStatCell(of stat: Stat.Score?, completion: @escaping (Bool)->Void)
}
