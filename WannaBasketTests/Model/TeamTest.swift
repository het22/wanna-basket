//
//  TeamTest.swift
//  WannaBasketTests
//
//  Created by Het Song on 18/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import XCTest
@testable import WannaBasket

class TeamTest: XCTestCase {
    
    var teamA: Team!
    var playerA: Player!
    var playerB: Player!
    var playerC: Player!
    
    override func setUp() {
        teamA = Team(name: "MAHAMAN")
        playerA = Player(name: "HET")
        playerB = Player(name: "ANT")
        playerC = Player(name: "CHAN")
    }
    
    func testGetPlayers() {
        teamA.register(player: playerA, number: 22)
        teamA.register(player: playerB, number: 2)
        teamA.register(player: playerC, number: 10)
        let players = [playerB, playerC, playerA]
        XCTAssertEqual(players, teamA.players)
    }
    
    func testGetIsNumberAssigned() {
        teamA.register(player: playerA, number: 0)
        teamA.register(player: playerB, number: 1)
        teamA.register(player: playerC, number: 2)
        var arr = [Bool].init(repeating: false, count: 101)
        [0,1,2].forEach { arr[$0] = true }
        XCTAssertEqual(arr, teamA.isNumberAssigned)
    }
    
    func testRegisterPlayer() {
        teamA.register(player: playerA, number: 22)
        if let player = teamA.playerInfors[22] {
            XCTAssertEqual(playerA, player)
        }
        teamA.register(player: playerB, number: 22)
        if let player = teamA.playerInfors[22] {
            XCTAssertEqual(playerB, player)
        }
    }
    
    func testEjectPlayer() {
        teamA.register(player: playerA, number: 22)
        if let player = teamA.playerInfors[22] {
            XCTAssertEqual(playerA, player)
        }
        teamA.eject(numbers: 22)
        XCTAssertNil(teamA.playerInfors[22])
    }
}

