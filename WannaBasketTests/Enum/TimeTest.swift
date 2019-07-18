//
//  TimeTest.swift
//  WannaBasketTests
//
//  Created by Het Song on 09/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import XCTest
@testable import WannaBasket

class TimeTest: XCTestCase {
    
    var timeA: Time!
    var timeB: Time!
    var timeC: Time!
    
    override func setUp() {
        timeA = Time(quarter: .Regular(1),
                     gameClock: 562.0,
                     shotClock: 24.0)
        timeB = Time(quarter: .Regular(1),
                     gameClock: 562.0,
                     shotClock: 24.0)
        timeC = Time(quarter: .Overtime(1),
                     gameClock: 22.0,
                     shotClock: 24.0)
    }
    
    func testQuarterEquatable() {
        XCTAssertEqual(timeA.quarter, timeB.quarter)
        XCTAssertNotEqual(timeA.quarter, timeC.quarter)
    }
    
    func testTimeEquatable() {
        XCTAssertEqual(timeA, timeB)
        XCTAssertNotEqual(timeA, timeC)
    }
    
    func testGameClockDescription() {
        let testDesc1 = Constants.Format.GameClock(562.0)
        let resultDesc1  = "09:22"
        XCTAssertEqual("\(testDesc1)", resultDesc1)
        
        let testDesc2 = Constants.Format.GameClock(14.0)
        let resultDesc2  = "14.0"
        XCTAssertEqual("\(testDesc2)", resultDesc2)
    }
    
    func testShotClockDescription() {
        let testDesc1 = Constants.Format.ShotClock(14.0)
        let resultDesc1  = "14.0"
        XCTAssertEqual("\(testDesc1)", resultDesc1)
        
        let testDesc2 = Constants.Format.ShotClock(14.03)
        let resultDesc2  = "14.0"
        XCTAssertEqual("\(testDesc2)", resultDesc2)
    }
}
