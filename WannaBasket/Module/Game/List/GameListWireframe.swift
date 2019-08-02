//
//  GameListWireframe.swift
//  WannaBasket
//
//  Created Het Song on 01/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GameListWireframe: GameListWireframeProtocol {

    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "GameListScreen", bundle: Bundle.main)
    }
    
    static func createModule() -> UIViewController {
        let viewController = mainStoryboard.instantiateInitialViewController()
        if let view = viewController as? GameListView {
            let interactor  = GameListInteractor()
            let presenter = GameListPresenter()
            let wireframe = GameListWireframe()
            
            view.presenter = presenter
            interactor.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            presenter.wireframe = wireframe
            
            return view
        }
        return UIViewController()
    }
}
