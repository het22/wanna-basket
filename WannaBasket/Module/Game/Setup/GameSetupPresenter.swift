//
//  GameSetupPresenter.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GameSetupPresenter: GameSetupPresenterProtocol {

    weak var view: GameSetupViewProtocol?
    var interactor: GameSetupInteractorInputProtocol?
    var wireframe: GameSetupWireframeProtocol?

}

extension GameSetupPresenter: GameSetupInteractorOutputProtocol {
    
}
