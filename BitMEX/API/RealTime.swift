//
//  RealTime.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/9/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class RealTime {

    static func processPayload(payload: [String: Any], partial: Any? = nil) -> [String: Any]? {
        guard let _ = payload["table"] as? String else {
            return nil
        }
        
        guard let action = payload["action"] as? String else {
            return nil
        }
        
        switch action {
        case "partial":
            guard payload["data"] != nil else {
                return nil
            }
            return payload
        case "update":
            guard let partial = partial as? [String: Any] else {
                return nil
            }
            guard let keys = partial["keys"] as? [String] else {
                return nil
            }
            guard let types = partial["types"] as? [String: String] else {
                return nil
            }
            if let data = payload["data"] as? [String: Any] {
                guard let previousData = partial["data"] as? [String: Any] else {
                    return nil
                }
                if rowMatch(data, previousData, keys: keys, keyTypes: types) {
                    let newData = updateRow(previousVersion: partial, newVersion: data, types: types)
                    var result = partial
                    result["data"] = newData
                    return result
                } else {
                    return nil
                }
            } else if let data = payload["data"] as? [[String: Any]]  {
                guard let previousData = partial["data"] as? [[String: Any]] else {
                    return nil
                }
                var result = previousData
                for j in 0 ..< previousData.count {
                    for d in data {
                        if rowMatch(d, previousData[j], keys: keys, keyTypes: types) {
                            if let r = updateRow(previousVersion: previousData[j], newVersion: d, types: types) {
                                result[j] = r
                            }
                            break
                        }
                    }
                }
                var r = partial
                r["data"] = result
                return r
            }
            return nil
        case "insert":
            guard let partial = partial as? [String: Any] else {
                return nil
            }
            if let data = payload["data"] as? [[String: Any]]  {
                guard var previousData = partial["data"] as? [[String: Any]] else {
                    return nil
                }
                previousData.insert(contentsOf: data, at: 0)
                var result = partial
                result["data"] = previousData
                return result
            }
            return partial
        case "delete":
            guard let partial = partial as? [String: Any] else {
                return nil
            }
            guard let keys = partial["keys"] as? [String] else {
                return nil
            }
            guard let types = partial["types"] as? [String: String] else {
                return nil
            }
            if let data = payload["data"] as? [[String: Any]]  {
                guard let previousData = partial["data"] as? [[String: Any]] else {
                    return nil
                }
                var indices = [Int]()
                for j in 0 ..< data.count {
                    for i in 0 ..< previousData.count {
                        if rowMatch(previousData[i], data[j], keys: keys, keyTypes: types) {
                            indices.append(i)
                            break
                        }
                    }
                }
                var newData = [[String: Any]]()
                for i in 0 ..< previousData.count {
                    if !indices.contains(i) {
                        newData.append(previousData[i])
                    }
                }
                
                
                var result = partial
                result["data"] = newData
                return result
            }
            return partial
        default:
            return nil
        }
    }
    
    
    private static func updateRow(previousVersion row1: [String: Any], newVersion row2: [String: Any], types: [String: String]) -> [String: Any]? {
        var result = row1
        for (k, v) in row2 {
            guard let type = types[k] else {
                return nil
            }
            switch type {
            case "symbol":
                fallthrough
            case "timestamp":
                fallthrough
            case "guid":
                fallthrough
            case "timespan":
                fallthrough
            case "string":
                if let s = v as? String {
                    if result[k] == nil {
                        result[k] = s
                    } else if !s.isEmpty {
                        result[k] = s
                    }
                }
            case "float":
                if let s = v as? Double {
                    result[k] = s
                }
            case "long":
                fallthrough
            case "integer":
                if let s = v as? Int {
                    result[k] = s
                }
            case "boolean":
                if let s = v as? Bool {
                    result[k] = s
                }
            default:
                result[k] = nil
                print("OOPS!")
                print(row2)
                print(types)
                break
            }
        }
        return result
    }
    
    private static func rowMatch(_ row1: [String: Any], _ row2: [String: Any], keys: [String], keyTypes: [String: String]) -> Bool {
        for key in keys {
            guard row1[key] != nil && row2[key] != nil else {
                return false
            }
            guard let keyType = keyTypes[key] else {
                return false
            }
            switch keyType {
            case "symbol":
                fallthrough
            case "guid":
                fallthrough
            case "timestamp":
                fallthrough
            case "timespan":
                guard let r1 = row1[key] as? String, let r2 = row2[key] as? String else {
                    return false
                }
                if r1 != r2 {
                    return false
                }
            case "float":
                guard let r1 = row1[key] as? Double, let r2 = row2[key] as? Double else {
                    return false
                }
                if r1 != r2 {
                    return false
                }
            case "long":
                fallthrough
            case "integer":
                guard let r1 = row1[key] as? Int, let r2 = row2[key] as? Int else {
                    return false
                }
                if r1 != r2 {
                    return false
                }
            case "boolean":
                guard let r1 = row1[key] as? Bool, let r2 = row2[key] as? Bool else {
                    return false
                }
                if r1 != r2 {
                    return false
                }
            default:
                break
            }
        }
        return true
    }
    
    
    struct Subscriptions {
        //Unsigned:
        static let announcement = "announcement"       // Site announcements
        static let chat = "chat"                // Trollbox chat
        static let connected = "connected"          // Statistics of connected users/bots
        static let funding = "funding"             // Updates of swap funding rates. Sent every funding interval (usually 8hrs)
        static let instrument = "instrument"          // Instrument updates including turnover and bid/ask
        static let insurance = "insurance"           // Daily Insurance Fund updates
        static let liquidation = "liquidation"         // Liquidation orders as they're entered into the book
        static let orderBookL2_25 = "orderBookL2_25"      // Top 25 levels of level 2 order book
        static let orderBookL2 = "orderBookL2"         // Full level 2 order book
        static let orderBook10 = "orderBook10"         // Top 10 levels using traditional full book push
        static let publicNotifications = "publicNotifications" // System-wide notifications (used for short-lived messages)
        static let quote = "quote"               // Top level of the book
        static let quoteBin1m = "quoteBin1m"          // 1-minute quote bins
        static let quoteBin5m = "quoteBin5m"          // 5-minute quote bins
        static let quoteBin1h = "quoteBin1h"          // 1-hour quote bins
        static let quoteBin1d = "quoteBin1d"          // 1-day quote bins
        static let settlement = "settlement"          // Settlements
        static let trade = "trade"               // Live trades
        static let tradeBin1m = "tradeBin1m"          // 1-minute trade bins
        static let tradeBin5m = "tradeBin5m"          // 5-minute trade bins
        static let tradeBin1h = "tradeBin1h"          // 1-hour trade bins
        static let tradeBin1d = "tradeBin1d"          // 1-day trade bins
        
        //Signed:
        static let affiliate = "affiliate"   // Affiliate status, such as total referred users & payout %
        static let execution = "execution"   // Individual executions; can be multiple per order
        static let order = "order"       // Live updates on your orders
        static let margin = "margin"      // Updates on your current account balance and margin requirements
        static let position = "position"    // Updates on your positions
        static let privateNotifications = "privateNotifications" // Individual notifications - currently not used
        static let transact = "transact"     // Deposit/Withdrawal updates
        static let wallet = "wallet"       // Bitcoin address balance data, including total deposits & withdrawals
    }
    
    struct Subscription {
        var args = ""
    }
    
    
    
    private struct Commands {
        static let subscribe = "subscribe"
        static let unsubscribe = "unsubscribe"
        
        // And some more (Not Implemented for Now)
    }
}
