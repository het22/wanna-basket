//
//  QuarterEnum.swift
//  WannaBasket
//
//  Created by Het Song on 28/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

enum Quarter: CustomStringConvertible {
    
    case First
    case Second
    case Third
    case Fourth
    case End
    
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
