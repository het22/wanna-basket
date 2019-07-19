//
//  TeamDB.swift
//  WannaBasket
//
//  Created by Het Song on 18/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import RealmSwift

protocol TeamDB {
    func readAll() -> Results<RealmTeam>
    func read(with uuid: String) -> RealmTeam?
    func update(realmTeam: RealmTeam)
    func delete(realmTeam: RealmTeam)
}

extension RealmDB: TeamDB {
    
    func readAll() -> Results<RealmTeam> {
        let realm = try! Realm()
        let realmTeams = realm.objects(RealmTeam.self)
        return realmTeams
    }
    
    func read(with uuid: String) -> RealmTeam? {
        let realm = try! Realm()
        let realmTeam = realm.objects(RealmTeam.self).filter{$0.uuid==uuid}.first
        return realmTeam
    }
    
    func update(realmTeam: RealmTeam) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(realmTeam, update: true)
        }
    }
    
    func delete(realmTeam: RealmTeam) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realmTeam)
        }
    }
}
