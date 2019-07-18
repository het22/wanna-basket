//
//  Persistable.swift
//  WannaBasket
//
//  Created by Het Song on 18/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import RealmSwift

protocol Persistable {
    associatedtype RealmdObject: RealmSwift.Object
    init(realmObject: RealmdObject)
    func realmObject() -> RealmdObject
}
