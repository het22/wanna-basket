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
        static let Background = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        static let HomeDefault = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        static let AwayDefault = #colorLiteral(red: 1, green: 0.3195095657, blue: 0.4566315059, alpha: 1)
    }
    
    enum Text {
        static let Game = "Game".localized
        static let Setting = "SETTING".localized
        static let Start = "START".localized

        static let Home = "HOME".localized
        static let Away = "AWAY".localized
        static let HomeTeam = "HOME TEAM".localized
        static let AwayTeam = "AWAY TEAM".localized
        
        static let Substitute = "SUB".localized
        static let SubstituteComplete = "SUB COMPLETE".localized
        
        static let Complete = "COMPLETE".localized
        static let Delete = "DELETE".localized
        static let Edit = "EDIT".localized
        static let Cancel = "CANCEL".localized
        static let Undo = "UNDO".localized
        static let Back = "BACK".localized
        static let Exit = "EXIT".localized
        static let Record = "RECORD".localized
        
        enum Placeholder {
            static let AddTeam = "Add New Team".localized
            static let SelectTeam = "Select Team".localized
            static let AddPlayer = "Add New Player".localized
            static let SubPlayer = "Substitute Players".localized
            static let EnterTeamName = "Enter Team Name".localized
            static let EnterPlayerName = "Enter Player Name".localized
            static let ExitWarning = "ExitWarning".localized
            static let RecordWarning = "RecordWarning".localized
        }
    }
    
    enum Regex {
        static let TeamName = "[가-힣A-Za-z0-9\\s]{2,6}"
        static let PlayerName = "[가-힣A-Za-z0-9\\s]{2,6}"
    }
    
    enum Format: CustomStringConvertible {
        case GameClock(Float)
        case ShotClock(Float)
        case PlayerNumber(Int)
        
        var description: String {
            switch self {
            case .GameClock(let clock):
                if clock >= 60.0 {
                    let min = Int(clock) / 60
                    let sec = Int(clock) % 60
                    return gameClockFormat.string(from: NSNumber(integerLiteral: min))! + ":" + gameClockFormat.string(from: NSNumber(integerLiteral: sec))!
                } else {
                    return shotClockFormat.string(from: NSNumber(value: clock))!
                }
            case .ShotClock(let clock):
                return shotClockFormat.string(from: NSNumber(value: clock))!
            case .PlayerNumber(let num):
                return (num==100) ? "00" : "\(num)"
            }
        }
            
        enum Weekday: Int, CustomStringConvertible {
            case Sun = 1
            case Mon = 2
            case Tue = 3
            case Wed = 4
            case Thu = 5
            case Fri = 6
            case Sat = 7
            
            var description: String {
                switch self {
                case .Sun: return "SUN".localized
                case .Mon: return "MON".localized
                case .Tue: return "TUE".localized
                case .Wed: return "WED".localized
                case .Thu: return "THU".localized
                case .Fri: return "FRI".localized
                case .Sat: return "SAT".localized
                }
            }
        }
    }
}
