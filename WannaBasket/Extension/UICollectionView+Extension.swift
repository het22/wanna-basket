//
//  UICollectionView+Extension.swift
//  WannaBasket
//
//  Created by Het Song on 19/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell> (_: T.Type) where T: NibLoadable, T: Reusable {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell> (forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
