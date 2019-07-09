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
    
    func didTapStartButton()
    func didTapNewTeamButton()
    func didTapNewPlayerButton(of home: Bool)
    
    func didTapTeamFormCompleteButton(name: String?)
    func didTapPlayerFormCompleteButton(name: String?)
    
    func didDeleteTeamAction(at index: Int)
    func didDeletePlayerAction(at index: Int, of home: Bool)
    func didDequeueTeamCell() -> (home: Int?, away: Int?)
    func didTapTeamCell(at index: Int, onLeft: Bool)
}

protocol HomeViewProtocol: class {

    var presenter: HomePresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    func updateTeamTableView(with teams: [Team])
    func updateHomeTeam(_ team: Team?)
    func updateAwayTeam(_ team: Team?)
    
    func highlightTeam(at index: Int, onLeft: Bool, bool: Bool)
    
    func enableGameStartButton(bool: Bool)
    func enableHomePlayerAddButton(bool: Bool)
    func enableAwayPlayerAddButton(bool: Bool)
    
    var showTeamFormView: Bool { get set }
    var showPlayerFormView: Bool { get set }
}
