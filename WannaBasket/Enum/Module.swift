//
//  ModuleEnum.swift
//  WannaBasket
//
//  Created by Het Song on 18/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

enum Module {
    
    case Player(_ module: PlayerModule)
    enum PlayerModule {
        case List
        case Detail(player: Player)
    }
    
    case Team(_ module: TeamModule)
    enum TeamModule {
        case List
        case Detail(team: Team)
    }
    
    case Game(_ module: GameModule)
    enum GameModule {
        case List
        case Setup
        case Play(game: Game)
    }
    
    case Record(game: Game)
    
    
    var view: UIViewController {
        var view: UIViewController
        switch self {
        case .Game(let module):
            switch module {
            case .List: view = GameListWireframe.createModule()
            case .Setup: view = GameSetupWireframe.createModule()
            case .Play(let game): view = GamePlayWireframe.createModule()
            }
            
        case .Player(let module):
            switch module {
            case .List: view = PlayerListWireframe.createModule()
            case .Detail(let player): view = PlayerDetailWireframe.createModule()
            }
            
        case .Team(let module):
            switch module {
            case .List: view = TeamListWireframe.createModule()
            case .Detail(let team): view = TeamDetailWireframe.createModule()
            }
            
        case .Record(let game): view = RecordWireframe.createModule(with: game)
        }
        view.tabBarItem = self.tabBarItem
        return view
    }
    
    var tabBarItem: UITabBarItem? {
        switch self {
        case .Game(.List): return UITabBarItem(title: "Game", image: nil, tag: 0)
        case .Player(.List): return UITabBarItem(title: "Player", image: nil, tag: 1)
        case .Team(.List): return UITabBarItem(title: "Team", image: nil, tag: 2)
        default: return nil
        }
    }
}
