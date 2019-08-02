//
//  GameListProtocol.swift
//  WannaBasket
//
//  Created Het Song on 01/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol GameListWireframeProtocol: class {
    static func createModule() -> UIViewController
}

protocol GameListInteractorInputProtocol: class {
    
    var presenter: GameListInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol GameListInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol GameListPresenterProtocol: class {
    
    var view: GameListViewProtocol? { get set }
    var wireframe: GameListWireframeProtocol? { get set }
    var interactor: GameListInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    
}

protocol GameListViewProtocol: class {

    var presenter: GameListPresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    
}
