//
//  UIScrollView+Extension.swift
//  WannaBasket
//
//  Created by Het Song on 14/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func toImage() -> UIImage? {
        
        UIGraphicsBeginImageContext(contentSize)
        
        let savedContentOffset = contentOffset
        let savedFrame = frame
        let saveVerticalScroll = showsVerticalScrollIndicator
        let saveHorizontalScroll = showsHorizontalScrollIndicator
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentOffset = CGPoint.zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        contentOffset = savedContentOffset
        frame = savedFrame
        showsVerticalScrollIndicator = saveVerticalScroll
        showsHorizontalScrollIndicator = saveHorizontalScroll
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
