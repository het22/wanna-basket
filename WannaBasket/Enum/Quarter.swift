//
//  Quarter.swift
//  WannaBasket
//
//  Created by Het Song on 05/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

struct Quarter {
    enum QuarterType {
        case Regular
        case Overtime
    }
    let type: QuarterType
    var gameClock: Float
    var shotClock: Float
}
