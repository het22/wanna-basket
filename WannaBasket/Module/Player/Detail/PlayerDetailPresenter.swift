//
//  PlayerDetailPresenter.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class PlayerDetailPresenter: PlayerDetailPresenterProtocol {

    weak var view: PlayerDetailViewProtocol?
    var interactor: PlayerDetailInteractorInputProtocol?
    var wireframe: PlayerDetailWireframeProtocol?

}

extension PlayerDetailPresenter: PlayerDetailInteractorOutputProtocol {
    
}
