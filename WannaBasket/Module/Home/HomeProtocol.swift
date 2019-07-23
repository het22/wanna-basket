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
    func requestReadAllTeam()
    func requestUpdateTeam(team: Team)
    func requestDeleteTeam(team: Team)
    
    func requestRegisterPlayer(player: PlayerOfTeam, team: Team)
    func requestUpdatePlayer(player: PlayerOfTeam)
    func requestEjectPlayer(player: PlayerOfTeam, team: Team)
    
}

protocol HomeInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    func didReadAllTeam(teams: [Team])
    func didUpdateTeam()
    func didDeleteTeam()
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
    
    func didTapPlayerFormCancelButton()
    func didTapPlayerFormDeleteButton(player: PlayerOfTeam)
    func didTapPlayerFormCompleteButton(player: PlayerOfTeam)
    func didTapPlayerFormEditButton(player: PlayerOfTeam)
    func didTapPlayerNumberButton() -> [Bool]
    
    func didTapTeamCell(at index: Int, tapSection: TeamCell.Section)
    func didDeleteTeamAction(at index: Int)
    func didDequeueTeamCell() -> (home: Int?, away: Int?)
    
    func didTapPlayerCell(at index: Int, of home: Bool)
    func didDeletePlayerAction(at index: Int, of home: Bool)
}

protocol HomeViewProtocol: class {

    var presenter: HomePresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    func updateTeamTableView(teams: [Team])
    func updatePlayerTableView(players: [PlayerOfTeam]?, of home: Bool)
    func updateTeamNameLabel(name: String?, of home: Bool)
    
    func highlightTeam(at index: Int, onLeft: Bool, bool: Bool)
    
    func enableGameStartButton(bool: Bool)
    func enablePlayerAddButton(bool: Bool, of home: Bool)
    
    func showTeamFormView(isEditMode: Bool, name: String?, index: Int?, bool: Bool)
    func showPlayerFormView(player: PlayerOfTeam?, bool: Bool)
}
