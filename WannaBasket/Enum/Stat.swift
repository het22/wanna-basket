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
            return "\(self.rawValue)"+"PT".localized
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
        case .Rebound(.Offense):
            return "공격 리바운드"
        case .Rebound(.Defense):
            return "수비 리바운드"
        case .Foul(.Offense):
            return "공격자 파울"
        case .Foul(.Defense):
            return "수비자 파울"
        }
    }
}
