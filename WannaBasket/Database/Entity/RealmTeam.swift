//
//  RealmTeam.swift
//  WannaBasket
//
//  Created by Het Song on 17/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import RealmSwift

class RealmTeam: RealmObject {
    
    @objc dynamic var name: String = ""
    @objc dynamic var _playerInfors: String = ""
    
    var playerInfors: [String:Int] {
        get { return _playerInfors.convertToDictionary() as [String:Int] }
        set { if let json = newValue.convertToJson() { _playerInfors = json } }
    }
}

extension Team: Persistable {
    
    init(realmObject: RealmTeam) {
        self.uuid = realmObject.uuid
        self.name = realmObject.name
        
        let playerDB: PlayerDB = RealmDB.shared
        var playerInfors = [Int: Player]()
        realmObject.playerInfors.forEach {
            if let realmPlayer = playerDB.read(with: $0.key) {
                let player = Player(realmObject: realmPlayer)
                playerInfors[$0.value] = player
            }
        }
        self.playerInfors = playerInfors
    }
    
    func realmObject() -> RealmTeam {
        let realmTeam = RealmTeam()
        if self.uuid != "" { realmTeam.uuid = self.uuid }
        realmTeam.name = self.name
        var playerInfors = [String:Int]()
        self.playerInfors.forEach {
            playerInfors[$0.value.uuid] = $0.key
        }
        realmTeam.playerInfors = playerInfors
        return realmTeam
    }
}
