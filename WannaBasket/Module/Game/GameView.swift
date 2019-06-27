//
//  GameView.swift
//  WannaBasket
//
//  Created Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class GameView: UIViewController {

	var presenter: GamePresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension GameView: GameViewProtocol {
    
}
