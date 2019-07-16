//
//  Stat.swift
//  WannaBasket
//
//  Created by Het Song on 05/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

enum Stat: Equatable, CustomStringConvertible {
    
    case Score(Point)
    case Assist
    case Block
    case Rebound(Situation)
    case Foul(Situation)
    
    enum Situation {
        case Offense
        case Defense
    }
    
    enum Point: Int, CustomStringConvertible {
        case One = 1
        case Two = 2
        case Three = 3
        
        var description: String {
            return "\(self.rawValue)점"
        }
    }
    
    var description: String {
        switch self {
        case .Score(let point):
            return point.description
        case .Assist:
            return "어시스트"
        case .Block:
            return "블락"
        case .Rebound:
            return "리바운드"
        case .Foul:
            return "파울"
        }
    }
}
