//
//  GameTest.swift
//  WannaBasketTests
//
//  Created by Het Song on 09/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import XCTest
@testable import WannaBasket

class GameTest: XCTestCase {

    var game: Game!

    override func setUp() {
        let homeTeam = Team(name: "TeamA")
        homeTeam.players.append(contentsOf: [
                Player(name: "PlayerA", number: 1),
                Player(name: "PlayerB", number: 2)
            ])
        let awayTeam = Team(name: "TeamB")
        awayTeam.players.append(contentsOf: [
            Player(name: "PlayerC", number: 1),
            Player(name: "PlayerD", number: 2)
            ])
        game = Game(homeTeam: homeTeam, awayTeam: awayTeam)
    }
    
    func testGetScore() {
        game.addRecord(playerTuple: (true, 0), stat: .Two)
        game.addRecord(playerTuple: (false, 0), stat: .Three)
        game.addRecord(playerTuple: (true, 1), stat: .Two)
        game.addRecord(playerTuple: (true, 1), stat: .One)
        XCTAssertEqual(game.scores.home, 5)
        XCTAssertEqual(game.scores.away, 3)
    }
}
