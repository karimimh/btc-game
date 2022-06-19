//
//  GamePosition.swift
//  BitMEX
//
//  Created by Behnam Karimi on 8/25/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit
import os.log

class GamePosition: NSObject, NSCoding {
    var symbol: String = "XBTUSD"
    var side: String = "Long"
    var qty: Double = 0
    var entry: Double = 0
    var closePrice: Double? = nil
    var stopPrice: Double? = nil
    var liquidationPrice: Double = 0
    var leverage: Double = 1
    
    init(symbol: String, side: String, qty: Double = 0, entry: Double = 0, closePrice: Double? = nil, stopPrice: Double? = nil, liquidationPrice: Double = 0, leverage: Double = 1) {
        self.symbol = symbol
        self.side = side
        self.qty = qty
        self.entry = entry
        self.closePrice = closePrice
        self.stopPrice = stopPrice
        self.liquidationPrice = liquidationPrice
        self.leverage = leverage
    }
    
    
    func getMargin(lastPrice: Double) -> Double {
        let q = qty
        let e = entry
        let l = leverage
        let p = lastPrice
        
        let m_i = q / (e * l)
        var profit = m_i * l * (p - e) / e
        if side.lowercased() == "short" {
            profit = -profit
        }
        let m = m_i + profit
        return m
    }
    
    func getUpnl(lastPrice: Double) -> Double {
        let q = qty
        let e = entry
        let l = leverage
        let p = lastPrice
        
        let m_i = q / (e * l)
        var profit = m_i * l * (p - e) / e
        if side.lowercased() == "short" {
            profit = -profit
        }
        return profit
    }
    
    func getUpnlPcnt(lastPrice: Double) -> Double {
        let q = qty
        let e = entry
        let l = leverage
        let p = lastPrice
        
        let m_i = q / (e * l)
        var profit = m_i * l * (p - e) / e
        if side.lowercased() == "short" {
            profit = -profit
        }
        return 100.0 * profit / m_i
    }
    
    
    //MARK: - NSCoding
    private struct Key {
        static let symbol = "GamePosition.symbol"
        static let side = "GamePosition.side"
        static let qty = "GamePosition.qty"
        static let entry = "GamePosition.entry"
        static let closePrice = "GamePosition.closePrice"
        static let stopPrice = "GamePosition.stopPrice"
        static let liquidationPrice = "GamePosition.liquidationPrice"
        static let leverage = "GamePosition.leverage"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(symbol, forKey: Key.symbol)
        aCoder.encode(side, forKey: Key.side)
        aCoder.encode(qty, forKey: Key.qty)
        aCoder.encode(entry, forKey: Key.entry)
        aCoder.encode(closePrice, forKey: Key.closePrice)
        aCoder.encode(stopPrice, forKey: Key.stopPrice)
        aCoder.encode(liquidationPrice, forKey: Key.liquidationPrice)
        aCoder.encode(leverage, forKey: Key.leverage)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let symbol = aDecoder.decodeObject(forKey: Key.symbol) as? String else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let side = aDecoder.decodeObject(forKey: Key.side) as? String else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let qty = aDecoder.decodeObject(forKey: Key.qty) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let entry = aDecoder.decodeObject(forKey: Key.entry) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        let closePrice = aDecoder.decodeObject(forKey: Key.closePrice) as? Double
        let stopPrice = aDecoder.decodeObject(forKey: Key.stopPrice) as? Double
        guard let liquidationPrice = aDecoder.decodeObject(forKey: Key.liquidationPrice) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let leverage = aDecoder.decodeObject(forKey: Key.leverage) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(symbol: symbol, side: side, qty: qty, entry: entry, closePrice: closePrice, stopPrice: stopPrice, liquidationPrice: liquidationPrice, leverage: leverage)
    }
}
