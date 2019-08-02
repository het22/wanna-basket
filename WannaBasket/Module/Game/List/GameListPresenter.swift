//
//  GameListPresenter.swift
//  WannaBasket
//
//  Created Het Song on 01/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GameListPresenter: GameListPresenterProtocol {

    weak var view: GameListViewProtocol?
    var interactor: GameListInteractorInputProtocol?
    var wireframe: GameListWireframeProtocol?

}

extension GameListPresenter: GameListInteractorOutputProtocol {
    
}
