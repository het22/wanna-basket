//
//  UITableView+Extension.swift
//  WannaBasket
//
//  Created by Het Song on 24/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell> (_: T.Type) where T: NibLoadable, T: Reusable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell> (forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
