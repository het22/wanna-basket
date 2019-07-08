//
//  GameTimeModel.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

protocol GameTimeDelegate {
    func didQuarterUpdate()
    func didGameClockUpdate(gameClock: Float, isRunning: Bool)
    func didShotClockUpdate(shotClock: Float, isRunning: Bool)
}

class TimeManager {

    var delegate: GameTimeDelegate?
    
    let maxGameClock: Float = 600.0
    let maxOverTimeClock: Float = 300.0
    let maxShotClock: Float = 24.0
    var maxRegularQuarterNum: Int
    
    init(maxRegularQuarterNum: Int) {
        self.maxRegularQuarterNum = maxRegularQuarterNum
        for i in 1...maxRegularQuarterNum {
            times.append(Time(quarter: .Regular(i),
                                 gameClock: maxGameClock,
                                 shotClock: maxShotClock))
        }
    }
    
    var times: [Time] = []
    var currentQuarter: Time.Quarter = .Regular(1)
    var currentTime: Time {
        get {
            switch currentQuarter {
            case .Regular(let num):
                return times[num-1]
            case .Overtime(let num):
                return times[maxRegularQuarterNum+num-1]
            }
        }
        set(newVal) {
            switch currentQuarter {
            case .Regular(let num):
                times[num-1].gameClock = newVal.gameClock
                times[num-1].shotClock = newVal.shotClock
            case .Overtime(let num):
                times[maxRegularQuarterNum+num-1].gameClock = newVal.gameClock
                times[maxRegularQuarterNum+num-1].shotClock = newVal.shotClock
            }
        }
    }
    
    func updateQuarter(quarterNum: Int) {
        isGameClockRunning = false
        isShotClockRunning = false
//        currentTimeNum = quarterNum
        delegate?.didGameClockUpdate(gameClock: times[quarterNum].gameClock,
                                     isRunning: false)
        delegate?.didShotClockUpdate(shotClock: times[quarterNum].shotClock,
                                     isRunning: false)
    }
    
    func addGameClock(_ amount: Float) {
        currentTime.gameClock += amount
        if currentTime.gameClock <= 0 {
            currentTime.gameClock = 0.0
            isGameClockRunning = false
        } else if currentTime.gameClock >= maxGameClock {
            currentTime.gameClock = maxGameClock
        }
        delegate?.didGameClockUpdate(gameClock: currentTime.gameClock, isRunning: isGameClockRunning)
    }
    
    func addShotClock(_ amount: Float) {
        currentTime.shotClock += amount
        if currentTime.shotClock <= 0 {
            currentTime.shotClock = 0.0
            isShotClockRunning = false
        } else if currentTime.shotClock >= maxShotClock {
            currentTime.shotClock = maxShotClock
        }
        delegate?.didShotClockUpdate(shotClock: currentTime.shotClock, isRunning: isShotClockRunning)
    }
    
    func resetGameClock(_ gameClock: Float) {
        currentTime.gameClock = gameClock
        isGameClockRunning = false
    }
    
    func resetShotClock(_ shotClock: Float) {
        currentTime.shotClock = shotClock
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
                delegate?.didGameClockUpdate(gameClock: currentTime.gameClock, isRunning: false)
            }
        }
    }
    @objc fileprivate func updateGameClock() {
        currentTime.gameClock -= 0.1
        if currentTime.gameClock <= 0.0 {
            currentTime.gameClock = 0.0
            isGameClockRunning = false
        }
        delegate?.didGameClockUpdate(gameClock: currentTime.gameClock, isRunning: isGameClockRunning)
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
                delegate?.didShotClockUpdate(shotClock: currentTime.shotClock, isRunning: false)
            }
        }
    }
    @objc fileprivate func updateShotClock() {
        currentTime.shotClock -= 0.1
        if currentTime.shotClock <= 0.0 {
            currentTime.shotClock = 0.0
            isShotClockRunning = false
        }
        delegate?.didShotClockUpdate(shotClock: currentTime.shotClock, isRunning: isShotClockRunning)
    }
}
