//
//  Dictionary+Extension.swift
//  WannaBasket
//
//  Created by Het Song on 18/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func convertToJson() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let json = String(data: jsonData, encoding: .utf8) {
                return json
            } else {
                print("ConvertToJson Fail: Cannot cast jsonData to jsonString.")
                return ""
            }
        } catch {
            print("ConvertToJson Fail: \(error.localizedDescription)")
            return ""
        }
    }
}
