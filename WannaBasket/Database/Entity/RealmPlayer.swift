//
//  RealmPlayer.swift
//  WannaBasket
//
//  Created by Het Song on 17/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import RealmSwift

class RealmPlayer: RealmObject {
    
    @objc dynamic var name: String = ""
    @objc dynamic var _teamInfor: String = ""
    
    var teamInfor: [String:Int] {
        get { return _teamInfor.convertToDictionary() as [String:Int] }
        set { if let json = newValue.convertToJson() { _teamInfor = json } }
    }
}
