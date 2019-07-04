//
//  GameTimeModel.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol GameTimeModel {
    
}

class GameTime: GameTimeModel {

    var quarters: [Quarter]
    var currentQuarterNum: Int
    
    let fullGameClock: Float = 600.0
    let fullOverTimeClock: Float = 300.0
    let fullShotClock: Float = 24.0
    
    init(numberOfQuarter: Int) {
        quarters = []
        for i in 0 ... numberOfQuarter-1 {
            let quarter = Quarter(number: i, gameClock: fullGameClock, shotClock: fullShotClock)
            quarters.append(quarter)
        }
        currentQuarterNum = 0
    }
    
    func addQuarter() {
        let number = quarters.count
        let quarter = Quarter(number: number, gameClock: fullGameClock, shotClock: fullShotClock)
        quarters.append(quarter)
    }
    
    func addOverTime() {
        let number = quarters.count
        let quarter = Quarter(number: number, gameClock: fullOverTimeClock, shotClock: fullShotClock)
        quarters.append(quarter)
    }
    
    private var gameClockTimer: Timer?
    private var _isGameClockRunning = false
    public var isGameClockRunning: Bool {
        get { return _isGameClockRunning }
        set(newVal) {
            if _isGameClockRunning == newVal { return }
            _isGameClockRunning = newVal
            if newVal {
                gameClockTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                      target: self,
                                                      selector: #selector(updateGameClock),
                                                      userInfo: nil,
                                                      repeats: true)
            } else {
                gameClockTimer?.invalidate()
            }
        }
    }
    @objc func updateGameClock() {
        quarters[currentQuarterNum].gameClock -= 0.1
        if quarters[currentQuarterNum].gameClock <= 0.0 {
            isGameClockRunning = false
        }
    }
    
    private var shotClockTimer: Timer?
    private var _isShotClockRunning = false
    public var isShotClockRunning: Bool {
        get { return _isShotClockRunning }
        set(newVal) {
            if _isShotClockRunning == newVal { return }
            _isShotClockRunning = newVal
            if newVal {
                shotClockTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                      target: self,
                                                      selector: #selector(updateShotClock),
                                                      userInfo: nil,
                                                      repeats: true)
            } else {
                shotClockTimer?.invalidate()
            }
        }
    }
    @objc func updateShotClock() {
        quarters[currentQuarterNum].shotClock -= 0.1
        if quarters[currentQuarterNum].shotClock <= 0.0 {
            isShotClockRunning = false
        }
    }
}

struct Quarter {
    
    var number: Int
    var gameClock: Float
    var shotClock: Float
}
