//
//  RealmDB.swift
//  WannaBasket
//
//  Created by Het Song on 17/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

class RealmDB {
    static let shared: RealmDB = RealmDB()
    private init() {
        print("Realm Database Initialized.")
    }
}
