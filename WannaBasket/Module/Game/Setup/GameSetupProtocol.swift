//
//  GameSetupProtocol.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol GameSetupWireframeProtocol: class {
    static func createModule() -> UIViewController
}

protocol GameSetupInteractorInputProtocol: class {
    
    var presenter: GameSetupInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol GameSetupInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol GameSetupPresenterProtocol: class {
    
    var view: GameSetupViewProtocol? { get set }
    var wireframe: GameSetupWireframeProtocol? { get set }
    var interactor: GameSetupInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    
}

protocol GameSetupViewProtocol: class {

    var presenter: GameSetupPresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    
}
