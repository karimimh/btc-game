//
//  GameOrder.swift
//  BitMEX
//
//  Created by Behnam Karimi on 8/25/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import Foundation
import os.log

class GameOrder: NSObject, NSCoding {
    var symbol: String = "XBTUSD"
    var qty: Double = 0
    var price: Double = 0
    var leverage: Double = 1.0
    var id: String = ""
    var side: String = "Buy" // Buy, Sell
    var type: String = "Market" // Market, Limit, Stop
    var status: String = "Open" // Open, Executed, Failed, Cancelled
    
    init(id: String, symbol: String, qty: Double, price: Double, leverage: Double, type: String, side: String, status: String) {
        self.symbol = symbol
        self.qty = qty
        self.price = price
        self.id = id
        self.type = type
        self.status = status
        self.side = side
        self.leverage = leverage
    }
    
    
    //MARK: - NSCoding
    private struct Key {
        static let symbol = "GameOrder.symbol"
        static let id = "GameOrder.id"
        static let qty = "GameOrder.qty"
        static let price = "GameOrder.price"
        static let type = "GameOrder.type"
        static let status = "GameOrder.status"
        static let side = "GameOrder.side"
        static let leverage = "GameOrder.leverage"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(symbol, forKey: Key.symbol)
        aCoder.encode(id, forKey: Key.id)
        aCoder.encode(qty, forKey: Key.qty)
        aCoder.encode(price, forKey: Key.price)
        aCoder.encode(type, forKey: Key.type)
        aCoder.encode(status, forKey: Key.status)
        aCoder.encode(side, forKey: Key.side)
        aCoder.encode(leverage, forKey: Key.leverage)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let symbol = aDecoder.decodeObject(forKey: Key.symbol) as? String else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let id = aDecoder.decodeObject(forKey: Key.id) as? String else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let qty = aDecoder.decodeObject(forKey: Key.qty) as? Double else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let price = aDecoder.decodeObject(forKey: Key.price) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let type = aDecoder.decodeObject(forKey: Key.type) as? String else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let status = aDecoder.decodeObject(forKey: Key.status) as? String else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let side = aDecoder.decodeObject(forKey: Key.side) as? String else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let leverage = aDecoder.decodeObject(forKey: Key.leverage) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: type, side: side, status: status)
    }
}
