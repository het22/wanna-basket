//
//  String+Extension.swift
//  WannaBasket
//
//  Created by Het Song on 18/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import Foundation

extension String {
    
    func convertToDictionary<T1,T2>() -> [T1:T2] where T1: Hashable {
        guard let data = self.data(using: .utf8) else {
            print("ConvertToDictionary Fail: String->Data Error.")
            return [:]
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [T1: T2] {
                return dictionary
            } else {
                print("ConvertToDictionary Fail: Cannot cast json to [\(T1.self):\(T2.self)].")
                return [:]
            }
        } catch {
            print("ConvertToDictionary Fail: \(error.localizedDescription)")
            return [:]
        }
    }
}
