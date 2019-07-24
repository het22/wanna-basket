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
        frame = CGRect(x: savedFrame.origin.x,
                       y: savedFrame.origin.y,
                       width: contentSize.width,
                       height: contentSize.height)
        
        let watermarkImageView = UIImageView(image: #imageLiteral(resourceName: "watermark"))
        let width = contentSize.width * 0.8
        watermarkImageView.frame = CGRect(x: (contentSize.width-width)/2,
                                          y: (contentSize.height-width)/2,
                                           width: width, height: width)
        watermarkImageView.contentMode = .scaleAspectFit
        watermarkImageView.alpha = 0.1
        self.addSubview(watermarkImageView)
        
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        watermarkImageView.removeFromSuperview()
        
        contentOffset = savedContentOffset
        frame = savedFrame
        showsVerticalScrollIndicator = saveVerticalScroll
        showsHorizontalScrollIndicator = saveHorizontalScroll
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
