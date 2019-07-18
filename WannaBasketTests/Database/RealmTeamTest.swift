//
//  RealmTeamTest.swift
//  WannaBasketTests
//
//  Created by Het Song on 18/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import XCTest
import RealmSwift
@testable import WannaBasket

class RealmTeamTest: XCTestCase {
    
    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func testConvertToRealmTeam() {
        var team = Team(uuid: "Team", name: "Team")
        team.register(player: Player(uuid: "PlayerA", name: "PlayerA"), number: 0)
        team.register(player: Player(uuid: "PlayerB", name: "PlayerB"), number: 1)
        
        let realmTeam = team.realmObject()
        XCTAssertEqual(realmTeam.uuid, team.uuid)
        XCTAssertEqual(realmTeam.name, team.name)
        XCTAssertEqual(realmTeam.playerInfors["PlayerA"], 0)
        XCTAssertEqual(realmTeam.playerInfors["PlayerB"], 1)
    }
    
    func testConvertToTeam() {
        let realmTeam = RealmTeam()
        realmTeam.uuid = "Team"
        realmTeam.name = "Team"
        
        let realmPlayerA = Player(uuid: "PlayerA", name: "PlayerA").realmObject()
        let realmPlayerB = Player(uuid: "PlayerB", name: "PlayerB").realmObject()
        realmTeam.playerInfors[realmPlayerA.uuid] = 0
        realmTeam.playerInfors[realmPlayerB.uuid] = 1
        
        let realm = try! Realm()
        try! realm.write {
            realm.add([realmPlayerA, realmPlayerB], update: true)
            realm.add(realmTeam, update: true)
        }
        
        let team = Team(realmObject: realmTeam)
        XCTAssertEqual(team.uuid, realmTeam.uuid)
        XCTAssertEqual(team.name, realmTeam.name)
        XCTAssertEqual(team.playerInfors[0], Player(uuid: "PlayerA", name: "PlayerA"))
        XCTAssertEqual(team.playerInfors[1], Player(uuid: "PlayerB", name: "PlayerB"))
    }
}
