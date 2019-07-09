//
//  Quarter.swift
//  WannaBasket
//
//  Created by Het Song on 09/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

enum Quarter: CustomStringConvertible, Equatable {
    
    case Regular(Int)
    case Overtime(Int)
    
    var num: Int {
        switch self {
        case .Regular(let num):
            return num
        case .Overtime(let num):
            return num
        }
    }
    
    var description: String {
        switch self {
        case .Regular:
            return "\(num)쿼터"
        case .Overtime:
            return "연장\(num)쿼터"
        }
    }
}
