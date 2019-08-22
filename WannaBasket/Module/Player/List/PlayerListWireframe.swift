//
//  PlayerListWireframe.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class PlayerListWireframe: PlayerListWireframeProtocol {

    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "PlayerListScreen", bundle: Bundle.main)
    }
    
    static func createModule() -> UIViewController {
        let viewController = mainStoryboard.instantiateInitialViewController()
        if let view = viewController as? PlayerListView {
            let interactor  = PlayerListInteractor()
            let presenter = PlayerListPresenter()
            let wireframe = PlayerListWireframe()
            
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
