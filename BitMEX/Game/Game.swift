//
//  Game.swift
//  BitMEX
//
//  Created by Behnam Karimi on 8/25/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Game: NSObject, NSCoding {
    
    var app: App!
    var balance: Double {
        var result = freeBalance
        if let p = self.position, let lastPrice = self.app.chart?.instrument?.lastPrice {
            result += p.getMargin(lastPrice: lastPrice)
        }
        return result
    }
    var freeBalance: Double = 0.0020
    var deposited: Double = 0.0020
    var withdrawn: Double = 0
    var creationTime: Date = Date()
    var position: GamePosition? = nil
    var orders: [GameOrder] = []
    var currentTime: Date = Date(timeIntervalSince1970: 1515922191) {
        didSet {
            DispatchQueue.main.async {
                self.app.chartVC?.currentTimeLabel.text = self.currentTime.bitMEXStringWithSeconds()
            }
        }
    }
    var step: TimeInterval = 0.5
    var isPlaying: Bool {
        return _isPlaying
        
    }
    private var _isPlaying: Bool = false {
        didSet {
            self.statusChanged()
        }
    }
    
    var timer: Timer!
    var tradeBuffer: [Trade] = []
    
    //MARK: - Initialization
    
    init(freeBalance: Double = 0.0020, deposited: Double = 0.0020, withdrawn: Double = 0, creationTime: Date = Date(), position: GamePosition? = nil, orders: [GameOrder] = []) {
        self.freeBalance = freeBalance
        self.deposited = deposited
        self.withdrawn = withdrawn
        self.creationTime = creationTime
        self.position = position
        self.orders = orders
    }
    
    //MARK: - Private Methods
    private func statusChanged() {
        if !isPlaying {
            if timer != nil {
                timer.invalidate()
            }
        } else {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: self.step, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: false)
            }
        }
        
    }
    
    @objc private func timerFunction() {
        self.currentTime.addTimeInterval(step)
        self.timeChanged()
    }
    
    
    
    
    func timeChanged() {
        self.app.getInstrument(self.app.settings.chartSymbol)?.lastPrice = self.app.chart?.candles.first?.close
        DispatchQueue.main.async {
            self.app.walletVC?.update()
            self.app.positionVC?.update()
            self.app.orderVC?.update()
            self.app.openOrdersVC?.update()
        }
        
        if app.chart?.candles.first != nil && app.chart!.candles.first!.closeTime.toMillis() <= currentTime.toMillis() {
            let c = self.app.chart!.candles.first!.close
            let candle = Candle(open: c, close: c, high: c, low: c, volume: 0, timeframe: self.app.chart!.timeframe!, closeTime: self.app.chart!.candles.first!.nextCandleOpenTime().dateBy(adding: self.app.chart!.timeframe!))
            self.app.chart!.candles.insert(candle, at: 0)
            self.app.chart!.indicators.forEach { (indicator) in
                indicator.computeValue(candles: self.app.chart!.candles.reversed())
            }
            DispatchQueue.main.async {
                self.app.chart!.redraw()
            }
        }
        
        guard !tradeBuffer.isEmpty else {
            self.pause()
            downloadNextTrades {
                DispatchQueue.main.async {
                    self.resume()
                }
            }
            return
        }
        
        guard let trades = self.getTrades(startTime: self.currentTime.timeIntervalSince1970 - self.step, endTime: self.currentTime.timeIntervalSince1970) else {
            self.pause()
            self.downloadNextTrades {
                self.resume()
            }
            return
        }
        
        if trades.isEmpty {
            DispatchQueue.main.async {
                self.app.chart!.redraw()
                self.timer = Timer.scheduledTimer(timeInterval: self.step, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: false)
            }
            return
        }
        
        
        var volume: Double = 0
        var high: Double = -Double.greatestFiniteMagnitude
        var low: Double = Double.greatestFiniteMagnitude
        var close: Double = 0
        var _closeTime: Date?
        
        for i in 0 ..< trades.count {
            let trade = trades[i]
            if trade.symbol != self.app.chart!.instrument!.symbol { continue }
            
            if let v = trade.size {
                volume += v
            }
            if let c = trade.price {
                close = c
            }
            if close > high {
                high = close
            }
            if close < low {
                low = close
            }
            if let ct = Date.fromBitMEXString(str: trade.timestamp) {
                _closeTime = ct
            }
        }
        self.app.getInstrument(self.app.settings.chartSymbol)?.lastPrice = close
        guard let closeTime = _closeTime else {return }
        if closeTime.toMillis() < self.app.chart!.candles.first!.nextCandleOpenTime().toMillis() {
            let candle = self.app.chart!.candles.first!
            candle.volume += volume
            candle.close = close
            if low < candle.low {
                candle.low = low
            }
            if high > candle.high {
                candle.high = high
            }
        }
        self.app.chart!.indicators.forEach { (indicator) in
            indicator.computeValue(candles: self.app.chart!.candles.reversed())
        }
        DispatchQueue.main.async {
            self.app.chart!.redraw()
        }
        self.checkOrdersExecution(trades: trades)
        timer = Timer.scheduledTimer(timeInterval: step, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: false)
    }
    
    
    
    private func checkOrdersExecution(trades: [Trade]) {
        guard !trades.isEmpty else {
            return
        }
        var low = Double.greatestFiniteMagnitude
        var high = 0.0
        
        for trade in trades {
            if let price = trade.price {
                if price > high {
                    high = price
                }
                if price < low {
                    low = price
                }
            }
        }
        
        //check liquidation:
        if let position = self.position {
            if position.liquidationPrice >= low && position.liquidationPrice <= high {
                if let stop = position.stopPrice, let o = self.getOpenOrder(symbol: position.symbol, price: stop) {
                    o.status = "Cancelled"
                }
                if let close = position.closePrice, let o = self.getOpenOrder(symbol: position.symbol, price: close) {
                    o.status = "Cancelled"
                }
                self.position = nil
            }
        }
        
        //check orders:
        for order in orders {
            if order.status.lowercased() == "open" {
                let price = order.price
                let side = order.side.lowercased()
                if (side == "buy" && price >= low) ||
                    (side == "sell" && price <= high) {
                    order.status = "Executed"
                    //order executed:
                    if let position = self.position {
                        if (side.lowercased() == "buy" && position.side.lowercased() == "short") ||
                            (side.lowercased() == "sell" && position.side.lowercased() == "long") {
                            self.freeBalance += (position.qty / price) / (1 * position.leverage)
                            position.qty -= order.qty
                            if position.qty <= 0 {
                                self.position = nil
                            }
                        } else if side.lowercased() == "buy" && position.side.lowercased() == "long" {
                            let newEntry = (order.price * order.qty + position.entry * position.qty) / (order.qty + position.qty)
                            position.qty += order.qty
                            let liq = newEntry - newEntry / (position.leverage * (1 - 0))
                            position.liquidationPrice = liq
                        } else if side.lowercased() == "sell" && position.side.lowercased() == "short" {
                            let newEntry = (order.price * order.qty + position.entry * position.qty) / (order.qty + position.qty)
                            position.qty += order.qty
                            let liq = newEntry + newEntry / (position.leverage * (1 - 0))
                            position.liquidationPrice = liq
                        }
                    } else {
                        var liq: Double = 0
                        if side == "buy" {
                            liq = price - price / (order.leverage * (1 - 0))
                        } else {
                            liq = price + price / (order.leverage * (1 - 0))
                        }
                        self.position = GamePosition(symbol: order.symbol, side: order.side == "buy" ? "long" : "short", qty: order.qty, entry: order.price, closePrice: nil, stopPrice: nil, liquidationPrice: liq, leverage: order.leverage)
                    }
                }
            }
        }
        
        
    }
    
    @objc func skipTime(from previousCloseTime: Date, to newTime: Date, completion: (() -> Void)?) {
        let timeframe = app.settings.chartTimeframe
        Candle.download(timeframe: timeframe, instrument: app.chart!.instrument!, partialCandle: true, reverse: false, count: nil, startTime: previousCloseTime.nextOpenTime(timeframe: timeframe)!.dateBy(subtracting: timeframe).bitMEXStringWithSeconds(), endTime: newTime.bitMEXStringWithSeconds()) { (_candles, response, error) in
            guard error == nil else { return }
            guard let resp = response as? HTTPURLResponse else { return }
            guard resp.statusCode == 200 else {return}
            
            if let candles = _candles {
                guard !candles.isEmpty else {
                    completion?()
                    return
                }
                for i in 0 ..< candles.count {
                    let candle = candles[i]
                    if candle.openTime.timeIntervalSince1970 < self.app.chart!.candles.first!.openTime.timeIntervalSince1970 {
                        continue
                    } else if candle.openTime.timeIntervalSince1970 == self.app.chart!.candles.first!.openTime.timeIntervalSince1970 {
                        self.app.chart!.candles.removeFirst()
                    }
                    self.app.chart!.candles.insert(candle, at: 0)
                }
                self.app.chart?.instrument?.lastPrice = self.app.chart?.candles.first?.close
                self.app.chart!.indicators.forEach { (indicator) in
                    indicator.computeValue(candles: self.app.chart!.candles.reversed())
                }
                self.checkOrdersExecution_TimeSkipped(from: previousCloseTime, to: newTime) {
                    completion?()
                }
            }
        }
    }
    
    
    @objc private func checkOrdersExecution_TimeSkipped(from previousCloseTime: Date, to newTime: Date, completion: (() -> Void)?) {
        guard let trades = getTrades(startTime: previousCloseTime.timeIntervalSince1970, endTime: previousCloseTime.nextOpenTime(timeframe: .oneMinute)!.timeIntervalSince1970) else {
            if self.isPlaying {
                self.pause()
            }
            self.downloadNextTrades {
                self.checkOrdersExecution_TimeSkipped(from: previousCloseTime, to: newTime, completion: completion)
            }
            return
        }
        checkOrdersExecution(trades: trades)
        
        Candle.download(timeframe: .oneMinute, instrument: app.chart!.instrument!, partialCandle: true, reverse: true, count: nil, startTime: previousCloseTime.nextOpenTime(timeframe: .oneMinute)!.bitMEXStringWithSeconds(), endTime: newTime.bitMEXStringWithSeconds()) { (_candles, response, error) in
            
            guard error == nil else { return }
            guard let resp = response as? HTTPURLResponse else { return }
            guard resp.statusCode == 200 else { return }
            
            
            if let candles = _candles {
                guard !candles.isEmpty else {
                    completion?()
                    return
                }
                var low = Double.greatestFiniteMagnitude
                var high = 0.0
                
                for candle in candles {
                    if candle.high > high {
                        high = candle.high
                    }
                    if candle.low < low {
                        low = candle.low
                    }
                }
                
                //check liquidation:
                if let position = self.position {
                    if position.liquidationPrice >= low && position.liquidationPrice <= high {
                        if let stop = position.stopPrice, let o = self.getOpenOrder(symbol: position.symbol, price: stop) {
                            o.status = "Cancelled"
                        }
                        if let close = position.closePrice, let o = self.getOpenOrder(symbol: position.symbol, price: close) {
                            o.status = "Cancelled"
                        }
                        self.position = nil
                    }
                }
                
                //check orders:
                for order in self.orders {
                    if order.status.lowercased() == "open" {
                        let price = order.price
                        let side = order.side.lowercased()
                        if (side == "buy" && price >= low) ||
                            (side == "sell" && price <= high) {
                            order.status = "Executed"
                            //order executed:
                            if let position = self.position {
                                if (side.lowercased() == "buy" && position.side.lowercased() == "short") ||
                                    (side.lowercased() == "sell" && position.side.lowercased() == "long") {
                                    self.freeBalance += (position.qty / price) / (1 * position.leverage)
                                    position.qty -= order.qty
                                    if position.qty <= 0 {
                                        self.position = nil
                                    }
                                } else if side.lowercased() == "buy" && position.side.lowercased() == "long" {
                                    let newEntry = (order.price * order.qty + position.entry * position.qty) / (order.qty + position.qty)
                                    position.qty += order.qty
                                    let liq = newEntry - newEntry / (position.leverage * (1 - 0))
                                    position.liquidationPrice = liq
                                } else if side.lowercased() == "sell" && position.side.lowercased() == "short" {
                                    let newEntry = (order.price * order.qty + position.entry * position.qty) / (order.qty + position.qty)
                                    position.qty += order.qty
                                    let liq = newEntry + newEntry / (position.leverage * (1 - 0))
                                    position.liquidationPrice = liq
                                }
                            } else {
                                var liq: Double = 0
                                if side == "buy" {
                                    liq = price - price / (order.leverage * (1 - 0))
                                } else {
                                    liq = price + price / (order.leverage * (1 - 0))
                                }
                                self.position = GamePosition(symbol: order.symbol, side: order.side == "buy" ? "long" : "short", qty: order.qty, entry: order.price, closePrice: nil, stopPrice: nil, liquidationPrice: liq, leverage: order.leverage)
                            }
                        }
                    }
                }
                
                
                
                completion?()
            }
        }
    }
    
    private func getTrades(startTime: TimeInterval, endTime: TimeInterval) -> [Trade]? {
        if tradeBuffer.isEmpty { return nil }
        var result = [Trade]()
        var indices = [Int]()
        for i in 0 ..< tradeBuffer.count {
            let tradeTime = Date.fromBitMEXString(str: tradeBuffer[i].timestamp)!.timeIntervalSince1970
            if tradeTime >= startTime && tradeTime < endTime {
                indices.append(i)
                result.append(tradeBuffer[i])
            } else if tradeTime < startTime {
                indices.append(i)
            } else {
                break
            }
        }
        tradeBuffer = tradeBuffer.enumerated().filter { !indices.contains($0.offset) }.map { $0.element }
        if Date.fromBitMEXString(str: tradeBuffer.last!.timestamp)!.timeIntervalSince1970 < currentTime.timeIntervalSince1970 + 1  {
            self.tradeBuffer.removeAll()
            return nil
        }
        return result
    }
    
    
    @objc func downloadNextTrades(completion: (()->Void)?) {
        DispatchQueue.main.async {
            self.app.chartVC?.playButton.isEnabled = false
            self.app.chartVC?.skipButton.isEnabled = false
        }
        
        Trade.GET(symbol: app.settings.chartSymbol, count: 500, reverse: false, start: nil, startTime: Date(timeIntervalSince1970: self.currentTime.timeIntervalSince1970 - self.step).bitMEXStringWithSeconds(), endTime: nil, filter: nil, columns: nil) { (optionalTrades, optionalResponse, optionalError) in
            DispatchQueue.main.async {
                self.app.chartVC?.playButton.isEnabled = true
                self.app.chartVC?.skipButton.isEnabled = true
            }

            guard optionalError == nil else { return }
            guard let resp = optionalResponse as? HTTPURLResponse else { return }
            guard resp.statusCode == 200 else { return }
            
            guard let trades = optionalTrades else {return}
            self.tradeBuffer.append(contentsOf: trades)
            completion?()
        }
    }
    
    //MARK: - Methods
    func pause() {
        _isPlaying = false
        DispatchQueue.main.async {
            self.app.chartVC?.skipButton.isEnabled = false
        }
    }
    func resume() {
        _isPlaying = true
        DispatchQueue.main.async {
            self.app.chartVC?.playButton.isEnabled = true
            self.app.chartVC?.skipButton.isEnabled = true
        }
    }
    
    func marketOrder(symbol: String, side: String, qty: Double, leverage: Double) -> GameOrder? {
        let id = "GameOrder_" + currentTime.bitMEXString()
        let price = app.getInstrument(app.settings.chartSymbol)!.lastPrice!
        
        if let p = position {
            if (p.side.lowercased() == "long" && side.lowercased() == "sell") ||
                (p.side.lowercased() == "short" && side.lowercased() == "buy") {
                if qty >= p.qty {
                    freeBalance = freeBalance + (p.qty / price) / (1 * p.leverage)
                    self.position = nil
                } else {
                    freeBalance = freeBalance + (qty / price) / (1 * p.leverage)
                    self.position!.qty -= qty
                }
                let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Market", side: side, status: "Executed")
                self.orders.append(order)
                return order
            } else {
                let cost = qty * price / leverage * 1
                if cost > freeBalance {
                    let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Market", side: side, status: "Failed")
                    self.orders.append(order)
                    return nil
                } else {
                    freeBalance = freeBalance - (qty / price) / (1 * p.leverage)
                    self.position!.qty += qty
                    
                    let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Market", side: side, status: "Executed")
                    self.orders.append(order)
                    return order
                }
            }
            
        } else { // position نداریم
            let cost = ((qty / price) / leverage) * 1
            if cost > freeBalance {
                let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Market", side: side, status: "Failed")
                self.orders.append(order)
                return nil
            }
            let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Market", side: side, status: "Executed")
            self.orders.append(order)
            
            
            var liq: Double = 0
            if side.lowercased() == "buy" {
                liq = price - price / (leverage * (1 - 0))
            } else {
                liq = price + price / (leverage * (1 - 0))
            }
            position = GamePosition(symbol: symbol, side: side.lowercased() == "buy" ? "Long" : "Short", qty: qty, entry: price, closePrice: nil, stopPrice: nil, liquidationPrice: liq, leverage: leverage)
            freeBalance = freeBalance - cost
            return order
        }
    }
    
    func limitOrder(symbol: String, side: String, qty: Double, price: Double, leverage: Double) -> GameOrder? {
        let id = "GameOrder_" + currentTime.bitMEXString()
        let p = app.getInstrument(app.settings.chartSymbol)!.lastPrice!

        
        let cost = ((qty / price) / leverage) * 1
        
        if let position = self.position {
            if position.side.lowercased() == "long" {
                if side.lowercased() == "sell" {
                    let q = (qty >= position.qty) ? position.qty : qty
                    let order = GameOrder(id: id, symbol: symbol, qty: q, price: price, leverage: leverage, type: "Limit", side: side, status: "Open")
                    self.orders.append(order)
                    return order
                } else {//buy
                    if cost > freeBalance || price >= p {
                        let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Limit", side: side, status: "Failed")
                        self.orders.append(order)
                        return nil
                    }
                    let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Limit", side: side, status: "Open")
                    self.orders.append(order)
                    freeBalance -= cost
                    return order
                }
            } else {
                if side.lowercased() == "buy" {
                    let q = (qty >= position.qty) ? position.qty : qty
                    let order = GameOrder(id: id, symbol: symbol, qty: q, price: price, leverage: leverage, type: "Limit", side: side, status: "Open")
                    self.orders.append(order)
                    return order
                } else {
                    if cost > freeBalance || price <= p {
                        let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Limit", side: side, status: "Failed")
                        self.orders.append(order)
                        return nil
                    }
                    let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Limit", side: side, status: "Open")
                    self.orders.append(order)
                    freeBalance -= cost
                    return order
                }
            }
        } else { // No position
            if cost > freeBalance || (side.lowercased() == "buy" && price >= p) || (side.lowercased() == "sell" && price <= p) {
                let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Limit", side: side, status: "Failed")
                self.orders.append(order)
                return nil
            }
            freeBalance = freeBalance - cost
            let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Limit", side: side, status: "Open")
            self.orders.append(order)
            return order
        }
        
    }
    
    
    
    func stopOrder(symbol: String, side: String, qty: Double, price: Double, leverage: Double) -> GameOrder? {
        let id = "GameOrder_" + currentTime.bitMEXString()
        let p = app.getInstrument(app.settings.chartSymbol)!.lastPrice!

        
        let cost = ((qty / price) / leverage) * 1
        
        if let position = self.position {
            if position.side.lowercased() == "long" {
                if side.lowercased() == "sell" {
                    let q = (qty >= position.qty) ? position.qty : qty
                    let order = GameOrder(id: id, symbol: symbol, qty: q, price: price, leverage: leverage, type: "Stop", side: side, status: "Open")
                    self.orders.append(order)
                    return order
                } else {//buy
                    if cost > freeBalance || price >= p {
                        let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Stop", side: side, status: "Failed")
                        self.orders.append(order)
                        return nil
                    }
                    let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Stop", side: side, status: "Open")
                    self.orders.append(order)
                    freeBalance -= cost
                    return order
                }
            } else {
                if side.lowercased() == "buy" {
                    let q = (qty >= position.qty) ? position.qty : qty
                    let order = GameOrder(id: id, symbol: symbol, qty: q, price: price, leverage: leverage, type: "Stop", side: side, status: "Open")
                    self.orders.append(order)
                    return order
                } else {
                    if cost > freeBalance || price <= p {
                        let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Stop", side: side, status: "Failed")
                        self.orders.append(order)
                        return nil
                    }
                    let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Stop", side: side, status: "Open")
                    self.orders.append(order)
                    freeBalance -= cost
                    return order
                }
            }
        } else { // No position
            if cost > freeBalance || (side.lowercased() == "buy" && price >= p) || (side.lowercased() == "sell" && price <= p) {
                let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Stop", side: side, status: "Failed")
                self.orders.append(order)
                return nil
            }
            freeBalance = freeBalance - cost
            let order = GameOrder(id: id, symbol: symbol, qty: qty, price: price, leverage: leverage, type: "Stop", side: side, status: "Open")
            self.orders.append(order)
            return order
        }
        
    }
    
    
    
    
    
    
    
    func getOpenOrder(symbol: String, price: Double) -> GameOrder? {
        for order in orders {
            if order.status.lowercased() == "open" {
                if order.symbol == symbol && order.price == price {
                    return order
                }
            }
        }
        return nil
    }
    
    
    
    //MARK: - NSCoding
    private struct Key {
        static let freeBalance = "game.freeBalance"
        static let deposited = "game.deposited"
        static let withdrawn = "game.withdrawn"
        static let creationTime = "game.creationTime"
        static let position = "game.position"
        static let orders = "game.orders"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(freeBalance, forKey: Key.freeBalance)
        aCoder.encode(deposited, forKey: Key.deposited)
        aCoder.encode(withdrawn, forKey: Key.withdrawn)
        aCoder.encode(creationTime, forKey: Key.creationTime)
        aCoder.encode(position, forKey: Key.position)
        aCoder.encode(orders, forKey: Key.orders)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let freeBalance = aDecoder.decodeObject(forKey: Key.freeBalance) as? Double else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let deposited = aDecoder.decodeObject(forKey: Key.deposited) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let withdrawn = aDecoder.decodeObject(forKey: Key.withdrawn) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let creationTime = aDecoder.decodeObject(forKey: Key.creationTime) as? Date else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let position = aDecoder.decodeObject(forKey: Key.position) as? GamePosition else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let orders = aDecoder.decodeObject(forKey: Key.orders) as? [GameOrder] else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(freeBalance: freeBalance, deposited: deposited, withdrawn: withdrawn, creationTime: creationTime, position: position, orders: orders)
    }
}




