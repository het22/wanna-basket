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
    
    var record: GameRecord!
    
    func viewDidLoad() {
        let home = record.teams.home
        let away = record.teams.away
        view?.updateTeamNameLabel(name: home.name, of: true)
        view?.updateTeamNameLabel(name: away.name, of: false)
        
        view?.updateScoreLabel(home: record.scores.home, away: record.scores.away)
        
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
