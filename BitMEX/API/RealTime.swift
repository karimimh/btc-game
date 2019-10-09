//
//  RealTime.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/9/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class RealTime {
    static var webSocket: WebSocket?
    private static var subscriptions = [Subscription]()
    
    private init() {}
    static func startWebSocket() -> WebSocket? {
        webSocket?.close()
        webSocket = nil
        let url = "wss://www.bitmex.com/realtime"
        webSocket = WebSocket(url)
        return webSocket
    }
    
    static func subscribe(subscription: String, symbol: String? = nil)  -> Subscription? {
        guard let webSocket = self.webSocket else { return nil }
        
        switch subscription {
        case Subscriptions.trade:
            var args: String = "\"trade"
            if let symbol = symbol {
                args += ":\(symbol)"
            }
            args += "\""
            let message: String = "{\"op\": \"" + Commands.subscribe + "\", \"args\": [" + args + "]}"
            let sss = Subscription(args: args)
            subscriptions.append(sss)
            webSocket.send(text: message)
            return sss
        default:
            //NOT Implemented!
            break
        }
        
        return nil
    }
    
    
    static func unsubscribe(subscription: Subscription) {
        guard let webSocket = self.webSocket else { return }
        
        for i in 0 ..< subscriptions.count {
            let sub = subscriptions[i]
            if sub.args == subscription.args {
                let message: String = "{\"op\": \"" + Commands.unsubscribe + "\", \"args\": [" + subscription.args + "]}"
                webSocket.send(text: message)
                subscriptions.remove(at: i)
                break
            }
        }
        
        
    }
    
    
    static func unscubscribeAll() {
        guard let webSocket = self.webSocket else { return }
        
        for sub in subscriptions {
            let message: String = "{\"op\": \"" + Commands.unsubscribe + "\", \"args\": [" + sub.args + "]}"
            webSocket.send(text: message)
        }
        subscriptions.removeAll()
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
