//
//  TeamListPresenter.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class TeamListPresenter: TeamListPresenterProtocol {

    weak var view: TeamListViewProtocol?
    var interactor: TeamListInteractorInputProtocol?
    var wireframe: TeamListWireframeProtocol?

}

extension TeamListPresenter: TeamListInteractorOutputProtocol {
    
}
