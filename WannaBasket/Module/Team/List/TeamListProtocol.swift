//
//  TeamListProtocol.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol TeamListWireframeProtocol: class {
    static func createModule() -> UIViewController
}

protocol TeamListInteractorInputProtocol: class {
    
    var presenter: TeamListInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol TeamListInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol TeamListPresenterProtocol: class {
    
    var view: TeamListViewProtocol? { get set }
    var wireframe: TeamListWireframeProtocol? { get set }
    var interactor: TeamListInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    
}

protocol TeamListViewProtocol: class {

    var presenter: TeamListPresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    
}
