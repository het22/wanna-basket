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
        
        var scores = [(Quarter, Int, Int)]()
        for i in 1...4 {
            let score = game.records
                .reduce((Quarter.Regular(i),0,0)) {
                    var temp = $0
                    if case $0.0 = $1.time.quarter, case Stat.Score(let Point) = $1.stat {
                        if $1.home { temp.1 += Point.rawValue }
                        else { temp.2 += Point.rawValue }
                    }
                    return temp
                }
            scores.append(score)
        }
        view?.updateQuarterScoreView(name: (game.team.home.name, game.team.away.name), scores: scores)
        
        let maxCount = max(game.players.home.count, game.players.away.count)
        view?.updateViewHeight(cellCount: maxCount)
        
        let homePlayerTuples = game.players.home
            .compactMap { player -> (Player, [Record]) in
                let records = game.records.filter { $0.player == player }
                return (player, records)
            }
            .sorted { first, second -> Bool in
                let point1 = first.1.reduce(0) {
                    var point = 0
                    if case Stat.Score(let Point) = $1.stat {
                        point += Point.rawValue
                    }
                    return $0 + point
                }
                let point2 = second.1.reduce(0) {
                    var point = 0
                    if case Stat.Score(let Point) = $1.stat {
                        point += Point.rawValue
                    }
                    return $0 + point
                }
                return point1 > point2
            }
        view?.updatePlayerTableView(playerTuples: homePlayerTuples, of: true)
        
        let awayPlayerTuples = game.players.away
            .compactMap { player -> (Player, [Record]) in
                let records = game.records.filter { $0.player == player }
                return (player, records)
            }
            .sorted { first, second -> Bool in
                let point1 = first.1.reduce(0) {
                    var point = 0
                    if case Stat.Score(let Point) = $1.stat {
                        point += Point.rawValue
                    }
                    return $0 + point
                }
                let point2 = second.1.reduce(0) {
                    var point = 0
                    if case Stat.Score(let Point) = $1.stat {
                        point += Point.rawValue
                    }
                    return $0 + point
                }
                return point1 > point2
        }
        view?.updatePlayerTableView(playerTuples: awayPlayerTuples, of: false)
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
