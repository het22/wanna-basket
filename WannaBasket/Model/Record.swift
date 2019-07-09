//
//  RecordModel.swift
//  WannaBasket
//
//  Created by Het Song on 27/06/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

// 나중에 수정할 것: 팀과 선수의 사본이 아니라 키 값을 가져야 한다.

protocol RecordModel {
    var quarter: Time { get set }
    var home: Bool { get set }
    var team: Team { get set }
    var player: Player { get set }
    var stat: Stat.Score { get set }
}

struct Record: RecordModel, CustomStringConvertible {
    var quarter: Time
    var home: Bool
    var team: Team
    var player: Player
    var stat: Stat.Score
    
    var description: String {
        get {
            return "\(quarter) | \(home ? "홈팀" : "원정팀")(\(team.name)) | \(player.name) \(stat)"
        }
    }
}
