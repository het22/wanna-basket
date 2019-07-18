//
//  PlayerDBTest.swift
//  WannaBasketTests
//
//  Created by Het Song on 18/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import XCTest
import RealmSwift
@testable import WannaBasket

class PlayerDBTest: XCTestCase {
    
    let playerDB: PlayerDB = RealmDB.shared
    
    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func createDummyPlayers(count: Int) {
        let realm = try! Realm()
        try! realm.write {
            for i in 0..<count {
                let player = Player(uuid: "Player\(i)", name: "Player\(i)").realmObject()
                realm.add(player)
            }
        }
    }
    
    func testRead() {
        createDummyPlayers(count: 3)
        
        let realm = try! Realm()
        let expectedPlayers = realm.objects(RealmPlayer.self)
        XCTAssertEqual(expectedPlayers[0].name, "Player0")
        XCTAssertEqual(expectedPlayers[1].name, "Player1")
        XCTAssertEqual(expectedPlayers[2].name, "Player2")
        
        let expectedPlayer = playerDB.read(with: expectedPlayers[1].uuid)
        XCTAssertEqual(expectedPlayer?.name, "Player1")
    }
    
    func testUpdate() {
        let player = Player(uuid: "Player", name: "Player").realmObject()
        playerDB.update(realmPlayer: player)
        
        let realm = try! Realm()
        let expectedPlayer = realm.objects(RealmPlayer.self).last
        XCTAssertEqual(expectedPlayer?.uuid, player.uuid)
        XCTAssertEqual(expectedPlayer?.name, player.name)
    }
    
    func testDelete() {
        createDummyPlayers(count: 3)
        
        let realm = try! Realm()
        var expectedCount = realm.objects(RealmPlayer.self).count
        XCTAssertEqual(expectedCount, 3)
        
        let player = realm.objects(RealmPlayer.self).first!
        playerDB.delete(realmPlayer: player)
        
        expectedCount = realm.objects(RealmPlayer.self).count
        XCTAssertEqual(expectedCount, 2)
    }
}
