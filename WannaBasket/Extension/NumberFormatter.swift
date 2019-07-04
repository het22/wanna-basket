//
//  NumberFormatter.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

let shotClockFormat: NumberFormatter = {
    let temp = NumberFormatter()
    temp.numberStyle = .decimal
    temp.minimumFractionDigits = 1
    temp.maximumFractionDigits = 1
    return temp
}()

let gameClockFormat: NumberFormatter = {
    let temp = NumberFormatter()
    temp.numberStyle = .decimal
    temp.minimumIntegerDigits = 2
    temp.maximumIntegerDigits = 2
    return temp
}()

