//
//  Stat.swift
//  WannaBasket
//
//  Created by Het Song on 05/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

enum Stat: Equatable {
    
    case Score(_Score)
    case Assist
    case Block
    case Rebound
    
    enum _Score: Int {
        case One = 1
        case Two = 2
        case Three = 3
    }
}
