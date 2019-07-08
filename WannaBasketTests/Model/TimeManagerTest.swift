//
//  TimeManagerTest.swift
//  WannaBasketTests
//
//  Created by Het Song on 09/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import XCTest
@testable import WannaBasket

class TimeManagerTest: XCTestCase {
    
    var manager: TimeManager!
    
    override func setUp() {
        manager = TimeManager(maxRegularQuarterNum: 4)
    }
    
    func testCurrentTimeGetter() {
        let currentTime = manager.currentTime
        let time = manager.times[0]
        XCTAssertEqual(currentTime, time)
    }
    
    func testCurrentTimeSetter() {
        manager.currentQuarter = .Regular(2)
        manager.currentTime.gameClock = 400.0
        manager.currentTime.shotClock = 14.0
        let currentTime = manager.currentTime
        let time = Time(quarter: .Regular(2),
                        gameClock: 400.0,
                        shotClock: 14.0)
        XCTAssertEqual(currentTime, time)
    }

    func testUpdateQuarter() {
        XCTAssertEqual(manager.currentQuarter, Time.Quarter.Regular(1))
        manager.updateQuarter(quarter: .Regular(2))
        XCTAssertEqual(manager.currentQuarter, Time.Quarter.Regular(2))
        manager.updateQuarter(quarter: .Regular(-1))
        XCTAssertEqual(manager.currentQuarter, Time.Quarter.Regular(2))
        manager.updateQuarter(quarter: .Regular(10))
        XCTAssertEqual(manager.currentQuarter, Time.Quarter.Regular(2))
        manager.updateQuarter(quarter: .Overtime(1))
        XCTAssertEqual(manager.currentQuarter, Time.Quarter.Regular(2))
    }
}
