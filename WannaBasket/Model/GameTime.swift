//
//  GameTimeModel.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol GameTimeDelegate {
    func didGameClockUpdate(gameClock: Float, isRunning: Bool)
    func didShotClockUpdate(shotClock: Float, isRunning: Bool)
}

class GameTime {

    var delegate: GameTimeDelegate?
    
    var quarters: [Quarter] = []
    var currentQuarter: Quarter {
        get { return quarters[currentQuarterNum] }
        set(newVal) { quarters[currentQuarterNum] = newVal }
    }
    var currentQuarterNum: Int = 0
    var maxRegularQuarterNum: Int
    
    let maxGameClock: Float = 600.0
    let maxOverTimeClock: Float = 300.0
    let maxShotClock: Float = 24.0
    
    init(maxRegularQuarterNum: Int) {
        self.maxRegularQuarterNum = maxRegularQuarterNum
        for _ in 0...maxRegularQuarterNum-1 {
            quarters.append(Quarter(type: .Regular,
                                    gameClock: maxGameClock,
                                    shotClock: maxShotClock))
        }
    }
    
    func updateQuarter(quarterNum: Int) {
        isGameClockRunning = false
        isShotClockRunning = false
        currentQuarterNum = quarterNum
        delegate?.didGameClockUpdate(gameClock: quarters[quarterNum].gameClock,
                                     isRunning: false)
        delegate?.didShotClockUpdate(shotClock: quarters[quarterNum].shotClock,
                                     isRunning: false)
    }
    
    func addGameClock(_ amount: Float) {
        currentQuarter.gameClock += amount
        if currentQuarter.gameClock <= 0 {
            currentQuarter.gameClock = 0.0
            isGameClockRunning = false
        } else if currentQuarter.gameClock >= maxGameClock {
            currentQuarter.gameClock = maxGameClock
        }
        delegate?.didGameClockUpdate(gameClock: currentQuarter.gameClock, isRunning: isGameClockRunning)
    }
    
    func addShotClock(_ amount: Float) {
        currentQuarter.shotClock += amount
        if currentQuarter.shotClock <= 0 {
            currentQuarter.shotClock = 0.0
            isShotClockRunning = false
        } else if currentQuarter.shotClock >= maxShotClock {
            currentQuarter.shotClock = maxShotClock
        }
        delegate?.didShotClockUpdate(shotClock: currentQuarter.shotClock, isRunning: isShotClockRunning)
    }
    
    func resetGameClock(_ gameClock: Float) {
        currentQuarter.gameClock = gameClock
        isGameClockRunning = false
    }
    
    func resetShotClock(_ shotClock: Float) {
        currentQuarter.shotClock = shotClock
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
                delegate?.didGameClockUpdate(gameClock: currentQuarter.gameClock, isRunning: false)
            }
        }
    }
    @objc fileprivate func updateGameClock() {
        currentQuarter.gameClock -= 0.1
        if currentQuarter.gameClock <= 0.0 {
            currentQuarter.gameClock = 0.0
            isGameClockRunning = false
        }
        delegate?.didGameClockUpdate(gameClock: currentQuarter.gameClock, isRunning: isGameClockRunning)
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
                delegate?.didShotClockUpdate(shotClock: currentQuarter.shotClock, isRunning: false)
            }
        }
    }
    @objc fileprivate func updateShotClock() {
        currentQuarter.shotClock -= 0.1
        if currentQuarter.shotClock <= 0.0 {
            currentQuarter.shotClock = 0.0
            isShotClockRunning = false
        }
        delegate?.didShotClockUpdate(shotClock: currentQuarter.shotClock, isRunning: isShotClockRunning)
    }
}
