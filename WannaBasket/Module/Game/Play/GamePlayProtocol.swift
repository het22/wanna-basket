//
//  GamePlayProtocol.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol GamePlayWireframeProtocol: class {
    static func createModule() -> UIViewController
}

protocol GamePlayInteractorInputProtocol: class {
    
    var presenter: GamePlayInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol GamePlayInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol GamePlayPresenterProtocol: class {
    
    var view: GamePlayViewProtocol? { get set }
    var wireframe: GamePlayWireframeProtocol? { get set }
    var interactor: GamePlayInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    
}

protocol GamePlayViewProtocol: class {

    var presenter: GamePlayPresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    
}
