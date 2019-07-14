//
//  RecordPresenter.swift
//  WannaBasket
//
//  Created Het Song on 14/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class RecordPresenter: RecordPresenterProtocol {

    weak var view: RecordViewProtocol?
    var interactor: RecordInteractorInputProtocol?
    var wireframe: RecordWireframeProtocol?
    
    var records: [Record]!
    
}

extension RecordPresenter: RecordInteractorOutputProtocol {
    
}
