//
//  GameSetupView.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GameSetupView: UIViewController {

	var presenter: GameSetupPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension GameSetupView: GameSetupViewProtocol {
    
}
