//
//  PlayerListPresenter.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class PlayerListPresenter: PlayerListPresenterProtocol {

    weak var view: PlayerListViewProtocol?
    var interactor: PlayerListInteractorInputProtocol?
    var wireframe: PlayerListWireframeProtocol?

}

extension PlayerListPresenter: PlayerListInteractorOutputProtocol {
    
}
