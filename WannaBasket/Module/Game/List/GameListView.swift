//
//  GameListView.swift
//  WannaBasket
//
//  Created Het Song on 01/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GameListView: UIViewController {

	var presenter: GameListPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension GameListView: GameListViewProtocol {
    
}
