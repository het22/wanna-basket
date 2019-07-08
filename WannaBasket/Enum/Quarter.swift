//
//  Quarter.swift
//  WannaBasket
//
//  Created by Het Song on 05/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

struct Quarter: CustomStringConvertible {
    
    let type: QuarterType
    enum QuarterType: CustomStringConvertible {
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
                return "\(num+1)쿼터"
            case .Overtime:
                return "연장\(num+1)쿼터"
            }
        }
    }
    
    var gameClock: Float
    var gameClockDescription: String {
        if gameClock >= 60.0 {
            let min = Int(gameClock) / 60
            let sec = Int(gameClock) % 60
            return gameClockFormat.string(from: NSNumber(integerLiteral: min))! + ":" + gameClockFormat.string(from: NSNumber(integerLiteral: sec))!
        } else {
            return shotClockFormat.string(from: NSNumber(value: gameClock))!
        }
    }
    
    var shotClock: Float
    var shotClockDescription: String {
        return shotClockFormat.string(from: NSNumber(value: shotClock))!
    }
    
    var description: String {
        return "\(type.description) \(gameClockDescription) \(shotClockDescription)"
    }
}
