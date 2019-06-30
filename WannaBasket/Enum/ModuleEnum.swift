//
//  ModuleEnum.swift
//  WannaBasket
//
//  Created by Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

enum Module {
    
    case Home
    case Game(game: Game)
    
    var view: UIViewController {
        switch self {
        case .Home:
            return HomeWireframe.createModule()
        case .Game(let game):
            return GameWireframe.createModule(with: game)
        }
    }
}
