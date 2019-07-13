//
//  HomeWireframe.swift
//  WannaBasket
//
//  Created Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class HomeWireframe: HomeWireframeProtocol {

    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "HomeScreen", bundle: Bundle.main)
    }
    
    static func createModule() -> UIViewController {
        let viewController = mainStoryboard.instantiateInitialViewController()
        if let view = viewController as? HomeView {
            let interactor  = HomeInteractor()
            let presenter = HomePresenter()
            let wireframe = HomeWireframe()
            
            view.presenter = presenter
            interactor.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            presenter.wireframe = wireframe
            
            presenter.gameSetting = GameSetting()
            
            return view
        }
        return UIViewController()
    }
    
    func presentModule(source: HomeViewProtocol, module: Module) {
        if let sourceView = source as? UIViewController {
            let destinationView = module.view
            sourceView.present(destinationView, animated: true, completion: nil)
        }
    }
}
