//
//  TeamDetailPresenter.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class TeamDetailPresenter: TeamDetailPresenterProtocol {

    weak var view: TeamDetailViewProtocol?
    var interactor: TeamDetailInteractorInputProtocol?
    var wireframe: TeamDetailWireframeProtocol?

}

extension TeamDetailPresenter: TeamDetailInteractorOutputProtocol {
    
}
