//
//  Execution.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Execution {
    //MARK: Constants
    static let endpoint = "/execution"
    static let endpoint_tradeHistory = "/execution/tradeHistory"
    
    //MARK: Properties
    var execID: String
    var orderID: String?
    var clOrdID: String?
    var clOrdLinkID: String?
    var account: Double?
    var symbol: String?
    var side: String?
    var lastQty: Double?
    var lastPx: Double?
    var underlyingLastPx: Double?
    var lastMkt: String?
    var lastLiquidityInd: String?
    var simpleOrderQty: Double?
    var orderQty: Double?
    var price: Double?
    var displayQty: Double?
    var stopPx: Double?
    var pegOffsetValue: Double?
    var pegPriceType: String?
    var currency: String?
    var settlCurrency: String?
    var execType: String?
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
    var commission: Double?
    var tradePublishIndicator: String?
    var multiLegReportingType: String?
    var text: String?
    var trdMatchID: String?
    var execCost: Double?
    var execComm: Double?
    var homeNotional: Double?
    var foreignNotional: Double?
    var transactTime: String?
    var timestamp: String?
    
    //MARK: Initialization
    private init(execID: String, orderID: String?, clOrdID: String?, clOrdLinkID: String?, account: Double?, symbol: String?, side: String?, lastQty: Double?, lastPx: Double?, underlyingLastPx: Double?, lastMkt: String?, lastLiquidityInd: String?, simpleOrderQty: Double?, orderQty: Double?, price: Double?, displayQty: Double?, stopPx: Double?, pegOffsetValue: Double?, pegPriceType: String?, currency: String?, settlCurrency: String?, execType: String?, ordType: String?, timeInForce: String?, execInst: String?, contingencyType: String?, exDestination: String?, ordStatus: String?, triggered: String?, workingIndicator: Bool?, ordRejReason: String?, simpleLeavesQty: Double?, leavesQty: Double?, simpleCumQty: Double?, cumQty: Double?, avgPx: Double?, commission: Double?, tradePublishIndicator: String?, multiLegReportingType: String?, text: String?, trdMatchID: String?, execCost: Double?, execComm: Double?, homeNotional: Double?, foreignNotional: Double?, transactTime: String?, timestamp: String?) {
        self.execID = execID
        self.orderID = orderID
        self.clOrdID = clOrdID
        self.clOrdLinkID = clOrdLinkID
        self.account = account
        self.symbol = symbol
        self.side = side
        self.lastQty = lastQty
        self.lastPx = lastPx
        self.underlyingLastPx = underlyingLastPx
        self.lastMkt = lastMkt
        self.lastLiquidityInd = lastLiquidityInd
        self.simpleOrderQty = simpleOrderQty
        self.orderQty = orderQty
        self.price = price
        self.displayQty = displayQty
        self.stopPx = stopPx
        self.pegOffsetValue = pegOffsetValue
        self.pegPriceType = pegPriceType
        self.currency = currency
        self.settlCurrency = settlCurrency
        self.execType = execType
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
        self.commission = commission
        self.tradePublishIndicator = tradePublishIndicator
        self.multiLegReportingType = multiLegReportingType
        self.text = text
        self.trdMatchID = trdMatchID
        self.execCost = execCost
        self.execComm = execComm
        self.homeNotional = homeNotional
        self.foreignNotional = foreignNotional
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
        static let lastQty = "lastQty"
        static let lastPx = "lastPx"
        static let underlyingLastPx = "underlyingLastPx"
        static let lastMkt = "lastMkt"
        static let lastLiquidityInd = "lastLiquidityInd"
        static let simpleOrderQty = "simpleOrderQty"
        static let orderQty = "orderQty"
        static let price = "price"
        static let displayQty = "displayQty"
        static let stopPx = "stopPx"
        static let pegOffsetValue = "pegOffsetValue"
        static let pegPriceType = "pegPriceType"
        static let currency = "currency"
        static let settlCurrency = "settlCurrency"
        static let execType = "execType"
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
        static let commission = "commission"
        static let tradePublishIndicator = "tradePublishIndicator"
        static let multiLegReportingType = "multiLegReportingType"
        static let text = "text"
        static let trdMatchID = "trdMatchID"
        static let execCost = "execCost"
        static let execComm = "execComm"
        static let homeNotional = "homeNotional"
        static let foreignNotional = "foreignNotional"
        static let transactTime = "transactTime"
        static let timestamp = "timestamp"
    }
    
    //MARK: Static Methods
    static func GET(authentication: Authentication, symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Execution]?, URLResponse?, Error?) -> Void) {
        _GET(authentication: authentication, symbol: symbol, count: count, reverse: reverse, startTime: startTime, endTime: endTime, filter: filter, columns: columns, completion: completion)
    }
    
    static func GET_TradeHistory(authentication: Authentication, symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Execution]?, URLResponse?, Error?) -> Void) {
        _GET(tradeHistory: true, authentication: authentication, symbol: symbol, count: count, reverse: reverse, startTime: startTime, endTime: endTime, filter: filter, columns: columns, completion: completion)
    }
    
    
    private static func _GET(tradeHistory: Bool = false, authentication: Authentication, symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Execution]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + (tradeHistory ? endpoint_tradeHistory : endpoint)
        
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

        urlComponents.queryItems = queryItems
        
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
                    var result = [Execution]()
                    for item in json {
                        let execID: String = item["execID"] as! String
                        let orderID: String? = item["orderID"] as? String
                        let clOrdID: String? = item["clOrdID"] as? String
                        let clOrdLinkID: String? = item["clOrdLinkID"] as? String
                        let account: Double? = item["account"] as? Double
                        let symbol: String? = item["symbol"] as? String
                        let side: String? = item["side"] as? String
                        let lastQty: Double? = item["lastQty"] as? Double
                        let lastPx: Double? = item["lastPx"] as? Double
                        let underlyingLastPx: Double? = item["underlyingLastPx"] as? Double
                        let lastMkt: String? = item["lastMkt"] as? String
                        let lastLiquidityInd: String? = item["lastLiquidityInd"] as? String
                        let simpleOrderQty: Double? = item["simpleOrderQty"] as? Double
                        let orderQty: Double? = item["orderQty"] as? Double
                        let price: Double? = item["price"] as? Double
                        let displayQty: Double? = item["displayQty"] as? Double
                        let stopPx: Double? = item["stopPx"] as? Double
                        let pegOffsetValue: Double? = item["pegOffsetValue"] as? Double
                        let pegPriceType: String? = item["pegPriceType"] as? String
                        let currency: String? = item["currency"] as? String
                        let settlCurrency: String? = item["settlCurrency"] as? String
                        let execType: String? = item["execType"] as? String
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
                        let commission: Double? = item["commission"] as? Double
                        let tradePublishIndicator: String? = item["tradePublishIndicator"] as? String
                        let multiLegReportingType: String? = item["multiLegReportingType"] as? String
                        let text: String? = item["text"] as? String
                        let trdMatchID: String? = item["trdMatchID"] as? String
                        let execCost: Double? = item["execCost"] as? Double
                        let execComm: Double? = item["execComm"] as? Double
                        let homeNotional: Double? = item["homeNotional"] as? Double
                        let foreignNotional: Double? = item["foreignNotional"] as? Double
                        let transactTime: String? = item["transactTime"] as? String
                        let timestamp: String? = item["timestamp"] as? String
                        let execution = Execution(execID: execID, orderID: orderID, clOrdID: clOrdID, clOrdLinkID: clOrdLinkID, account: account, symbol: symbol, side: side, lastQty: lastQty, lastPx: lastPx, underlyingLastPx: underlyingLastPx, lastMkt: lastMkt, lastLiquidityInd: lastLiquidityInd, simpleOrderQty: simpleOrderQty, orderQty: orderQty, price: price, displayQty: displayQty, stopPx: stopPx, pegOffsetValue: pegOffsetValue, pegPriceType: pegPriceType, currency: currency, settlCurrency: settlCurrency, execType: execType, ordType: ordType, timeInForce: timeInForce, execInst: execInst, contingencyType: contingencyType, exDestination: exDestination, ordStatus: ordStatus, triggered: triggered, workingIndicator: workingIndicator, ordRejReason: ordRejReason, simpleLeavesQty: simpleLeavesQty, leavesQty: leavesQty, simpleCumQty: simpleCumQty, cumQty: cumQty, avgPx: avgPx, commission: commission, tradePublishIndicator: tradePublishIndicator, multiLegReportingType: multiLegReportingType, text: text, trdMatchID: trdMatchID, execCost: execCost, execComm: execComm, homeNotional: homeNotional, foreignNotional: foreignNotional, transactTime: transactTime, timestamp: timestamp)
                        result.append(execution)
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
