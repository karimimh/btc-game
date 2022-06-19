//
//  Timeframe.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/1/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

enum Timeframe: String {
    case oneMinute = "1m"
    case fiveMinutes = "5m"
    case fifteenMinutes = "15m"
    case thirtyMinutes = "30m"
    case hourly = "1h"
    case twoHourly = "2h"
    case fourHourly = "4h"
    case twelveHourly = "12h"
    case daily = "1d"
    case weekly = "1w"
    case monthly = "1M"
    
    
    static func allValues() -> [String] {
        return ["1m", "5m", "15m", "30m", "1h", "2h", "4h", "12h", "1d", "1w", "1M"]
    }
    
    func toMinutes() -> Int {
        switch self {
        case .oneMinute:
            return 1
        case .fiveMinutes:
            return 5
        case .fifteenMinutes:
            return 15
        case .thirtyMinutes:
            return 30
        case .hourly:
            return 60
        case .twoHourly:
            return 120
        case .fourHourly:
            return 240
        case .twelveHourly:
            return 720
        case .daily:
            return 1440
        case .weekly:
            return 10080
        case .monthly:
            return 43200 // 30 day month
        }
    }
    
    func pretty() -> String {
        switch self {
        case .oneMinute, .fiveMinutes, .fifteenMinutes, .thirtyMinutes:
            return rawValue
        case .hourly, .twoHourly, .fourHourly, .twelveHourly:
            return rawValue.uppercased()
        case .daily, .weekly, .monthly:
            return rawValue.uppercased()
        }
    }
    
    static func fromPretty(p: String) -> Timeframe {
        if p == "1M" {
            return .monthly
        } else if p.uppercased() == p {
            return Timeframe(rawValue: p.lowercased())!
        } else {
            return Timeframe(rawValue: p)!
        }
    }
    
    func lowerTimeframe() -> Timeframe {
        if self == .oneMinute {
            return .oneMinute
        } else {
            let index = Timeframe.allValues().firstIndex(of: self.rawValue)!
            return Timeframe(rawValue: Timeframe.allValues()[index - 1])!
        }
    }
}
