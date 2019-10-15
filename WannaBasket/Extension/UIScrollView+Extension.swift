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
        let savedSuperview = superview
        let saveVerticalScroll = showsVerticalScrollIndicator
        let saveHorizontalScroll = showsHorizontalScrollIndicator
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentOffset = CGPoint.zero
        frame = CGRect(x: 0,
                       y: 0,
                       width: contentSize.width,
                       height: contentSize.height)
        
        let watermarkImageView = UIImageView(image: #imageLiteral(resourceName: "watermark"))
        let width = contentSize.width * 0.8
        watermarkImageView.frame = CGRect(x: (contentSize.width-width)/2,
                                          y: (contentSize.height-width)/2,
                                           width: width, height: width)
        watermarkImageView.contentMode = .scaleAspectFit
        watermarkImageView.alpha = 0.1
        addSubview(watermarkImageView)
        
        let tempSuperview = UIView(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        removeFromSuperview()
        tempSuperview.addSubview(self)
        
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            tempSuperview.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        watermarkImageView.removeFromSuperview()
        removeFromSuperview()
        savedSuperview?.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = true
        
        contentOffset = savedContentOffset
        frame = savedFrame
        showsVerticalScrollIndicator = saveVerticalScroll
        showsHorizontalScrollIndicator = saveHorizontalScroll
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
