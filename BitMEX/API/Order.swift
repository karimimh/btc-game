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
    init(item: [String: Any]) {
        orderID = item["orderID"] as! String
        clOrdID = item["clOrdID"] as? String
        clOrdLinkID = item["clOrdLinkID"] as? String
        account = item["account"] as? Double
        symbol = item["symbol"] as? String
        side = item["side"] as? String
        simpleOrderQty = item["simpleOrderQty"] as? Double
        orderQty = item["orderQty"] as? Double
        price = item["price"] as? Double
        displayQty = item["displayQty"] as? Double
        stopPx = item["stopPx"] as? Double
        pegOffsetValue = item["pegOffsetValue"] as? Double
        pegPriceType = item["pegPriceType"] as? String
        currency = item["currency"] as? String
        settlCurrency = item["settlCurrency"] as? String
        ordType = item["ordType"] as? String
        timeInForce = item["timeInForce"] as? String
        execInst = item["execInst"] as? String
        contingencyType = item["contingencyType"] as? String
        exDestination = item["exDestination"] as? String
        ordStatus = item["ordStatus"] as? String
        triggered = item["triggered"] as? String
        workingIndicator = item["workingIndicator"] as? Bool
        ordRejReason = item["ordRejReason"] as? String
        simpleLeavesQty = item["simpleLeavesQty"] as? Double
        leavesQty = item["leavesQty"] as? Double
        simpleCumQty = item["simpleCumQty"] as? Double
        cumQty = item["cumQty"] as? Double
        avgPx = item["avgPx"] as? Double
        multiLegReportingType = item["multiLegReportingType"] as? String
        text = item["text"] as? String
        transactTime = item["transactTime"] as? String
        timestamp = item["timestamp"] as? String
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
                        let order = Order(item: item)
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
            let q = String(format: "%d", Int(orderQty))
            parameters["orderQty"] = Double(q)
        }
        
        if let price = price {
            let q = String(format: "%.1f", price)
            parameters["price"] = Double(q)
        }
        if let displayQty = displayQty {
            parameters["displayQty"] = displayQty
        }
        if let stopPx = stopPx {
            let q = String(format: "%.1f", stopPx)
            parameters["stopPx"] = Double(q)
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
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        
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
                    let order = Order(item: item)
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
            let q = String(format: "%d", Int(orderQty))
            parameters["orderQty"] = Double(q)
        }
        
        if let leavesQty = leavesQty {
            parameters["leavesQty"] = leavesQty
        }
        
        if let price = price {
            let q = String(format: "%.1f", price)
            parameters["price"] = Double(q)
        }
        if let stopPx = stopPx {
            let q = String(format: "%.1f", stopPx)
            parameters["stopPx"] = Double(q)
        }
        if let pegOffsetValue = pegOffsetValue {
            parameters["pegOffsetValue"] = pegOffsetValue
        }
        
        if let text = text {
            parameters["text"] = text
        }
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let order = Order(item: item[0])
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
            if !orderID.isEmpty {
                parameters["orderID"] = orderID
            }
        }
        if let clOrdID = clOrdID {
            if !clOrdID.isEmpty {
                parameters["clOrdID"] = clOrdID
            }
        }
        
        if let text = text {
            if !text.isEmpty {
                parameters["text"] = text
            }
        }
        
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "DELETE"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
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
                        let order = Order(item: item)
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
        
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
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
                        let order = Order(item: item)
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
    
    
    //MARK: - RealTime
    
    static func subscribeRealTime(webSocket: WebSocket, auth: Authentication) {
        let api_expires = String(Int(Date().timeIntervalSince1970.rounded()) + 5)
        let api_signature: String = "GET/realtime" + api_expires
        let sig = api_signature.hmac(algorithm: .SHA256, key: auth.apiSecret)
        webSocket.send(text: "{\"op\": \"authKeyExpires\", \"args\": [\"\(auth.apiKey)\", \(api_expires), \"\(sig)\"]}")
        
        
        let args: String = "\"order\""
        let message: String = "{\"op\": \"subscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
    }
    
    static func unsubscribeRealTime(webSocket: WebSocket, auth: Authentication) {
        let api_expires = String(Int(Date().timeIntervalSince1970.rounded()) + 5)
        let api_signature: String = "GET/realtime" + api_expires
        let sig = api_signature.hmac(algorithm: .SHA256, key: auth.apiSecret)
        webSocket.send(text: "{\"op\": \"authKeyExpires\", \"args\": [\"\(auth.apiKey)\", \(api_expires), \"\(sig)\"]}")
        
        
        let args: String = "\"order\""
        let message: String = "{\"op\": \"unsubscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
    }
    
}
