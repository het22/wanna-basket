//
//  RealmObject.swift
//  WannaBasket
//
//  Created by Het Song on 18/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import RealmSwift

class RealmObject: Object {
    @objc dynamic var uuid: String = UUID().uuidString
    override class func primaryKey() -> String? { return "uuid" }
}
