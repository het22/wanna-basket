//
//  Array+Extension.swift
//  WannaBasket
//
//  Created by Het Song on 11/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return (indices ~= index) ? self[index] : nil
    }
    
    func filter(indexes: [Int]) -> [Element] {
        var elements = [Element]()
        indexes.forEach {
            if let element = self[safe: $0] {
                elements.append(element)
            }
        }
        return elements
    }
}
