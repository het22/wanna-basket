//
//  Constants.swift
//  WannaBasket
//
//  Created by Het Song on 04/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

enum Constants {
    
    enum Color {
        static let Black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let Steel = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        static let Silver = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        static let Mercury = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        static let White = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static let HomeDefault = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        static let AwayDefault = #colorLiteral(red: 1, green: 0.3195095657, blue: 0.4566315059, alpha: 1)
    }
    
    enum Text {
        static let HomeDefault = "홈팀"
        static let AwayDefault = "원정팀"
        
        static let Substitute = "교체"
        static let SubstituteComplete = "교체 완료"
        
        static let Complete = "완료"
        static let Delete = "삭제"
        static let Edit = "수정"
        static let Cancel = "취소"
        static let Exit = "나가기"
    }
    
    enum Regex {
        static let TeamName = "[가-힣A-Za-z0-9\\s]{2,6}"
        static let PlayerName = "[가-힣A-Za-z0-9\\s]{2,6}"
    }
}
