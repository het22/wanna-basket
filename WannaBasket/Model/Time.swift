//
//  Quarter.swift
//  WannaBasket
//
//  Created by Het Song on 05/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

struct Time: CustomStringConvertible, Equatable {
    
    let quarter: Quarter
    var gameClock: Float
    var shotClock: Float
    
    var description: String {
        return "\(quarter.description) \(Constants.Format.GameClock(gameClock)) \(Constants.Format.ShotClock(shotClock))"
    }
    
    static func == (lhs: Time, rhs: Time) -> Bool {
        let quarterEqual = (lhs.quarter == rhs.quarter)
        let gameClockEqual = (lhs.gameClock == rhs.gameClock)
        let shotClockEqual = (lhs.shotClock == rhs.shotClock)
        return quarterEqual && gameClockEqual && shotClockEqual
    }
}
