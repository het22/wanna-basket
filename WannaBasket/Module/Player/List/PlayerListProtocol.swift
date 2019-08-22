//
//  PlayerListProtocol.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol PlayerListWireframeProtocol: class {
    static func createModule() -> UIViewController
}

protocol PlayerListInteractorInputProtocol: class {
    
    var presenter: PlayerListInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol PlayerListInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol PlayerListPresenterProtocol: class {
    
    var view: PlayerListViewProtocol? { get set }
    var wireframe: PlayerListWireframeProtocol? { get set }
    var interactor: PlayerListInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    
}

protocol PlayerListViewProtocol: class {

    var presenter: PlayerListPresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    
}
