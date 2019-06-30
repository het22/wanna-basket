//
//  QuarterEnum.swift
//  WannaBasket
//
//  Created by Het Song on 28/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

enum Quarter: Int, CustomStringConvertible {
    
    case First = 1
    case Second = 2
    case Third = 3
    case Fourth = 4
    case End = 0
    
    var description: String {
        switch self {
        case .First: return "1쿼터"
        case .Second: return "2쿼터"
        case .Third: return "3쿼터"
        case .Fourth: return "4쿼터"
        case .End: return "종료"
        }
    }
}
