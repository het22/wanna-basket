//
//  PlayerDetailProtocol.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol PlayerDetailWireframeProtocol: class {
    static func createModule() -> UIViewController
}

protocol PlayerDetailInteractorInputProtocol: class {
    
    var presenter: PlayerDetailInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol PlayerDetailInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol PlayerDetailPresenterProtocol: class {
    
    var view: PlayerDetailViewProtocol? { get set }
    var wireframe: PlayerDetailWireframeProtocol? { get set }
    var interactor: PlayerDetailInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    
}

protocol PlayerDetailViewProtocol: class {

    var presenter: PlayerDetailPresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    
}
