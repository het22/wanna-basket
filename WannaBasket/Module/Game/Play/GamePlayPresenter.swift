//
//  GamePlayPresenter.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GamePlayPresenter: GamePlayPresenterProtocol {

    weak var view: GamePlayViewProtocol?
    var interactor: GamePlayInteractorInputProtocol?
    var wireframe: GamePlayWireframeProtocol?

}

extension GamePlayPresenter: GamePlayInteractorOutputProtocol {
    
}
