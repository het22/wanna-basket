//
//  TeamListView.swift
//  WannaBasket
//
//  Created Het Song on 22/08/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class TeamListView: UIViewController {

	var presenter: TeamListPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension TeamListView: TeamListViewProtocol {
    
}
