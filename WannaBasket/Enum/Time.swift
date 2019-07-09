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
    
    enum Description: CustomStringConvertible {
        case GameClock(Float)
        case ShotClock(Float)
        
        var description: String {
            switch self {
            case .GameClock(let gameClock):
                if gameClock >= 60.0 {
                    let min = Int(gameClock) / 60
                    let sec = Int(gameClock) % 60
                    return gameClockFormat.string(from: NSNumber(integerLiteral: min))! + ":" + gameClockFormat.string(from: NSNumber(integerLiteral: sec))!
                } else {
                    return shotClockFormat.string(from: NSNumber(value: gameClock))!
                }
            case .ShotClock(let shotClock):
                return shotClockFormat.string(from: NSNumber(value: shotClock))!
            }
        }
    }
    
    var description: String {
        return "\(quarter.description) \(Description.GameClock(gameClock)) \(Description.ShotClock(shotClock))"
    }
    
    static func == (lhs: Time, rhs: Time) -> Bool {
        let quarterEqual = (lhs.quarter == rhs.quarter)
        let gameClockEqual = (lhs.gameClock == rhs.gameClock)
        let shotClockEqual = (lhs.shotClock == rhs.shotClock)
        return quarterEqual && gameClockEqual && shotClockEqual
    }
}
