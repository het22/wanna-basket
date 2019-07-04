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

protocol GameTimeDelegate {
    func didGameClockUpdate(gameClock: Float, isRunning: Bool)
    func didShotClockUpdate(shotClock: Float, isRunning: Bool)
}

class GameTime: GameTimeModel {

    var delegate: GameTimeDelegate?
    
    var quarters: [Quarter] = []
    var currentQuarter: Int = 0
    
    let fullGameClock: Float = 600.0
    let fullOverTimeClock: Float = 300.0
    let fullShotClock: Float = 24.0
    
    init(numberOfQuarter: Int) {
        for i in 0 ... numberOfQuarter-1 {
            let quarter = Quarter(number: i, gameClock: fullGameClock, shotClock: fullShotClock)
            quarters.append(quarter)
        }
    }
    
    func updateQuarter(newQuarter: Int) {
        isGameClockRunning = false
        isShotClockRunning = false
        currentQuarter = newQuarter
        delegate?.didGameClockUpdate(gameClock: quarters[currentQuarter].gameClock, isRunning: false)
        delegate?.didShotClockUpdate(shotClock: quarters[currentQuarter].shotClock, isRunning: false)
    }
    
    func resetGameClock(gameClock: Float) {
        quarters[currentQuarter].gameClock = gameClock
        isGameClockRunning = false
    }
    
    func resetShotClock(shotClock: Float) {
        quarters[currentQuarter].shotClock = shotClock
        isShotClockRunning = false
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
                delegate?.didGameClockUpdate(gameClock: quarters[currentQuarter].gameClock, isRunning: false)
            }
        }
    }
    @objc private func updateGameClock() {
        quarters[currentQuarter].gameClock -= 0.1
        if quarters[currentQuarter].gameClock <= 0.0 {
            quarters[currentQuarter].gameClock = 0.0
            isGameClockRunning = false
        }
        delegate?.didGameClockUpdate(gameClock: quarters[currentQuarter].gameClock, isRunning: isGameClockRunning)
    }
    
    private var shotClockTimer: Timer?
    private var _isShotClockRunning = false
    public var isShotClockRunning: Bool {
        get { return _isShotClockRunning }
        set(newVal) {
            if _isShotClockRunning == newVal && _isShotClockRunning { return }
            _isShotClockRunning = newVal
            if newVal {
                shotClockTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                      target: self,
                                                      selector: #selector(updateShotClock),
                                                      userInfo: nil,
                                                      repeats: true)
            } else {
                shotClockTimer?.invalidate()
                delegate?.didShotClockUpdate(shotClock: quarters[currentQuarter].shotClock, isRunning: false)
            }
        }
    }
    @objc private func updateShotClock() {
        quarters[currentQuarter].shotClock -= 0.1
        if quarters[currentQuarter].shotClock <= 0.0 {
            quarters[currentQuarter].shotClock = 0.0
            isShotClockRunning = false
        }
        delegate?.didShotClockUpdate(shotClock: quarters[currentQuarter].shotClock, isRunning: isShotClockRunning)
    }
}

struct Quarter {
    var number: Int
    var gameClock: Float
    var shotClock: Float
}
