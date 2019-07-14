//
//  RecordView.swift
//  WannaBasket
//
//  Created Het Song on 14/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class RecordView: UIViewController {

	var presenter: RecordPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension RecordView: RecordViewProtocol {
    
}
