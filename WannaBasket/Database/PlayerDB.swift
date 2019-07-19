//
//  PlayerDB.swift
//  WannaBasket
//
//  Created by Het Song on 17/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import RealmSwift

protocol PlayerDB {
    func read(with uuid: String) -> RealmPlayer?
    func update(realmPlayer: RealmPlayer)
    func delete(realmPlayer: RealmPlayer)
}

extension RealmDB: PlayerDB {
    
    func read(with uuid: String) -> RealmPlayer? {
        let realm = try! Realm()
        let realmPlayer = realm.objects(RealmPlayer.self).filter{$0.uuid==uuid}.first
        return realmPlayer
    }
    
    func update(realmPlayer: RealmPlayer) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(realmPlayer, update: true)
        }
    }
    
    func delete(realmPlayer: RealmPlayer) {
        let realm = try! Realm()
        let realmPlayer = realm.objects(RealmPlayer.self).filter{$0.uuid==realmPlayer.uuid}.first
        guard let player = realmPlayer else { return }
        try! realm.write {
            realm.delete(player)
        }
    }
}
