//
//  HomeProtocol.swift
//  WannaBasket
//
//  Created Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol HomeWireframeProtocol: class {
    static func createModule() -> UIViewController
    func presentModule(source: HomeViewProtocol, module: Module)
}

protocol HomeInteractorInputProtocol: class {
    
    var presenter: HomeInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol HomeInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol HomePresenterProtocol: class {
    
    var view: HomeViewProtocol? { get set }
    var wireframe: HomeWireframeProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func startButtonTapped()
    func didAddTeamButtonTap()
    func didTeamCellTap(at index: Int, onLeft: Bool)
    func didAddPlayerButtonTap(home: Bool)
    func didAddTeamCompleteButtonTap(name: String?)
    func didAddPlayerCompleteButtonTap(name: String?)
}

protocol HomeViewProtocol: class {

    var presenter: HomePresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    func updateTeams(_ teams: [Team])
    func highlightTeam(at index: Int, onLeft: Bool, bool: Bool)
    func updateHomeTeam(_ team: Team?)
    func updateAwayTeam(_ team: Team?)
    var showAddTeamView: Bool { get set }
    var showAddPlayerView: Bool { get set }
}
