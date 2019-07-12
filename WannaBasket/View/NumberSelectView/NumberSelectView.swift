//
//  NumberSelectView.swift
//  WannaBasket
//
//  Created by Het Song on 12/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

protocol NumberSelectViewDelegate {
    func didSelectItem(at indexPath: IndexPath)
}

class NumberSelectView: UICollectionView {
    
    var _delegate: NumberSelectViewDelegate?
    var cellSpacing: CGFloat = 5
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        showsVerticalScrollIndicator = false
        backgroundColor = Constants.Color.White
        layer.borderColor = Constants.Color.Black.cgColor
        layer.borderWidth = 1
        contentInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing,
                                    bottom: cellSpacing, right: cellSpacing)
        
        register(NumberSelectViewCell.self)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NumberSelectView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _delegate?.didSelectItem(at: indexPath)
    }
}

extension NumberSelectView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.bounds.width - cellSpacing) / 10 - cellSpacing
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

extension NumberSelectView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 101
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as NumberSelectViewCell
        cell.setup(number: indexPath.row)
        return cell
    }
}
