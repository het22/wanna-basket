//
//  TeamDBTest.swift
//  WannaBasketTests
//
//  Created by Het Song on 19/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import XCTest
import RealmSwift
@testable import WannaBasket

class TeamDBTest: XCTestCase {
    
    let teamDB: TeamDB = RealmDB.shared
    
    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func createDummyTeams(count: Int) {
        let realm = try! Realm()
        try! realm.write {
            for i in 0..<count {
                let team = Team(uuid: "Team\(i)", name: "Team\(i)").realmObject()
                realm.add(team)
            }
        }
    }
    
    func testRead() {
        createDummyTeams(count: 3)
        
        let realm = try! Realm()
        let expectedTeams = realm.objects(RealmTeam.self)
        XCTAssertEqual(expectedTeams[0].name, "Team0")
        XCTAssertEqual(expectedTeams[1].name, "Team1")
        XCTAssertEqual(expectedTeams[2].name, "Team2")
        
        let expectedTeam = teamDB.read(with: expectedTeams[1].uuid)
        XCTAssertEqual(expectedTeam?.name, "Team1")
    }
    
    func testUpdate() {
        let team = Team(uuid: "Team", name: "Team").realmObject()
        teamDB.update(realmTeam: team)
        
        let realm = try! Realm()
        let expectedTeam = realm.objects(RealmTeam.self).last
        XCTAssertEqual(expectedTeam?.uuid, team.uuid)
        XCTAssertEqual(expectedTeam?.name, team.name)
    }
    
    func testDelete() {
        createDummyTeams(count: 3)
        
        let realm = try! Realm()
        var expectedCount = realm.objects(RealmTeam.self).count
        XCTAssertEqual(expectedCount, 3)
        
        let team = realm.objects(RealmTeam.self).first!
        teamDB.delete(realmTeam: team)
        
        expectedCount = realm.objects(RealmTeam.self).count
        XCTAssertEqual(expectedCount, 2)
    }
}
