//
//  NumberFormatter.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

let gameClockFormat: NumberFormatter = {
    let format = NumberFormatter()
    format.numberStyle = .decimal
    format.maximumIntegerDigits = 2
    return format
}()

let shotClockFormat: NumberFormatter = {
    let format = NumberFormatter()
    format.numberStyle = .decimal
    format.minimumFractionDigits = 1
    format.maximumFractionDigits = 1
    return format
}()

let scoreFormat: NumberFormatter = {
    let format = NumberFormatter()
    format.numberStyle = .decimal
    format.maximumIntegerDigits = 3
    format.minimumIntegerDigits = 3
    return format
}()
