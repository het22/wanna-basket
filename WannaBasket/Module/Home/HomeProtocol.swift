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
    
    func didTapTeamFormCancelButton()
    func didTapTeamFormDeleteButton(index: Int)
    func didTapTeamFormCompleteButton(name: String)
    func didTapTeamFormEditButton(name: String, index: Int)
    
    func didTapPlayerFormCompleteButton(name: String?, number: Int?)
    func didTapPlayerNumberButton() -> [Bool]
    
    func didTapTeamCell(at index: Int, tapSection: TeamTableViewCell.Section)
    func didDeleteTeamAction(at index: Int)
    func didDequeueTeamCell() -> (home: Int?, away: Int?)
    
    func didDeletePlayerAction(at index: Int, of home: Bool)
}

protocol HomeViewProtocol: class {

    var presenter: HomePresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    func updateTeamTableView(teams: [Team])
    func updatePlayerTableView(players: [Player]?, of home: Bool)
    func updateTeamNameLabel(name: String?, of home: Bool)
    
    func highlightTeam(at index: Int, onLeft: Bool, bool: Bool)
    
    func enableGameStartButton(bool: Bool)
    func enableHomePlayerAddButton(bool: Bool)
    func enableAwayPlayerAddButton(bool: Bool)
    
    func showTeamFormView(isEditMode: Bool, name: String?, index: Int?, bool: Bool)
    
    var isShowingPlayerFormView: Bool { get set }
}
