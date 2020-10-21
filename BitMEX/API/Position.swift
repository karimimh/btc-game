//
//  Position.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Position {
    
    //MARK: Constants
    static let endpoint = "/position"
    static let endpoint_isolate = "/position/isolate"
    static let endpoint_leverage = "/position/leverage"
    static let endpoint_riskLimit = "/position/riskLimit"
    static let endpoint_transferMargin = "/position/transferMargin"
    
    
    //MARK: Properties
    var account: Int
    var symbol: String
    var currency: String
    var underlying: String?
    var quoteCurrency: String?
    var commission: Double?
    var initMarginReq: Double?
    var maintMarginReq: Double?
    var riskLimit: Double?
    var leverage: Double?
    var crossMargin: Bool?
    var deleveragePercentile: Double?
    var rebalancedPnl: Double?
    var prevRealisedPnl: Double?
    var prevUnrealisedPnl: Double?
    var prevClosePrice: Double?
    var openingTimestamp: String?
    var openingQty: Double?
    var openingCost: Double?
    var openingComm: Double?
    var openOrderBuyQty: Double?
    var openOrderBuyCost: Double?
    var openOrderBuyPremium: Double?
    var openOrderSellQty: Double?
    var openOrderSellCost: Double?
    var openOrderSellPremium: Double?
    var execBuyQty: Double?
    var execBuyCost: Double?
    var execSellQty: Double?
    var execSellCost: Double?
    var execQty: Double?
    var execCost: Double?
    var execComm: Double?
    var currentTimestamp: String?
    var currentQty: Double?
    var currentCost: Double?
    var currentComm: Double?
    var realisedCost: Double?
    var unrealisedCost: Double?
    var grossOpenCost: Double?
    var grossOpenPremium: Double?
    var grossExecCost: Double?
    var isOpen: Bool?
    var markPrice: Double?
    var markValue: Double?
    var riskValue: Double?
    var homeNotional: Double?
    var foreignNotional: Double?
    var posState: String?
    var posCost: Double?
    var posCost2: Double?
    var posCross: Double?
    var posInit: Double?
    var posComm: Double?
    var posLoss: Double?
    var posMargin: Double?
    var posMaint: Double?
    var posAllowance: Double?
    var taxableMargin: Double?
    var initMargin: Double?
    var maintMargin: Double?
    var sessionMargin: Double?
    var targetExcessMargin: Double?
    var varMargin: Double?
    var realisedGrossPnl: Double?
    var realisedTax: Double?
    var realisedPnl: Double?
    var unrealisedGrossPnl: Double?
    var longBankrupt: Double?
    var shortBankrupt: Double?
    var taxBase: Double?
    var indicativeTaxRate: Double?
    var indicativeTax: Double?
    var unrealisedTax: Double?
    var unrealisedPnl: Int?
    var unrealisedPnlPcnt: Double?
    var unrealisedRoePcnt: Double?
    var simpleQty: Double?
    var simpleCost: Double?
    var simpleValue: Double?
    var simplePnl: Double?
    var simplePnlPcnt: Double?
    var avgCostPrice: Double?
    var avgEntryPrice: Double?
    var breakEvenPrice: Double?
    var marginCallPrice: Double?
    var liquidationPrice: Double?
    var bankruptPrice: Double?
    var timestamp: String?
    var lastPrice: Double?
    var lastValue: Double?
    
    //MARK: Initialization
    
    init(json: [String: Any]) {
        account = json["account"] as! Int
        symbol = json["symbol"] as! String
        currency = json["currency"] as! String
        underlying = json["underlying"] as? String
        quoteCurrency = json["quoteCurrency"] as? String
        commission = json["commission"] as? Double
        initMarginReq = json["initMarginReq"] as? Double
        maintMarginReq = json["maintMarginReq"] as? Double
        riskLimit = json["riskLimit"] as? Double
        leverage = json["leverage"] as? Double
        crossMargin = json["crossMargin"] as? Bool
        deleveragePercentile = json["deleveragePercentile"] as? Double
        rebalancedPnl = json["rebalancedPnl"] as? Double
        prevRealisedPnl = json["prevRealisedPnl"] as? Double
        prevUnrealisedPnl = json["prevUnrealisedPnl"] as? Double
        prevClosePrice = json["prevClosePrice"] as? Double
        openingTimestamp = json["openingTimestamp"] as? String
        openingQty = json["openingQty"] as? Double
        openingCost = json["openingCost"] as? Double
        openingComm = json["openingComm"] as? Double
        openOrderBuyQty = json["openOrderBuyQty"] as? Double
        openOrderBuyCost = json["openOrderBuyCost"] as? Double
        openOrderBuyPremium = json["openOrderBuyPremium"] as? Double
        openOrderSellQty = json["openOrderSellQty"] as? Double
        openOrderSellCost = json["openOrderSellCost"] as? Double
        openOrderSellPremium = json["openOrderSellPremium"] as? Double
        execBuyQty = json["execBuyQty"] as? Double
        execBuyCost = json["execBuyCost"] as? Double
        execSellQty = json["execSellQty"] as? Double
        execSellCost = json["execSellCost"] as? Double
        execQty = json["execQty"] as? Double
        execCost = json["execCost"] as? Double
        execComm = json["execComm"] as? Double
        currentTimestamp = json["currentTimestamp"] as? String
        currentQty = json["currentQty"] as? Double
        currentCost = json["currentCost"] as? Double
        currentComm = json["currentComm"] as? Double
        realisedCost = json["realisedCost"] as? Double
        unrealisedCost = json["unrealisedCost"] as? Double
        grossOpenCost = json["grossOpenCost"] as? Double
        grossOpenPremium = json["grossOpenPremium"] as? Double
        grossExecCost = json["grossExecCost"] as? Double
        isOpen = json["isOpen"] as? Bool
        markPrice = json["markPrice"] as? Double
        markValue = json["markValue"] as? Double
        riskValue = json["riskValue"] as? Double
        homeNotional = json["homeNotional"] as? Double
        foreignNotional = json["foreignNotional"] as? Double
        posState = json["posState"] as? String
        posCost = json["posCost"] as? Double
        posCost2 = json["posCost2"] as? Double
        posCross = json["posCross"] as? Double
        posInit = json["posInit"] as? Double
        posComm = json["posComm"] as? Double
        posLoss = json["posLoss"] as? Double
        posMargin = json["posMargin"] as? Double
        posMaint = json["posMaint"] as? Double
        posAllowance = json["posAllowance"] as? Double
        taxableMargin = json["taxableMargin"] as? Double
        initMargin = json["initMargin"] as? Double
        maintMargin = json["maintMargin"] as? Double
        sessionMargin = json["sessionMargin"] as? Double
        targetExcessMargin = json["targetExcessMargin"] as? Double
        varMargin = json["varMargin"] as? Double
        realisedGrossPnl = json["realisedGrossPnl"] as? Double
        realisedTax = json["realisedTax"] as? Double
        realisedPnl = json["realisedPnl"] as? Double
        unrealisedGrossPnl = json["unrealisedGrossPnl"] as? Double
        longBankrupt = json["longBankrupt"] as? Double
        shortBankrupt = json["shortBankrupt"] as? Double
        taxBase = json["taxBase"] as? Double
        indicativeTaxRate = json["indicativeTaxRate"] as? Double
        indicativeTax = json["indicativeTax"] as? Double
        unrealisedTax = json["unrealisedTax"] as? Double
        unrealisedPnl = json["unrealisedPnl"] as? Int
        unrealisedPnlPcnt = json["unrealisedPnlPcnt"] as? Double
        unrealisedRoePcnt = json["unrealisedRoePcnt"] as? Double
        simpleQty = json["simpleQty"] as? Double
        simpleCost = json["simpleCost"] as? Double
        simpleValue = json["simpleValue"] as? Double
        simplePnl = json["simplePnl"] as? Double
        simplePnlPcnt = json["simplePnlPcnt"] as? Double
        avgCostPrice = json["avgCostPrice"] as? Double
        avgEntryPrice = json["avgEntryPrice"] as? Double
        breakEvenPrice = json["breakEvenPrice"] as? Double
        marginCallPrice = json["marginCallPrice"] as? Double
        liquidationPrice = json["liquidationPrice"] as? Double
        bankruptPrice = json["bankruptPrice"] as? Double
        timestamp = json["timestamp"] as? String
        lastPrice = json["lastPrice"] as? Double
        lastValue = json["lastValue"] as? Double
    }
    
    //MARK: Types
    struct Columns {
        static let account = "account"
        static let symbol = "symbol"
        static let currency = "currency"
        static let underlying = "underlying"
        static let quoteCurrency = "quoteCurrency"
        static let commission = "commission"
        static let initMarginReq = "initMarginReq"
        static let maintMarginReq = "maintMarginReq"
        static let riskLimit = "riskLimit"
        static let leverage = "leverage"
        static let crossMargin = "crossMargin"
        static let deleveragePercentile = "deleveragePercentile"
        static let rebalancedPnl = "rebalancedPnl"
        static let prevRealisedPnl = "prevRealisedPnl"
        static let prevUnrealisedPnl = "prevUnrealisedPnl"
        static let prevClosePrice = "prevClosePrice"
        static let openingTimestamp = "openingTimestamp"
        static let openingQty = "openingQty"
        static let openingCost = "openingCost"
        static let openingComm = "openingComm"
        static let openOrderBuyQty = "openOrderBuyQty"
        static let openOrderBuyCost = "openOrderBuyCost"
        static let openOrderBuyPremium = "openOrderBuyPremium"
        static let openOrderSellQty = "openOrderSellQty"
        static let openOrderSellCost = "openOrderSellCost"
        static let openOrderSellPremium = "openOrderSellPremium"
        static let execBuyQty = "execBuyQty"
        static let execBuyCost = "execBuyCost"
        static let execSellQty = "execSellQty"
        static let execSellCost = "execSellCost"
        static let execQty = "execQty"
        static let execCost = "execCost"
        static let execComm = "execComm"
        static let currentTimestamp = "currentTimestamp"
        static let currentQty = "currentQty"
        static let currentCost = "currentCost"
        static let currentComm = "currentComm"
        static let realisedCost = "realisedCost"
        static let unrealisedCost = "unrealisedCost"
        static let grossOpenCost = "grossOpenCost"
        static let grossOpenPremium = "grossOpenPremium"
        static let grossExecCost = "grossExecCost"
        static let isOpen = "isOpen"
        static let markPrice = "markPrice"
        static let markValue = "markValue"
        static let riskValue = "riskValue"
        static let homeNotional = "homeNotional"
        static let foreignNotional = "foreignNotional"
        static let posState = "posState"
        static let posCost = "posCost"
        static let posCost2 = "posCost2"
        static let posCross = "posCross"
        static let posInit = "posInit"
        static let posComm = "posComm"
        static let posLoss = "posLoss"
        static let posMargin = "posMargin"
        static let posMaint = "posMaint"
        static let posAllowance = "posAllowance"
        static let taxableMargin = "taxableMargin"
        static let initMargin = "initMargin"
        static let maintMargin = "maintMargin"
        static let sessionMargin = "sessionMargin"
        static let targetExcessMargin = "targetExcessMargin"
        static let varMargin = "varMargin"
        static let realisedGrossPnl = "realisedGrossPnl"
        static let realisedTax = "realisedTax"
        static let realisedPnl = "realisedPnl"
        static let unrealisedGrossPnl = "unrealisedGrossPnl"
        static let longBankrupt = "longBankrupt"
        static let shortBankrupt = "shortBankrupt"
        static let taxBase = "taxBase"
        static let indicativeTaxRate = "indicativeTaxRate"
        static let indicativeTax = "indicativeTax"
        static let unrealisedTax = "unrealisedTax"
        static let unrealisedPnl = "unrealisedPnl"
        static let unrealisedPnlPcnt = "unrealisedPnlPcnt"
        static let unrealisedRoePcnt = "unrealisedRoePcnt"
        static let simpleQty = "simpleQty"
        static let simpleCost = "simpleCost"
        static let simpleValue = "simpleValue"
        static let simplePnl = "simplePnl"
        static let simplePnlPcnt = "simplePnlPcnt"
        static let avgCostPrice = "avgCostPrice"
        static let avgEntryPrice = "avgEntryPrice"
        static let breakEvenPrice = "breakEvenPrice"
        static let marginCallPrice = "marginCallPrice"
        static let liquidationPrice = "liquidationPrice"
        static let bankruptPrice = "bankruptPrice"
        static let timestamp = "timestamp"
        static let lastPrice = "lastPrice"
        static let lastValue = "lastValue"
    }
    
    
    //MARK: Static Methods
    static func GET(authentication: Authentication, filter: [String: Any]? = nil, columns: [String]? = nil, count: Int? = nil, completion: @escaping ([Position]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        if let count = count {
            queryItems.append(URLQueryItem(name: "count", value: String(count)))
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
                    var result = [Position]()
                    for item in json {
                        let position = Position(json: item)
                        result.append(position)
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
    
    /// Enable isolated margin or cross margin per-position
    static func POST_ISOLATE(authentication: Authentication, symbol: String, enabled: Bool? = nil, completion: @escaping (Position?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_isolate
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var parameters: [String: Any] = [:]
        parameters["symbol"] = symbol
        if let enabled = enabled {
            parameters["enabled"] = enabled
        }
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let position = Position(json: item)
                    completion(position, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    /// Choose leverage for a position
    /// - Parameter leverage: Send a number between 0.01 and 100 to enable isolated margin with a fixed leverage. Send 0 to enable cross margin.
    static func POST_LEVERAGE(authentication: Authentication, symbol: String, leverage: Double? = nil, completion: @escaping (Position?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_leverage
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var parameters: [String: Any] = [:]
        parameters["symbol"] = symbol
        if let leverage = leverage {
            parameters["leverage"] = leverage
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let position = Position(json: item)
                    completion(position, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    /// Update your risk limit
    /// - Parameter riskLimit: New Risk Limit, in Satoshis.
    static func POST_RISKLIMIT(authentication: Authentication, symbol: String, riskLimit: Double? = nil, completion: @escaping (Position?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_riskLimit
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var parameters: [String: Any] = [:]
        parameters["symbol"] = symbol
        
        if let riskLimit = riskLimit {
            parameters["riskLimit"] = riskLimit
        }
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        
        
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let position = Position(json: item)
                    completion(position, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    
    
    /// Update your margin
    /// - Parameter amount: Amount to transfer, in Satoshis. May be negative.
    static func POST_TRANSFERMARGIN(authentication: Authentication, symbol: String, amount: Double? = nil, completion: @escaping (Position?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_transferMargin
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var parameters: [String: Any] = [:]
        parameters["symbol"] = symbol
        
        if let amount = amount {
            parameters["amount"] = amount
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        
        
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let position = Position(json: item)
                    completion(position, response, nil)
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
        
        
        let args: String = "\"position\""
        let message: String = "{\"op\": \"subscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
    }
    
    static func unsubscribeRealTime(webSocket: WebSocket, auth: Authentication) {
        let api_expires = String(Int(Date().timeIntervalSince1970.rounded()) + 5)
        let api_signature: String = "GET/realtime" + api_expires
        let sig = api_signature.hmac(algorithm: .SHA256, key: auth.apiSecret)
        webSocket.send(text: "{\"op\": \"authKeyExpires\", \"args\": [\"\(auth.apiKey)\", \(api_expires), \"\(sig)\"]}")
        
        
        let args: String = "\"position\""
        let message: String = "{\"op\": \"unsubscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
    }
    

}
