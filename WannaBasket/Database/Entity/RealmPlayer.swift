//
//  RealmPlayer.swift
//  WannaBasket
//
//  Created by Het Song on 17/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import RealmSwift

class RealmPlayer: RealmObject {
    
    @objc dynamic var name: String = ""
    @objc dynamic var _teamInfors: String = ""
    
    var teamInfors: [String:Int] {
        get { return _teamInfors.convertToDictionary() as [String:Int] }
        set { if let json = newValue.convertToJson() { _teamInfors = json } }
    }
}

extension Player: Persistable {
    
    init(realmObject: RealmPlayer) {
        self.uuid = realmObject.uuid
        self.name = realmObject.name
        self.teamInfors = realmObject.teamInfors
    }
    
    func realmObject() -> RealmPlayer {
        let realmPlayer = RealmPlayer()
        if self.uuid != "" { realmPlayer.uuid = self.uuid }
        realmPlayer.name = self.name
        realmPlayer.teamInfors = self.teamInfors
        return realmPlayer
    }
}
