//
//  RecordModel.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

struct Record: CustomStringConvertible {
    var time: Time
    var home: Bool
    var team: Team
    var player: PlayerOfTeam
    var stat: Stat
    
    var description: String {
        get {
            return "\(time) | \(home ? "홈팀" : "원정팀")(\(team.name)) | \(player.name) \(stat)"
        }
    }
}
