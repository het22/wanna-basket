//
//  TeamDetailProtocol.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol TeamDetailWireframeProtocol: class {
    static func createModule() -> UIViewController
}

protocol TeamDetailInteractorInputProtocol: class {
    
    var presenter: TeamDetailInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol TeamDetailInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol TeamDetailPresenterProtocol: class {
    
    var view: TeamDetailViewProtocol? { get set }
    var wireframe: TeamDetailWireframeProtocol? { get set }
    var interactor: TeamDetailInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    
}

protocol TeamDetailViewProtocol: class {

    var presenter: TeamDetailPresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    
}
