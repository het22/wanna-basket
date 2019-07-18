//
//  RealmTeam.swift
//  WannaBasket
//
//  Created by Het Song on 17/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import RealmSwift

class RealmTeam: RealmObject {
    
    @objc dynamic var name: String = ""
    @objc dynamic var _playerInfor: String = ""
    
    var playerInfor: [Int:String] {
        get { return _playerInfor.convertToDictionary() as [Int:String] }
        set { if let json = newValue.convertToJson() { _playerInfor = json } }
    }
}
