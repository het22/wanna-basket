//
//  RecordProtocol.swift
//  WannaBasket
//
//  Created Het Song on 14/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol RecordWireframeProtocol: class {
    static func createModule(with records: [Record]) -> UIViewController
}

protocol RecordInteractorInputProtocol: class {
    
    var presenter: RecordInteractorOutputProtocol?  { get set }
    
    // INTERACTOR -> PRESENTER
    
}

protocol RecordInteractorOutputProtocol: class {
    
    // PRESENTER -> INTERACTOR
    
}

protocol RecordPresenterProtocol: class {
    
    var view: RecordViewProtocol? { get set }
    var wireframe: RecordWireframeProtocol? { get set }
    var interactor: RecordInteractorInputProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
}

protocol RecordViewProtocol: class {

    var presenter: RecordPresenterProtocol?  { get set }

    // PRESENTER -> VIEW
    
}
