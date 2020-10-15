//
//  Trade.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Trade {
    //MARK: Constants
    static let endpoint = "/trade"
    static let endpoint_bucketed = "/trade/bucketed"
    
    //MARK: Properties
    var timestamp: String
    var symbol: String
    var side: String?
    var size: Double?
    var price: Double?
    var tickDirection: String?
    var trdMatchID: String?
    var grossValue: Double?
    var homeNotional: Double?
    var foreignNotional: Double?
    
    //MARK: Initialization
    private init(timestamp: String, symbol: String, side: String?, size: Double?, price: Double?, tickDirection: String?, trdMatchID: String?, grossValue: Double?, homeNotional: Double?, foreignNotional: Double?) {
        self.timestamp = timestamp
        self.symbol = symbol
        self.side = side
        self.size = size
        self.price = price
        self.tickDirection = tickDirection
        self.trdMatchID = trdMatchID
        self.grossValue = grossValue
        self.homeNotional = homeNotional
        self.foreignNotional = foreignNotional
    }
    
    //MARK: Types
    struct Columns {
        static let timestamp = "timestamp"
        static let symbol = "symbol"
        static let side = "side"
        static let size = "size"
        static let price = "price"
        static let tickDirection = "tickDirection"
        static let trdMatchID = "trdMatchID"
        static let grossValue = "grossValue"
        static let homeNotional = "homeNotional"
        static let foreignNotional = "foreignNotional"
    }
    
    
    //MARK: Static Methods
    static func GET(symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Trade]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        if let symbol = symbol {
            queryItems.append(URLQueryItem(name: "symbol", value: symbol))
        }
        
        if let count = count {
            queryItems.append(URLQueryItem(name: "count", value: String(count)))
        }
        
        if let reverse = reverse {
            queryItems.append(URLQueryItem(name: "reverse", value: String(reverse)))
        }
        
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: String(start)))
        }
        
        
        if let startTime = startTime {
            queryItems.append(URLQueryItem(name: "startTime", value: startTime))
        }
        
        if let endTime = endTime {
            queryItems.append(URLQueryItem(name: "endTime", value: endTime))
        }
        
        if let filter = filter {
            do {
                let d = try JSONSerialization.data(withJSONObject: filter, options: .prettyPrinted)
                let s = String(data: d, encoding: .utf8)!
                queryItems.append(URLQueryItem(name: "filter", value: s))
            } catch let err {
                completion(nil, nil, err)
                return
            }
        }
        
        if let columns = columns {
            queryItems.append(URLQueryItem(name: "columns", value: columns.description))
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [Trade]()
                    for item in json {
                        let timestamp: String = item["timestamp"] as! String
                        let symbol: String = item["symbol"] as! String
                        let side: String? = item["side"] as? String
                        let size: Double? = item["size"] as? Double
                        let price: Double? = item["price"] as? Double
                        let tickDirection: String? = item["tickDirection"] as? String
                        let trdMatchID: String? = item["trdMatchID"] as? String
                        let grossValue: Double? = item["grossValue"] as? Double
                        let homeNotional: Double? = item["homeNotional"] as? Double
                        let foreignNotional: Double? = item["foreignNotional"] as? Double
                        let trade = Trade(timestamp: timestamp, symbol: symbol, side: side, size: size, price: price, tickDirection: tickDirection, trdMatchID: trdMatchID, grossValue: grossValue, homeNotional: homeNotional, foreignNotional: foreignNotional)
                        result.append(trade)
                    }
                    completion(result, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    
    static func processJSONString(_ json: [[String: Any]]) -> [Trade] {
        var result = [Trade]()
        for item in json {
            let timestamp: String = item["timestamp"] as! String
            let symbol: String = item["symbol"] as! String
            let side: String? = item["side"] as? String
            let size: Double? = item["size"] as? Double
            let price: Double? = item["price"] as? Double
            let tickDirection: String? = item["tickDirection"] as? String
            let trdMatchID: String? = item["trdMatchID"] as? String
            let grossValue: Double? = item["grossValue"] as? Double
            let homeNotional: Double? = item["homeNotional"] as? Double
            let foreignNotional: Double? = item["foreignNotional"] as? Double
            let trade = Trade(timestamp: timestamp, symbol: symbol, side: side, size: size, price: price, tickDirection: tickDirection, trdMatchID: trdMatchID, grossValue: grossValue, homeNotional: homeNotional, foreignNotional: foreignNotional)
            result.append(trade)
        }
        return result
    }
    
    
    
    
    static func GET_Bucketed(binSize: String, partial: Bool? = nil, symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Bucketed]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_bucketed
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "binSize", value: binSize))
        
        if let partial = partial {
            queryItems.append(URLQueryItem(name: "partial", value: String(partial)))
        }
        
        if let symbol = symbol {
            queryItems.append(URLQueryItem(name: "symbol", value: symbol))
        }
        
        if let count = count {
            queryItems.append(URLQueryItem(name: "count", value: count <= 750 ? String(count) : "750"))
        }
        
        if let reverse = reverse {
            queryItems.append(URLQueryItem(name: "reverse", value: String(reverse)))
        }
        
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: String(start)))
        }
        
        
        if let startTime = startTime {
            queryItems.append(URLQueryItem(name: "startTime", value: startTime))
        }
        
        if let endTime = endTime {
            queryItems.append(URLQueryItem(name: "endTime", value: endTime))
        }
        
        if let filter = filter {
            do {
                let d = try JSONSerialization.data(withJSONObject: filter, options: .prettyPrinted)
                let s = String(data: d, encoding: .utf8)!
                queryItems.append(URLQueryItem(name: "filter", value: s))
            } catch let err {
                completion(nil, nil, err)
                return
            }
        }
        
        if let columns = columns {
            queryItems.append(URLQueryItem(name: "columns", value: columns.description))
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [Bucketed]()
                    for item in json {
                        let timestamp: String = item["timestamp"] as! String
                        let symbol: String = item["symbol"] as! String
                        let open: Double? = item["open"] as? Double
                        let high: Double? = item["high"] as? Double
                        let low: Double? = item["low"] as? Double
                        let close: Double? = item["close"] as? Double
                        let trades: Double? = item["trades"] as? Double
                        let volume: Double? = item["volume"] as? Double
                        let vwap: Double? = item["vwap"] as? Double
                        let lastSize: Double? = item["lastSize"] as? Double
                        let turnover: Double? = item["turnover"] as? Double
                        let homeNotional: Double? = item["homeNotional"] as? Double
                        let foreignNotional: Double? = item["foreignNotional"] as? Double
                        let bucketed = Bucketed(timestamp: timestamp, symbol: symbol, open: open, high: high, low: low, close: close, trades: trades, volume: volume, vwap: vwap, lastSize: lastSize, turnover: turnover, homeNotional: homeNotional, foreignNotional: foreignNotional)
                        result.append(bucketed)
                    }
                    completion(result, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    
    
    class Bucketed {
        
        //MARK: Properties
        var timestamp: String
        var symbol: String
        var open: Double?
        var high: Double?
        var low: Double?
        var close: Double?
        var trades: Double?
        var volume: Double?
        var vwap: Double?
        var lastSize: Double?
        var turnover: Double?
        var homeNotional: Double?
        var foreignNotional: Double?
        
        
        
        //MARK: Initialization
        init(timestamp: String, symbol: String, open: Double?, high: Double?, low: Double?, close: Double?, trades: Double?, volume: Double?, vwap: Double?, lastSize: Double?, turnover: Double?, homeNotional: Double?, foreignNotional: Double?) {
            self.timestamp = timestamp
            self.symbol = symbol
            self.open = open
            self.high = high
            self.low = low
            self.close = close
            self.trades = trades
            self.volume = volume
            self.vwap = vwap
            self.lastSize = lastSize
            self.turnover = turnover
            self.homeNotional = homeNotional
            self.foreignNotional = foreignNotional
        }
    }
    
    
    static func subscribeRealTime(webSocket: WebSocket, symbol: String) {
        var args: String = "\"trade"
        args += ":\(symbol)"
        args += "\""
        let message: String = "{\"op\": \"subscribe\", \"args\": [" + args + "]}"
        
        webSocket.send(text: message)
    }
    
    static func unsubscribeRealTime(webSocket: WebSocket, symbol: String) {
        let args: String = "\"trades\":\(symbol)\""
        let message: String = "{\"op\": \"unsubscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
    }
}
