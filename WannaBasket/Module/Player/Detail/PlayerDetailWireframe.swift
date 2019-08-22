//
//  PlayerDetailWireframe.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class PlayerDetailWireframe: PlayerDetailWireframeProtocol {

    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "PlayerDetailScreen", bundle: Bundle.main)
    }
    
    static func createModule() -> UIViewController {
        let viewController = mainStoryboard.instantiateInitialViewController()
        if let view = viewController as? PlayerDetailView {
            let interactor  = PlayerDetailInteractor()
            let presenter = PlayerDetailPresenter()
            let wireframe = PlayerDetailWireframe()
            
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
