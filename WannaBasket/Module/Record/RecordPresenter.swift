//
//  RecordPresenter.swift
//  WannaBasket
//
//  Created Het Song on 14/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class RecordPresenter: RecordPresenterProtocol {

    weak var view: RecordViewProtocol?
    var interactor: RecordInteractorInputProtocol?
    var wireframe: RecordWireframeProtocol?
    
    var game: GameModel!
    
    func viewDidLoad() {
        view?.updateTeamNameLabel(name: game.team.home.name, of: true)
        view?.updateTeamNameLabel(name: game.team.away.name, of: false)
        view?.updateScoreLabel(score: game.score)
        
        let maxCount = max(game.players.home.count, game.players.away.count)
        view?.updateViewHeight(cellCount: maxCount)
        
        view?.updatePlayerTableView(players: game.players.home, of: true)
        view?.updatePlayerTableView(players: game.players.away, of: false)
    }
    
    func didTapSaveButton() {
        view?.saveImageToAlbum()
    }
    
    func didTapBackButton() {
        view?.dismiss(animated: true, completion: nil)
    }
    
    func didTapExitButton() {
        let gameView = (self.view as? UIViewController)?.presentingViewController
        view?.dismiss(animated: true) {
            gameView?.dismiss(animated: true, completion: nil)
        }
    }
}

extension RecordPresenter: RecordInteractorOutputProtocol {
    
}
