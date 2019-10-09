//
//  Order.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Order {
    //MARK: Constants
    static let endpoint = "/order"
    static let endpoint_all = "/order/all"
    //I will implement these later(if needed) :
    static let endpoint_bulk = "/order/bulk"
    static let endpoint_cancelAllAfter = "/order/cancelAllAfter"
    
    
    //MARK: Properties
    var orderID: String
    var clOrdID: String?
    var clOrdLinkID: String?
    var account: Double?
    var symbol: String?
    var side: String?
    var simpleOrderQty: Double?
    var orderQty: Double?
    var price: Double?
    var displayQty: Double?
    var stopPx: Double?
    var pegOffsetValue: Double?
    var pegPriceType: String?
    var currency: String?
    var settlCurrency: String?
    var ordType: String?
    var timeInForce: String?
    var execInst: String?
    var contingencyType: String?
    var exDestination: String?
    var ordStatus: String?
    var triggered: String?
    var workingIndicator: Bool?
    var ordRejReason: String?
    var simpleLeavesQty: Double?
    var leavesQty: Double?
    var simpleCumQty: Double?
    var cumQty: Double?
    var avgPx: Double?
    var multiLegReportingType: String?
    var text: String?
    var transactTime: String?
    var timestamp: String?
    
    
    //MARK: Initialization
    private init(orderID: String, clOrdID: String?, clOrdLinkID: String?, account: Double?, symbol: String?, side: String?, simpleOrderQty: Double?, orderQty: Double?, price: Double?, displayQty: Double?, stopPx: Double?, pegOffsetValue: Double?, pegPriceType: String?, currency: String?, settlCurrency: String?, ordType: String?, timeInForce: String?, execInst: String?, contingencyType: String?, exDestination: String?, ordStatus: String?, triggered: String?, workingIndicator: Bool?, ordRejReason: String?, simpleLeavesQty: Double?, leavesQty: Double?, simpleCumQty: Double?, cumQty: Double?, avgPx: Double?, multiLegReportingType: String?, text: String?, transactTime: String?, timestamp: String?) {
        self.orderID = orderID
        self.clOrdID = clOrdID
        self.clOrdLinkID = clOrdLinkID
        self.account = account
        self.symbol = symbol
        self.side = side
        self.simpleOrderQty = simpleOrderQty
        self.orderQty = orderQty
        self.price = price
        self.displayQty = displayQty
        self.stopPx = stopPx
        self.pegOffsetValue = pegOffsetValue
        self.pegPriceType = pegPriceType
        self.currency = currency
        self.settlCurrency = settlCurrency
        self.ordType = ordType
        self.timeInForce = timeInForce
        self.execInst = execInst
        self.contingencyType = contingencyType
        self.exDestination = exDestination
        self.ordStatus = ordStatus
        self.triggered = triggered
        self.workingIndicator = workingIndicator
        self.ordRejReason = ordRejReason
        self.simpleLeavesQty = simpleLeavesQty
        self.leavesQty = leavesQty
        self.simpleCumQty = simpleCumQty
        self.cumQty = cumQty
        self.avgPx = avgPx
        self.multiLegReportingType = multiLegReportingType
        self.text = text
        self.transactTime = transactTime
        self.timestamp = timestamp
    }
    
    //MARK: Types
    struct Columns {
        static let orderID = "orderID"
        static let clOrdID = "clOrdID"
        static let clOrdLinkID = "clOrdLinkID"
        static let account = "account"
        static let symbol = "symbol"
        static let side = "side"
        static let simpleOrderQty = "simpleOrderQty"
        static let orderQty = "orderQty"
        static let price = "price"
        static let displayQty = "displayQty"
        static let stopPx = "stopPx"
        static let pegOffsetValue = "pegOffsetValue"
        static let pegPriceType = "pegPriceType"
        static let currency = "currency"
        static let settlCurrency = "settlCurrency"
        static let ordType = "ordType"
        static let timeInForce = "timeInForce"
        static let execInst = "execInst"
        static let contingencyType = "contingencyType"
        static let exDestination = "exDestination"
        static let ordStatus = "ordStatus"
        static let triggered = "triggered"
        static let workingIndicator = "workingIndicator"
        static let ordRejReason = "ordRejReason"
        static let simpleLeavesQty = "simpleLeavesQty"
        static let leavesQty = "leavesQty"
        static let simpleCumQty = "simpleCumQty"
        static let cumQty = "cumQty"
        static let avgPx = "avgPx"
        static let multiLegReportingType = "multiLegReportingType"
        static let text = "text"
        static let transactTime = "transactTime"
        static let timestamp = "timestamp"
    }
    
    struct OrderType {
        static let Limit = "Limit"
        static let Market = "Market"
        static let Stop = "Stop"
        static let StopLimit = "StopLimit"
        static let MarketIfTouched = "MarketIfTouched"
        static let LimitIfTouched = "LimitIfTouched"
    }
    
    struct ExecutionInstruction {
        static let ParticipateDoNotInitiate = "ParticipateDoNotInitiate"
        static let MarkPrice = "MarkPrice"
        static let LastPrice = "LastPrice"
        static let IndexPrice = "IndexPrice"
        static let ReduceOnly = "ReduceOnly"
        static let Close = "Close"
    }

    
    //MARK: Static Methods
    
    /// To get open orders only, send {"open": true} in the filter param.
    static func GET(authentication: Authentication, symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Order]?, URLResponse?, Error?) -> Void) {
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
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
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
                    var result = [Order]()
                    for item in json {
                        let orderID: String = item["orderID"] as! String
                        let clOrdID: String? = item["clOrdID"] as? String
                        let clOrdLinkID: String? = item["clOrdLinkID"] as? String
                        let account: Double? = item["account"] as? Double
                        let symbol: String? = item["symbol"] as? String
                        let side: String? = item["side"] as? String
                        let simpleOrderQty: Double? = item["simpleOrderQty"] as? Double
                        let orderQty: Double? = item["orderQty"] as? Double
                        let price: Double? = item["price"] as? Double
                        let displayQty: Double? = item["displayQty"] as? Double
                        let stopPx: Double? = item["stopPx"] as? Double
                        let pegOffsetValue: Double? = item["pegOffsetValue"] as? Double
                        let pegPriceType: String? = item["pegPriceType"] as? String
                        let currency: String? = item["currency"] as? String
                        let settlCurrency: String? = item["settlCurrency"] as? String
                        let ordType: String? = item["ordType"] as? String
                        let timeInForce: String? = item["timeInForce"] as? String
                        let execInst: String? = item["execInst"] as? String
                        let contingencyType: String? = item["contingencyType"] as? String
                        let exDestination: String? = item["exDestination"] as? String
                        let ordStatus: String? = item["ordStatus"] as? String
                        let triggered: String? = item["triggered"] as? String
                        let workingIndicator: Bool? = item["workingIndicator"] as? Bool
                        let ordRejReason: String? = item["ordRejReason"] as? String
                        let simpleLeavesQty: Double? = item["simpleLeavesQty"] as? Double
                        let leavesQty: Double? = item["leavesQty"] as? Double
                        let simpleCumQty: Double? = item["simpleCumQty"] as? Double
                        let cumQty: Double? = item["cumQty"] as? Double
                        let avgPx: Double? = item["avgPx"] as? Double
                        let multiLegReportingType: String? = item["multiLegReportingType"] as? String
                        let text: String? = item["text"] as? String
                        let transactTime: String? = item["transactTime"] as? String
                        let timestamp: String? = item["timestamp"] as? String
                        let order = Order(orderID: orderID, clOrdID: clOrdID, clOrdLinkID: clOrdLinkID, account: account, symbol: symbol, side: side, simpleOrderQty: simpleOrderQty, orderQty: orderQty, price: price, displayQty: displayQty, stopPx: stopPx, pegOffsetValue: pegOffsetValue, pegPriceType: pegPriceType, currency: currency, settlCurrency: settlCurrency, ordType: ordType, timeInForce: timeInForce, execInst: execInst, contingencyType: contingencyType, exDestination: exDestination, ordStatus: ordStatus, triggered: triggered, workingIndicator: workingIndicator, ordRejReason: ordRejReason, simpleLeavesQty: simpleLeavesQty, leavesQty: leavesQty, simpleCumQty: simpleCumQty, cumQty: cumQty, avgPx: avgPx, multiLegReportingType: multiLegReportingType, text: text, transactTime: transactTime, timestamp: timestamp)
                        result.append(order)
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
    
    
    /// Create Order
    static func POST(authentication: Authentication, symbol: String, side: String? = nil, orderQty: Double? = nil, price: Double? = nil, displayQty: Double? = nil , stopPx: Double? = nil, clOrdID: String? = nil, pegOffsetValue: Double? = nil, pegPriceType: String? = nil, ordType: String? = nil, timeInForce: String? = nil, execInst: String? = nil, text: String? = nil, completion: @escaping (Order?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var parameters: [String: Any] = [:]
        
        parameters["symbol"] = symbol
        
        if let side = side {
            parameters["side"] = side
        }
        
        if let orderQty = orderQty {
            parameters["orderQty"] = orderQty
        }
        
        if let price = price {
            parameters["price"] = price
        }
        if let displayQty = displayQty {
            parameters["displayQty"] = displayQty
        }
        if let stopPx = stopPx {
            parameters["stopPx"] = stopPx
        }
        if let clOrdID = clOrdID {
            parameters["clOrdID"] = clOrdID
        }
        if let pegOffsetValue = pegOffsetValue {
            parameters["pegOffsetValue"] = pegOffsetValue
        }
        if let pegPriceType = pegPriceType {
            parameters["pegPriceType"] = pegPriceType
        }
        if let ordType = ordType {
            parameters["ordType"] = ordType
        }
        if let timeInForce = timeInForce {
            parameters["timeInForce"] = timeInForce
        }
        if let execInst = execInst {
            parameters["execInst"] = execInst
        }
        
        if let text = text {
            parameters["text"] = text
        }
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                    return
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let orderID: String = item["orderID"] as! String
                    let clOrdID: String? = item["clOrdID"] as? String
                    let clOrdLinkID: String? = item["clOrdLinkID"] as? String
                    let account: Double? = item["account"] as? Double
                    let symbol: String? = item["symbol"] as? String
                    let side: String? = item["side"] as? String
                    let simpleOrderQty: Double? = item["simpleOrderQty"] as? Double
                    let orderQty: Double? = item["orderQty"] as? Double
                    let price: Double? = item["price"] as? Double
                    let displayQty: Double? = item["displayQty"] as? Double
                    let stopPx: Double? = item["stopPx"] as? Double
                    let pegOffsetValue: Double? = item["pegOffsetValue"] as? Double
                    let pegPriceType: String? = item["pegPriceType"] as? String
                    let currency: String? = item["currency"] as? String
                    let settlCurrency: String? = item["settlCurrency"] as? String
                    let ordType: String? = item["ordType"] as? String
                    let timeInForce: String? = item["timeInForce"] as? String
                    let execInst: String? = item["execInst"] as? String
                    let contingencyType: String? = item["contingencyType"] as? String
                    let exDestination: String? = item["exDestination"] as? String
                    let ordStatus: String? = item["ordStatus"] as? String
                    let triggered: String? = item["triggered"] as? String
                    let workingIndicator: Bool? = item["workingIndicator"] as? Bool
                    let ordRejReason: String? = item["ordRejReason"] as? String
                    let simpleLeavesQty: Double? = item["simpleLeavesQty"] as? Double
                    let leavesQty: Double? = item["leavesQty"] as? Double
                    let simpleCumQty: Double? = item["simpleCumQty"] as? Double
                    let cumQty: Double? = item["cumQty"] as? Double
                    let avgPx: Double? = item["avgPx"] as? Double
                    let multiLegReportingType: String? = item["multiLegReportingType"] as? String
                    let text: String? = item["text"] as? String
                    let transactTime: String? = item["transactTime"] as? String
                    let timestamp: String? = item["timestamp"] as? String
                    let order = Order(orderID: orderID, clOrdID: clOrdID, clOrdLinkID: clOrdLinkID, account: account, symbol: symbol, side: side, simpleOrderQty: simpleOrderQty, orderQty: orderQty, price: price, displayQty: displayQty, stopPx: stopPx, pegOffsetValue: pegOffsetValue, pegPriceType: pegPriceType, currency: currency, settlCurrency: settlCurrency, ordType: ordType, timeInForce: timeInForce, execInst: execInst, contingencyType: contingencyType, exDestination: exDestination, ordStatus: ordStatus, triggered: triggered, workingIndicator: workingIndicator, ordRejReason: ordRejReason, simpleLeavesQty: simpleLeavesQty, leavesQty: leavesQty, simpleCumQty: simpleCumQty, cumQty: cumQty, avgPx: avgPx, multiLegReportingType: multiLegReportingType, text: text, transactTime: transactTime, timestamp: timestamp)
                    completion(order, response, nil)
                    return
                } else {
                    completion(nil, response, nil)
                    return
                }
            } catch {
                completion(nil, response, nil)
                return
            }
        }
        task.resume()
    }
    
    /// Amend Order
    static func PUT(authentication: Authentication, orderID: String? = nil, origClOrdID: String? = nil, clOrdID: String? = nil, orderQty: Double? = nil, leavesQty: Double? = nil, price: Double? = nil, stopPx: Double? = nil,  pegOffsetValue: Double? = nil, text: String? = nil, completion: @escaping (Order?, URLResponse?, Error?) -> Void) {
        
        if orderID == nil && origClOrdID == nil {
            completion(nil, nil, nil)
            print("orderID or origClOrdID is required!")
            return
        }
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var parameters: [String: Any] = [:]
        
        
        
        if let orderID = orderID {
            parameters["orderID"] = orderID
        }
        if let origClOrdID = origClOrdID {
            parameters["origClOrdID"] = origClOrdID
        }
        if let clOrdID = clOrdID {
            parameters["clOrdID"] = clOrdID
        }
        
        if let orderQty = orderQty {
            parameters["orderQty"] = orderQty
        }
        if let leavesQty = leavesQty {
            parameters["leavesQty"] = leavesQty
        }
        
        if let price = price {
            parameters["price"] = price
        }
        if let stopPx = stopPx {
            parameters["stopPx"] = stopPx
        }
        if let pegOffsetValue = pegOffsetValue {
            parameters["pegOffsetValue"] = pegOffsetValue
        }
        
        if let text = text {
            parameters["text"] = text
        }
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "PUT"
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let orderID: String = item["orderID"] as! String
                    let clOrdID: String? = item["clOrdID"] as? String
                    let clOrdLinkID: String? = item["clOrdLinkID"] as? String
                    let account: Double? = item["account"] as? Double
                    let symbol: String? = item["symbol"] as? String
                    let side: String? = item["side"] as? String
                    let simpleOrderQty: Double? = item["simpleOrderQty"] as? Double
                    let orderQty: Double? = item["orderQty"] as? Double
                    let price: Double? = item["price"] as? Double
                    let displayQty: Double? = item["displayQty"] as? Double
                    let stopPx: Double? = item["stopPx"] as? Double
                    let pegOffsetValue: Double? = item["pegOffsetValue"] as? Double
                    let pegPriceType: String? = item["pegPriceType"] as? String
                    let currency: String? = item["currency"] as? String
                    let settlCurrency: String? = item["settlCurrency"] as? String
                    let ordType: String? = item["ordType"] as? String
                    let timeInForce: String? = item["timeInForce"] as? String
                    let execInst: String? = item["execInst"] as? String
                    let contingencyType: String? = item["contingencyType"] as? String
                    let exDestination: String? = item["exDestination"] as? String
                    let ordStatus: String? = item["ordStatus"] as? String
                    let triggered: String? = item["triggered"] as? String
                    let workingIndicator: Bool? = item["workingIndicator"] as? Bool
                    let ordRejReason: String? = item["ordRejReason"] as? String
                    let simpleLeavesQty: Double? = item["simpleLeavesQty"] as? Double
                    let leavesQty: Double? = item["leavesQty"] as? Double
                    let simpleCumQty: Double? = item["simpleCumQty"] as? Double
                    let cumQty: Double? = item["cumQty"] as? Double
                    let avgPx: Double? = item["avgPx"] as? Double
                    let multiLegReportingType: String? = item["multiLegReportingType"] as? String
                    let text: String? = item["text"] as? String
                    let transactTime: String? = item["transactTime"] as? String
                    let timestamp: String? = item["timestamp"] as? String
                    let order = Order(orderID: orderID, clOrdID: clOrdID, clOrdLinkID: clOrdLinkID, account: account, symbol: symbol, side: side, simpleOrderQty: simpleOrderQty, orderQty: orderQty, price: price, displayQty: displayQty, stopPx: stopPx, pegOffsetValue: pegOffsetValue, pegPriceType: pegPriceType, currency: currency, settlCurrency: settlCurrency, ordType: ordType, timeInForce: timeInForce, execInst: execInst, contingencyType: contingencyType, exDestination: exDestination, ordStatus: ordStatus, triggered: triggered, workingIndicator: workingIndicator, ordRejReason: ordRejReason, simpleLeavesQty: simpleLeavesQty, leavesQty: leavesQty, simpleCumQty: simpleCumQty, cumQty: cumQty, avgPx: avgPx, multiLegReportingType: multiLegReportingType, text: text, transactTime: transactTime, timestamp: timestamp)
                    completion(order, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    
    /// Cancel Order, use comma in orderID to cancel miltiple orders
    static func DELETE(authentication: Authentication, orderID: String? = nil, clOrdID: String? = nil, text: String? = nil, completion: @escaping ([Order]?, URLResponse?, Error?) -> Void) {
        
        let condition = (orderID == nil) && (clOrdID == nil)
        assert(!condition, "orderID or clOrdID is required!")
        
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var parameters: [String: Any] = [:]
        
        if let orderID = orderID {
            parameters["orderID"] = orderID
        }
        
        if let clOrdID = clOrdID {
            parameters["clOrdID"] = clOrdID
        }
        
        if let text = text {
            parameters["text"] = text
        }
        
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "DELETE"
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        
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
                    var result = [Order]()
                    for item in json {
                        let orderID: String = item["orderID"] as! String
                        let clOrdID: String? = item["clOrdID"] as? String
                        let clOrdLinkID: String? = item["clOrdLinkID"] as? String
                        let account: Double? = item["account"] as? Double
                        let symbol: String? = item["symbol"] as? String
                        let side: String? = item["side"] as? String
                        let simpleOrderQty: Double? = item["simpleOrderQty"] as? Double
                        let orderQty: Double? = item["orderQty"] as? Double
                        let price: Double? = item["price"] as? Double
                        let displayQty: Double? = item["displayQty"] as? Double
                        let stopPx: Double? = item["stopPx"] as? Double
                        let pegOffsetValue: Double? = item["pegOffsetValue"] as? Double
                        let pegPriceType: String? = item["pegPriceType"] as? String
                        let currency: String? = item["currency"] as? String
                        let settlCurrency: String? = item["settlCurrency"] as? String
                        let ordType: String? = item["ordType"] as? String
                        let timeInForce: String? = item["timeInForce"] as? String
                        let execInst: String? = item["execInst"] as? String
                        let contingencyType: String? = item["contingencyType"] as? String
                        let exDestination: String? = item["exDestination"] as? String
                        let ordStatus: String? = item["ordStatus"] as? String
                        let triggered: String? = item["triggered"] as? String
                        let workingIndicator: Bool? = item["workingIndicator"] as? Bool
                        let ordRejReason: String? = item["ordRejReason"] as? String
                        let simpleLeavesQty: Double? = item["simpleLeavesQty"] as? Double
                        let leavesQty: Double? = item["leavesQty"] as? Double
                        let simpleCumQty: Double? = item["simpleCumQty"] as? Double
                        let cumQty: Double? = item["cumQty"] as? Double
                        let avgPx: Double? = item["avgPx"] as? Double
                        let multiLegReportingType: String? = item["multiLegReportingType"] as? String
                        let text: String? = item["text"] as? String
                        let transactTime: String? = item["transactTime"] as? String
                        let timestamp: String? = item["timestamp"] as? String
                        let order = Order(orderID: orderID, clOrdID: clOrdID, clOrdLinkID: clOrdLinkID, account: account, symbol: symbol, side: side, simpleOrderQty: simpleOrderQty, orderQty: orderQty, price: price, displayQty: displayQty, stopPx: stopPx, pegOffsetValue: pegOffsetValue, pegPriceType: pegPriceType, currency: currency, settlCurrency: settlCurrency, ordType: ordType, timeInForce: timeInForce, execInst: execInst, contingencyType: contingencyType, exDestination: exDestination, ordStatus: ordStatus, triggered: triggered, workingIndicator: workingIndicator, ordRejReason: ordRejReason, simpleLeavesQty: simpleLeavesQty, leavesQty: leavesQty, simpleCumQty: simpleCumQty, cumQty: cumQty, avgPx: avgPx, multiLegReportingType: multiLegReportingType, text: text, transactTime: transactTime, timestamp: timestamp)
                        result.append(order)
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
    
    /// Cancel All Orders
    static func DELETEALL(authentication: Authentication, symbol: String? = nil, filter: [String: Any]? = nil, text: String? = nil, completion: @escaping ([Order]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_all
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var parameters: [String: Any] = [:]
        
        if let symbol = symbol {
            parameters["symbol"] = symbol
        }
        
        if let filter = filter {
            do {
                let d = try JSONSerialization.data(withJSONObject: filter, options: .prettyPrinted)
                let s = String(data: d, encoding: .utf8)!
                parameters["filter"] = s
            } catch let err {
                completion(nil, nil, err)
                return
            }
        }
        if let text = text {
            parameters["text"] = text
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "DELETE"
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        
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
                    var result = [Order]()
                    for item in json {
                        let orderID: String = item["orderID"] as! String
                        let clOrdID: String? = item["clOrdID"] as? String
                        let clOrdLinkID: String? = item["clOrdLinkID"] as? String
                        let account: Double? = item["account"] as? Double
                        let symbol: String? = item["symbol"] as? String
                        let side: String? = item["side"] as? String
                        let simpleOrderQty: Double? = item["simpleOrderQty"] as? Double
                        let orderQty: Double? = item["orderQty"] as? Double
                        let price: Double? = item["price"] as? Double
                        let displayQty: Double? = item["displayQty"] as? Double
                        let stopPx: Double? = item["stopPx"] as? Double
                        let pegOffsetValue: Double? = item["pegOffsetValue"] as? Double
                        let pegPriceType: String? = item["pegPriceType"] as? String
                        let currency: String? = item["currency"] as? String
                        let settlCurrency: String? = item["settlCurrency"] as? String
                        let ordType: String? = item["ordType"] as? String
                        let timeInForce: String? = item["timeInForce"] as? String
                        let execInst: String? = item["execInst"] as? String
                        let contingencyType: String? = item["contingencyType"] as? String
                        let exDestination: String? = item["exDestination"] as? String
                        let ordStatus: String? = item["ordStatus"] as? String
                        let triggered: String? = item["triggered"] as? String
                        let workingIndicator: Bool? = item["workingIndicator"] as? Bool
                        let ordRejReason: String? = item["ordRejReason"] as? String
                        let simpleLeavesQty: Double? = item["simpleLeavesQty"] as? Double
                        let leavesQty: Double? = item["leavesQty"] as? Double
                        let simpleCumQty: Double? = item["simpleCumQty"] as? Double
                        let cumQty: Double? = item["cumQty"] as? Double
                        let avgPx: Double? = item["avgPx"] as? Double
                        let multiLegReportingType: String? = item["multiLegReportingType"] as? String
                        let text: String? = item["text"] as? String
                        let transactTime: String? = item["transactTime"] as? String
                        let timestamp: String? = item["timestamp"] as? String
                        let order = Order(orderID: orderID, clOrdID: clOrdID, clOrdLinkID: clOrdLinkID, account: account, symbol: symbol, side: side, simpleOrderQty: simpleOrderQty, orderQty: orderQty, price: price, displayQty: displayQty, stopPx: stopPx, pegOffsetValue: pegOffsetValue, pegPriceType: pegPriceType, currency: currency, settlCurrency: settlCurrency, ordType: ordType, timeInForce: timeInForce, execInst: execInst, contingencyType: contingencyType, exDestination: exDestination, ordStatus: ordStatus, triggered: triggered, workingIndicator: workingIndicator, ordRejReason: ordRejReason, simpleLeavesQty: simpleLeavesQty, leavesQty: leavesQty, simpleCumQty: simpleCumQty, cumQty: cumQty, avgPx: avgPx, multiLegReportingType: multiLegReportingType, text: text, transactTime: transactTime, timestamp: timestamp)
                        result.append(order)
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
}
