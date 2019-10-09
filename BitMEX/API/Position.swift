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
    var unrealisedPnl: Double?
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
    private init(account: Int, symbol: String, currency: String, underlying: String?, quoteCurrency: String?, commission: Double?, initMarginReq: Double?, maintMarginReq: Double?, riskLimit: Double?, leverage: Double?, crossMargin: Bool?, deleveragePercentile: Double?, rebalancedPnl: Double?, prevRealisedPnl: Double?, prevUnrealisedPnl: Double?, prevClosePrice: Double?, openingTimestamp: String?, openingQty: Double?, openingCost: Double?, openingComm: Double?, openOrderBuyQty: Double?, openOrderBuyCost: Double?, openOrderBuyPremium: Double?, openOrderSellQty: Double?, openOrderSellCost: Double?, openOrderSellPremium: Double?, execBuyQty: Double?, execBuyCost: Double?, execSellQty: Double?, execSellCost: Double?, execQty: Double?, execCost: Double?, execComm: Double?, currentTimestamp: String?, currentQty: Double?, currentCost: Double?, currentComm: Double?, realisedCost: Double?, unrealisedCost: Double?, grossOpenCost: Double?, grossOpenPremium: Double?, grossExecCost: Double?, isOpen: Bool?, markPrice: Double?, markValue: Double?, riskValue: Double?, homeNotional: Double?, foreignNotional: Double?, posState: String?, posCost: Double?, posCost2: Double?, posCross: Double?, posInit: Double?, posComm: Double?, posLoss: Double?, posMargin: Double?, posMaint: Double?, posAllowance: Double?, taxableMargin: Double?, initMargin: Double?, maintMargin: Double?, sessionMargin: Double?, targetExcessMargin: Double?, varMargin: Double?, realisedGrossPnl: Double?, realisedTax: Double?, realisedPnl: Double?, unrealisedGrossPnl: Double?, longBankrupt: Double?, shortBankrupt: Double?, taxBase: Double?, indicativeTaxRate: Double?, indicativeTax: Double?, unrealisedTax: Double?, unrealisedPnl: Double?, unrealisedPnlPcnt: Double?, unrealisedRoePcnt: Double?, simpleQty: Double?, simpleCost: Double?, simpleValue: Double?, simplePnl: Double?, simplePnlPcnt: Double?, avgCostPrice: Double?, avgEntryPrice: Double?, breakEvenPrice: Double?, marginCallPrice: Double?, liquidationPrice: Double?, bankruptPrice: Double?, timestamp: String?, lastPrice: Double?, lastValue: Double?) {
        self.account = account
        self.symbol = symbol
        self.currency = currency
        self.underlying = underlying
        self.quoteCurrency = quoteCurrency
        self.commission = commission
        self.initMarginReq = initMarginReq
        self.maintMarginReq = maintMarginReq
        self.riskLimit = riskLimit
        self.leverage = leverage
        self.crossMargin = crossMargin
        self.deleveragePercentile = deleveragePercentile
        self.rebalancedPnl = rebalancedPnl
        self.prevRealisedPnl = prevRealisedPnl
        self.prevUnrealisedPnl = prevUnrealisedPnl
        self.prevClosePrice = prevClosePrice
        self.openingTimestamp = openingTimestamp
        self.openingQty = openingQty
        self.openingCost = openingCost
        self.openingComm = openingComm
        self.openOrderBuyQty = openOrderBuyQty
        self.openOrderBuyCost = openOrderBuyCost
        self.openOrderBuyPremium = openOrderBuyPremium
        self.openOrderSellQty = openOrderSellQty
        self.openOrderSellCost = openOrderSellCost
        self.openOrderSellPremium = openOrderSellPremium
        self.execBuyQty = execBuyQty
        self.execBuyCost = execBuyCost
        self.execSellQty = execSellQty
        self.execSellCost = execSellCost
        self.execQty = execQty
        self.execCost = execCost
        self.execComm = execComm
        self.currentTimestamp = currentTimestamp
        self.currentQty = currentQty
        self.currentCost = currentCost
        self.currentComm = currentComm
        self.realisedCost = realisedCost
        self.unrealisedCost = unrealisedCost
        self.grossOpenCost = grossOpenCost
        self.grossOpenPremium = grossOpenPremium
        self.grossExecCost = grossExecCost
        self.isOpen = isOpen
        self.markPrice = markPrice
        self.markValue = markValue
        self.riskValue = riskValue
        self.homeNotional = homeNotional
        self.foreignNotional = foreignNotional
        self.posState = posState
        self.posCost = posCost
        self.posCost2 = posCost2
        self.posCross = posCross
        self.posInit = posInit
        self.posComm = posComm
        self.posLoss = posLoss
        self.posMargin = posMargin
        self.posMaint = posMaint
        self.posAllowance = posAllowance
        self.taxableMargin = taxableMargin
        self.initMargin = initMargin
        self.maintMargin = maintMargin
        self.sessionMargin = sessionMargin
        self.targetExcessMargin = targetExcessMargin
        self.varMargin = varMargin
        self.realisedGrossPnl = realisedGrossPnl
        self.realisedTax = realisedTax
        self.realisedPnl = realisedPnl
        self.unrealisedGrossPnl = unrealisedGrossPnl
        self.longBankrupt = longBankrupt
        self.shortBankrupt = shortBankrupt
        self.taxBase = taxBase
        self.indicativeTaxRate = indicativeTaxRate
        self.indicativeTax = indicativeTax
        self.unrealisedTax = unrealisedTax
        self.unrealisedPnl = unrealisedPnl
        self.unrealisedPnlPcnt = unrealisedPnlPcnt
        self.unrealisedRoePcnt = unrealisedRoePcnt
        self.simpleQty = simpleQty
        self.simpleCost = simpleCost
        self.simpleValue = simpleValue
        self.simplePnl = simplePnl
        self.simplePnlPcnt = simplePnlPcnt
        self.avgCostPrice = avgCostPrice
        self.avgEntryPrice = avgEntryPrice
        self.breakEvenPrice = breakEvenPrice
        self.marginCallPrice = marginCallPrice
        self.liquidationPrice = liquidationPrice
        self.bankruptPrice = bankruptPrice
        self.timestamp = timestamp
        self.lastPrice = lastPrice
        self.lastValue = lastValue
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
                        let account: Int = item["account"] as! Int
                        let symbol: String = item["symbol"] as! String
                        let currency: String = item["currency"] as! String
                        let underlying: String? = item["underlying"] as? String
                        let quoteCurrency: String? = item["quoteCurrency"] as? String
                        let commission: Double? = item["commission"] as? Double
                        let initMarginReq: Double? = item["initMarginReq"] as? Double
                        let maintMarginReq: Double? = item["maintMarginReq"] as? Double
                        let riskLimit: Double? = item["riskLimit"] as? Double
                        let leverage: Double? = item["leverage"] as? Double
                        let crossMargin: Bool? = item["crossMargin"] as? Bool
                        let deleveragePercentile: Double? = item["deleveragePercentile"] as? Double
                        let rebalancedPnl: Double? = item["rebalancedPnl"] as? Double
                        let prevRealisedPnl: Double? = item["prevRealisedPnl"] as? Double
                        let prevUnrealisedPnl: Double? = item["prevUnrealisedPnl"] as? Double
                        let prevClosePrice: Double? = item["prevClosePrice"] as? Double
                        let openingTimestamp: String? = item["openingTimestamp"] as? String
                        let openingQty: Double? = item["openingQty"] as? Double
                        let openingCost: Double? = item["openingCost"] as? Double
                        let openingComm: Double? = item["openingComm"] as? Double
                        let openOrderBuyQty: Double? = item["openOrderBuyQty"] as? Double
                        let openOrderBuyCost: Double? = item["openOrderBuyCost"] as? Double
                        let openOrderBuyPremium: Double? = item["openOrderBuyPremium"] as? Double
                        let openOrderSellQty: Double? = item["openOrderSellQty"] as? Double
                        let openOrderSellCost: Double? = item["openOrderSellCost"] as? Double
                        let openOrderSellPremium: Double? = item["openOrderSellPremium"] as? Double
                        let execBuyQty: Double? = item["execBuyQty"] as? Double
                        let execBuyCost: Double? = item["execBuyCost"] as? Double
                        let execSellQty: Double? = item["execSellQty"] as? Double
                        let execSellCost: Double? = item["execSellCost"] as? Double
                        let execQty: Double? = item["execQty"] as? Double
                        let execCost: Double? = item["execCost"] as? Double
                        let execComm: Double? = item["execComm"] as? Double
                        let currentTimestamp: String? = item["currentTimestamp"] as? String
                        let currentQty: Double? = item["currentQty"] as? Double
                        let currentCost: Double? = item["currentCost"] as? Double
                        let currentComm: Double? = item["currentComm"] as? Double
                        let realisedCost: Double? = item["realisedCost"] as? Double
                        let unrealisedCost: Double? = item["unrealisedCost"] as? Double
                        let grossOpenCost: Double? = item["grossOpenCost"] as? Double
                        let grossOpenPremium: Double? = item["grossOpenPremium"] as? Double
                        let grossExecCost: Double? = item["grossExecCost"] as? Double
                        let isOpen: Bool? = item["isOpen"] as? Bool
                        let markPrice: Double? = item["markPrice"] as? Double
                        let markValue: Double? = item["markValue"] as? Double
                        let riskValue: Double? = item["riskValue"] as? Double
                        let homeNotional: Double? = item["homeNotional"] as? Double
                        let foreignNotional: Double? = item["foreignNotional"] as? Double
                        let posState: String? = item["posState"] as? String
                        let posCost: Double? = item["posCost"] as? Double
                        let posCost2: Double? = item["posCost2"] as? Double
                        let posCross: Double? = item["posCross"] as? Double
                        let posInit: Double? = item["posInit"] as? Double
                        let posComm: Double? = item["posComm"] as? Double
                        let posLoss: Double? = item["posLoss"] as? Double
                        let posMargin: Double? = item["posMargin"] as? Double
                        let posMaint: Double? = item["posMaint"] as? Double
                        let posAllowance: Double? = item["posAllowance"] as? Double
                        let taxableMargin: Double? = item["taxableMargin"] as? Double
                        let initMargin: Double? = item["initMargin"] as? Double
                        let maintMargin: Double? = item["maintMargin"] as? Double
                        let sessionMargin: Double? = item["sessionMargin"] as? Double
                        let targetExcessMargin: Double? = item["targetExcessMargin"] as? Double
                        let varMargin: Double? = item["varMargin"] as? Double
                        let realisedGrossPnl: Double? = item["realisedGrossPnl"] as? Double
                        let realisedTax: Double? = item["realisedTax"] as? Double
                        let realisedPnl: Double? = item["realisedPnl"] as? Double
                        let unrealisedGrossPnl: Double? = item["unrealisedGrossPnl"] as? Double
                        let longBankrupt: Double? = item["longBankrupt"] as? Double
                        let shortBankrupt: Double? = item["shortBankrupt"] as? Double
                        let taxBase: Double? = item["taxBase"] as? Double
                        let indicativeTaxRate: Double? = item["indicativeTaxRate"] as? Double
                        let indicativeTax: Double? = item["indicativeTax"] as? Double
                        let unrealisedTax: Double? = item["unrealisedTax"] as? Double
                        let unrealisedPnl: Double? = item["unrealisedPnl"] as? Double
                        let unrealisedPnlPcnt: Double? = item["unrealisedPnlPcnt"] as? Double
                        let unrealisedRoePcnt: Double? = item["unrealisedRoePcnt"] as? Double
                        let simpleQty: Double? = item["simpleQty"] as? Double
                        let simpleCost: Double? = item["simpleCost"] as? Double
                        let simpleValue: Double? = item["simpleValue"] as? Double
                        let simplePnl: Double? = item["simplePnl"] as? Double
                        let simplePnlPcnt: Double? = item["simplePnlPcnt"] as? Double
                        let avgCostPrice: Double? = item["avgCostPrice"] as? Double
                        let avgEntryPrice: Double? = item["avgEntryPrice"] as? Double
                        let breakEvenPrice: Double? = item["breakEvenPrice"] as? Double
                        let marginCallPrice: Double? = item["marginCallPrice"] as? Double
                        let liquidationPrice: Double? = item["liquidationPrice"] as? Double
                        let bankruptPrice: Double? = item["bankruptPrice"] as? Double
                        let timestamp: String? = item["timestamp"] as? String
                        let lastPrice: Double? = item["lastPrice"] as? Double
                        let lastValue: Double? = item["lastValue"] as? Double
                        let position = Position(account: account, symbol: symbol, currency: currency, underlying: underlying, quoteCurrency: quoteCurrency, commission: commission, initMarginReq: initMarginReq, maintMarginReq: maintMarginReq, riskLimit: riskLimit, leverage: leverage, crossMargin: crossMargin, deleveragePercentile: deleveragePercentile, rebalancedPnl: rebalancedPnl, prevRealisedPnl: prevRealisedPnl, prevUnrealisedPnl: prevUnrealisedPnl, prevClosePrice: prevClosePrice, openingTimestamp: openingTimestamp, openingQty: openingQty, openingCost: openingCost, openingComm: openingComm, openOrderBuyQty: openOrderBuyQty, openOrderBuyCost: openOrderBuyCost, openOrderBuyPremium: openOrderBuyPremium, openOrderSellQty: openOrderSellQty, openOrderSellCost: openOrderSellCost, openOrderSellPremium: openOrderSellPremium, execBuyQty: execBuyQty, execBuyCost: execBuyCost, execSellQty: execSellQty, execSellCost: execSellCost, execQty: execQty, execCost: execCost, execComm: execComm, currentTimestamp: currentTimestamp, currentQty: currentQty, currentCost: currentCost, currentComm: currentComm, realisedCost: realisedCost, unrealisedCost: unrealisedCost, grossOpenCost: grossOpenCost, grossOpenPremium: grossOpenPremium, grossExecCost: grossExecCost, isOpen: isOpen, markPrice: markPrice, markValue: markValue, riskValue: riskValue, homeNotional: homeNotional, foreignNotional: foreignNotional, posState: posState, posCost: posCost, posCost2: posCost2, posCross: posCross, posInit: posInit, posComm: posComm, posLoss: posLoss, posMargin: posMargin, posMaint: posMaint, posAllowance: posAllowance, taxableMargin: taxableMargin, initMargin: initMargin, maintMargin: maintMargin, sessionMargin: sessionMargin, targetExcessMargin: targetExcessMargin, varMargin: varMargin, realisedGrossPnl: realisedGrossPnl, realisedTax: realisedTax, realisedPnl: realisedPnl, unrealisedGrossPnl: unrealisedGrossPnl, longBankrupt: longBankrupt, shortBankrupt: shortBankrupt, taxBase: taxBase, indicativeTaxRate: indicativeTaxRate, indicativeTax: indicativeTax, unrealisedTax: unrealisedTax, unrealisedPnl: unrealisedPnl, unrealisedPnlPcnt: unrealisedPnlPcnt, unrealisedRoePcnt: unrealisedRoePcnt, simpleQty: simpleQty, simpleCost: simpleCost, simpleValue: simpleValue, simplePnl: simplePnl, simplePnlPcnt: simplePnlPcnt, avgCostPrice: avgCostPrice, avgEntryPrice: avgEntryPrice, breakEvenPrice: breakEvenPrice, marginCallPrice: marginCallPrice, liquidationPrice: liquidationPrice, bankruptPrice: bankruptPrice, timestamp: timestamp, lastPrice: lastPrice, lastValue: lastValue)
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
                    let account: Int = item["account"] as! Int
                    let symbol: String = item["symbol"] as! String
                    let currency: String = item["currency"] as! String
                    let underlying: String? = item["underlying"] as? String
                    let quoteCurrency: String? = item["quoteCurrency"] as? String
                    let commission: Double? = item["commission"] as? Double
                    let initMarginReq: Double? = item["initMarginReq"] as? Double
                    let maintMarginReq: Double? = item["maintMarginReq"] as? Double
                    let riskLimit: Double? = item["riskLimit"] as? Double
                    let leverage: Double? = item["leverage"] as? Double
                    let crossMargin: Bool? = item["crossMargin"] as? Bool
                    let deleveragePercentile: Double? = item["deleveragePercentile"] as? Double
                    let rebalancedPnl: Double? = item["rebalancedPnl"] as? Double
                    let prevRealisedPnl: Double? = item["prevRealisedPnl"] as? Double
                    let prevUnrealisedPnl: Double? = item["prevUnrealisedPnl"] as? Double
                    let prevClosePrice: Double? = item["prevClosePrice"] as? Double
                    let openingTimestamp: String? = item["openingTimestamp"] as? String
                    let openingQty: Double? = item["openingQty"] as? Double
                    let openingCost: Double? = item["openingCost"] as? Double
                    let openingComm: Double? = item["openingComm"] as? Double
                    let openOrderBuyQty: Double? = item["openOrderBuyQty"] as? Double
                    let openOrderBuyCost: Double? = item["openOrderBuyCost"] as? Double
                    let openOrderBuyPremium: Double? = item["openOrderBuyPremium"] as? Double
                    let openOrderSellQty: Double? = item["openOrderSellQty"] as? Double
                    let openOrderSellCost: Double? = item["openOrderSellCost"] as? Double
                    let openOrderSellPremium: Double? = item["openOrderSellPremium"] as? Double
                    let execBuyQty: Double? = item["execBuyQty"] as? Double
                    let execBuyCost: Double? = item["execBuyCost"] as? Double
                    let execSellQty: Double? = item["execSellQty"] as? Double
                    let execSellCost: Double? = item["execSellCost"] as? Double
                    let execQty: Double? = item["execQty"] as? Double
                    let execCost: Double? = item["execCost"] as? Double
                    let execComm: Double? = item["execComm"] as? Double
                    let currentTimestamp: String? = item["currentTimestamp"] as? String
                    let currentQty: Double? = item["currentQty"] as? Double
                    let currentCost: Double? = item["currentCost"] as? Double
                    let currentComm: Double? = item["currentComm"] as? Double
                    let realisedCost: Double? = item["realisedCost"] as? Double
                    let unrealisedCost: Double? = item["unrealisedCost"] as? Double
                    let grossOpenCost: Double? = item["grossOpenCost"] as? Double
                    let grossOpenPremium: Double? = item["grossOpenPremium"] as? Double
                    let grossExecCost: Double? = item["grossExecCost"] as? Double
                    let isOpen: Bool? = item["isOpen"] as? Bool
                    let markPrice: Double? = item["markPrice"] as? Double
                    let markValue: Double? = item["markValue"] as? Double
                    let riskValue: Double? = item["riskValue"] as? Double
                    let homeNotional: Double? = item["homeNotional"] as? Double
                    let foreignNotional: Double? = item["foreignNotional"] as? Double
                    let posState: String? = item["posState"] as? String
                    let posCost: Double? = item["posCost"] as? Double
                    let posCost2: Double? = item["posCost2"] as? Double
                    let posCross: Double? = item["posCross"] as? Double
                    let posInit: Double? = item["posInit"] as? Double
                    let posComm: Double? = item["posComm"] as? Double
                    let posLoss: Double? = item["posLoss"] as? Double
                    let posMargin: Double? = item["posMargin"] as? Double
                    let posMaint: Double? = item["posMaint"] as? Double
                    let posAllowance: Double? = item["posAllowance"] as? Double
                    let taxableMargin: Double? = item["taxableMargin"] as? Double
                    let initMargin: Double? = item["initMargin"] as? Double
                    let maintMargin: Double? = item["maintMargin"] as? Double
                    let sessionMargin: Double? = item["sessionMargin"] as? Double
                    let targetExcessMargin: Double? = item["targetExcessMargin"] as? Double
                    let varMargin: Double? = item["varMargin"] as? Double
                    let realisedGrossPnl: Double? = item["realisedGrossPnl"] as? Double
                    let realisedTax: Double? = item["realisedTax"] as? Double
                    let realisedPnl: Double? = item["realisedPnl"] as? Double
                    let unrealisedGrossPnl: Double? = item["unrealisedGrossPnl"] as? Double
                    let longBankrupt: Double? = item["longBankrupt"] as? Double
                    let shortBankrupt: Double? = item["shortBankrupt"] as? Double
                    let taxBase: Double? = item["taxBase"] as? Double
                    let indicativeTaxRate: Double? = item["indicativeTaxRate"] as? Double
                    let indicativeTax: Double? = item["indicativeTax"] as? Double
                    let unrealisedTax: Double? = item["unrealisedTax"] as? Double
                    let unrealisedPnl: Double? = item["unrealisedPnl"] as? Double
                    let unrealisedPnlPcnt: Double? = item["unrealisedPnlPcnt"] as? Double
                    let unrealisedRoePcnt: Double? = item["unrealisedRoePcnt"] as? Double
                    let simpleQty: Double? = item["simpleQty"] as? Double
                    let simpleCost: Double? = item["simpleCost"] as? Double
                    let simpleValue: Double? = item["simpleValue"] as? Double
                    let simplePnl: Double? = item["simplePnl"] as? Double
                    let simplePnlPcnt: Double? = item["simplePnlPcnt"] as? Double
                    let avgCostPrice: Double? = item["avgCostPrice"] as? Double
                    let avgEntryPrice: Double? = item["avgEntryPrice"] as? Double
                    let breakEvenPrice: Double? = item["breakEvenPrice"] as? Double
                    let marginCallPrice: Double? = item["marginCallPrice"] as? Double
                    let liquidationPrice: Double? = item["liquidationPrice"] as? Double
                    let bankruptPrice: Double? = item["bankruptPrice"] as? Double
                    let timestamp: String? = item["timestamp"] as? String
                    let lastPrice: Double? = item["lastPrice"] as? Double
                    let lastValue: Double? = item["lastValue"] as? Double
                    let position = Position(account: account, symbol: symbol, currency: currency, underlying: underlying, quoteCurrency: quoteCurrency, commission: commission, initMarginReq: initMarginReq, maintMarginReq: maintMarginReq, riskLimit: riskLimit, leverage: leverage, crossMargin: crossMargin, deleveragePercentile: deleveragePercentile, rebalancedPnl: rebalancedPnl, prevRealisedPnl: prevRealisedPnl, prevUnrealisedPnl: prevUnrealisedPnl, prevClosePrice: prevClosePrice, openingTimestamp: openingTimestamp, openingQty: openingQty, openingCost: openingCost, openingComm: openingComm, openOrderBuyQty: openOrderBuyQty, openOrderBuyCost: openOrderBuyCost, openOrderBuyPremium: openOrderBuyPremium, openOrderSellQty: openOrderSellQty, openOrderSellCost: openOrderSellCost, openOrderSellPremium: openOrderSellPremium, execBuyQty: execBuyQty, execBuyCost: execBuyCost, execSellQty: execSellQty, execSellCost: execSellCost, execQty: execQty, execCost: execCost, execComm: execComm, currentTimestamp: currentTimestamp, currentQty: currentQty, currentCost: currentCost, currentComm: currentComm, realisedCost: realisedCost, unrealisedCost: unrealisedCost, grossOpenCost: grossOpenCost, grossOpenPremium: grossOpenPremium, grossExecCost: grossExecCost, isOpen: isOpen, markPrice: markPrice, markValue: markValue, riskValue: riskValue, homeNotional: homeNotional, foreignNotional: foreignNotional, posState: posState, posCost: posCost, posCost2: posCost2, posCross: posCross, posInit: posInit, posComm: posComm, posLoss: posLoss, posMargin: posMargin, posMaint: posMaint, posAllowance: posAllowance, taxableMargin: taxableMargin, initMargin: initMargin, maintMargin: maintMargin, sessionMargin: sessionMargin, targetExcessMargin: targetExcessMargin, varMargin: varMargin, realisedGrossPnl: realisedGrossPnl, realisedTax: realisedTax, realisedPnl: realisedPnl, unrealisedGrossPnl: unrealisedGrossPnl, longBankrupt: longBankrupt, shortBankrupt: shortBankrupt, taxBase: taxBase, indicativeTaxRate: indicativeTaxRate, indicativeTax: indicativeTax, unrealisedTax: unrealisedTax, unrealisedPnl: unrealisedPnl, unrealisedPnlPcnt: unrealisedPnlPcnt, unrealisedRoePcnt: unrealisedRoePcnt, simpleQty: simpleQty, simpleCost: simpleCost, simpleValue: simpleValue, simplePnl: simplePnl, simplePnlPcnt: simplePnlPcnt, avgCostPrice: avgCostPrice, avgEntryPrice: avgEntryPrice, breakEvenPrice: breakEvenPrice, marginCallPrice: marginCallPrice, liquidationPrice: liquidationPrice, bankruptPrice: bankruptPrice, timestamp: timestamp, lastPrice: lastPrice, lastValue: lastValue)
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
                    let account: Int = item["account"] as! Int
                    let symbol: String = item["symbol"] as! String
                    let currency: String = item["currency"] as! String
                    let underlying: String? = item["underlying"] as? String
                    let quoteCurrency: String? = item["quoteCurrency"] as? String
                    let commission: Double? = item["commission"] as? Double
                    let initMarginReq: Double? = item["initMarginReq"] as? Double
                    let maintMarginReq: Double? = item["maintMarginReq"] as? Double
                    let riskLimit: Double? = item["riskLimit"] as? Double
                    let leverage: Double? = item["leverage"] as? Double
                    let crossMargin: Bool? = item["crossMargin"] as? Bool
                    let deleveragePercentile: Double? = item["deleveragePercentile"] as? Double
                    let rebalancedPnl: Double? = item["rebalancedPnl"] as? Double
                    let prevRealisedPnl: Double? = item["prevRealisedPnl"] as? Double
                    let prevUnrealisedPnl: Double? = item["prevUnrealisedPnl"] as? Double
                    let prevClosePrice: Double? = item["prevClosePrice"] as? Double
                    let openingTimestamp: String? = item["openingTimestamp"] as? String
                    let openingQty: Double? = item["openingQty"] as? Double
                    let openingCost: Double? = item["openingCost"] as? Double
                    let openingComm: Double? = item["openingComm"] as? Double
                    let openOrderBuyQty: Double? = item["openOrderBuyQty"] as? Double
                    let openOrderBuyCost: Double? = item["openOrderBuyCost"] as? Double
                    let openOrderBuyPremium: Double? = item["openOrderBuyPremium"] as? Double
                    let openOrderSellQty: Double? = item["openOrderSellQty"] as? Double
                    let openOrderSellCost: Double? = item["openOrderSellCost"] as? Double
                    let openOrderSellPremium: Double? = item["openOrderSellPremium"] as? Double
                    let execBuyQty: Double? = item["execBuyQty"] as? Double
                    let execBuyCost: Double? = item["execBuyCost"] as? Double
                    let execSellQty: Double? = item["execSellQty"] as? Double
                    let execSellCost: Double? = item["execSellCost"] as? Double
                    let execQty: Double? = item["execQty"] as? Double
                    let execCost: Double? = item["execCost"] as? Double
                    let execComm: Double? = item["execComm"] as? Double
                    let currentTimestamp: String? = item["currentTimestamp"] as? String
                    let currentQty: Double? = item["currentQty"] as? Double
                    let currentCost: Double? = item["currentCost"] as? Double
                    let currentComm: Double? = item["currentComm"] as? Double
                    let realisedCost: Double? = item["realisedCost"] as? Double
                    let unrealisedCost: Double? = item["unrealisedCost"] as? Double
                    let grossOpenCost: Double? = item["grossOpenCost"] as? Double
                    let grossOpenPremium: Double? = item["grossOpenPremium"] as? Double
                    let grossExecCost: Double? = item["grossExecCost"] as? Double
                    let isOpen: Bool? = item["isOpen"] as? Bool
                    let markPrice: Double? = item["markPrice"] as? Double
                    let markValue: Double? = item["markValue"] as? Double
                    let riskValue: Double? = item["riskValue"] as? Double
                    let homeNotional: Double? = item["homeNotional"] as? Double
                    let foreignNotional: Double? = item["foreignNotional"] as? Double
                    let posState: String? = item["posState"] as? String
                    let posCost: Double? = item["posCost"] as? Double
                    let posCost2: Double? = item["posCost2"] as? Double
                    let posCross: Double? = item["posCross"] as? Double
                    let posInit: Double? = item["posInit"] as? Double
                    let posComm: Double? = item["posComm"] as? Double
                    let posLoss: Double? = item["posLoss"] as? Double
                    let posMargin: Double? = item["posMargin"] as? Double
                    let posMaint: Double? = item["posMaint"] as? Double
                    let posAllowance: Double? = item["posAllowance"] as? Double
                    let taxableMargin: Double? = item["taxableMargin"] as? Double
                    let initMargin: Double? = item["initMargin"] as? Double
                    let maintMargin: Double? = item["maintMargin"] as? Double
                    let sessionMargin: Double? = item["sessionMargin"] as? Double
                    let targetExcessMargin: Double? = item["targetExcessMargin"] as? Double
                    let varMargin: Double? = item["varMargin"] as? Double
                    let realisedGrossPnl: Double? = item["realisedGrossPnl"] as? Double
                    let realisedTax: Double? = item["realisedTax"] as? Double
                    let realisedPnl: Double? = item["realisedPnl"] as? Double
                    let unrealisedGrossPnl: Double? = item["unrealisedGrossPnl"] as? Double
                    let longBankrupt: Double? = item["longBankrupt"] as? Double
                    let shortBankrupt: Double? = item["shortBankrupt"] as? Double
                    let taxBase: Double? = item["taxBase"] as? Double
                    let indicativeTaxRate: Double? = item["indicativeTaxRate"] as? Double
                    let indicativeTax: Double? = item["indicativeTax"] as? Double
                    let unrealisedTax: Double? = item["unrealisedTax"] as? Double
                    let unrealisedPnl: Double? = item["unrealisedPnl"] as? Double
                    let unrealisedPnlPcnt: Double? = item["unrealisedPnlPcnt"] as? Double
                    let unrealisedRoePcnt: Double? = item["unrealisedRoePcnt"] as? Double
                    let simpleQty: Double? = item["simpleQty"] as? Double
                    let simpleCost: Double? = item["simpleCost"] as? Double
                    let simpleValue: Double? = item["simpleValue"] as? Double
                    let simplePnl: Double? = item["simplePnl"] as? Double
                    let simplePnlPcnt: Double? = item["simplePnlPcnt"] as? Double
                    let avgCostPrice: Double? = item["avgCostPrice"] as? Double
                    let avgEntryPrice: Double? = item["avgEntryPrice"] as? Double
                    let breakEvenPrice: Double? = item["breakEvenPrice"] as? Double
                    let marginCallPrice: Double? = item["marginCallPrice"] as? Double
                    let liquidationPrice: Double? = item["liquidationPrice"] as? Double
                    let bankruptPrice: Double? = item["bankruptPrice"] as? Double
                    let timestamp: String? = item["timestamp"] as? String
                    let lastPrice: Double? = item["lastPrice"] as? Double
                    let lastValue: Double? = item["lastValue"] as? Double
                    let position = Position(account: account, symbol: symbol, currency: currency, underlying: underlying, quoteCurrency: quoteCurrency, commission: commission, initMarginReq: initMarginReq, maintMarginReq: maintMarginReq, riskLimit: riskLimit, leverage: leverage, crossMargin: crossMargin, deleveragePercentile: deleveragePercentile, rebalancedPnl: rebalancedPnl, prevRealisedPnl: prevRealisedPnl, prevUnrealisedPnl: prevUnrealisedPnl, prevClosePrice: prevClosePrice, openingTimestamp: openingTimestamp, openingQty: openingQty, openingCost: openingCost, openingComm: openingComm, openOrderBuyQty: openOrderBuyQty, openOrderBuyCost: openOrderBuyCost, openOrderBuyPremium: openOrderBuyPremium, openOrderSellQty: openOrderSellQty, openOrderSellCost: openOrderSellCost, openOrderSellPremium: openOrderSellPremium, execBuyQty: execBuyQty, execBuyCost: execBuyCost, execSellQty: execSellQty, execSellCost: execSellCost, execQty: execQty, execCost: execCost, execComm: execComm, currentTimestamp: currentTimestamp, currentQty: currentQty, currentCost: currentCost, currentComm: currentComm, realisedCost: realisedCost, unrealisedCost: unrealisedCost, grossOpenCost: grossOpenCost, grossOpenPremium: grossOpenPremium, grossExecCost: grossExecCost, isOpen: isOpen, markPrice: markPrice, markValue: markValue, riskValue: riskValue, homeNotional: homeNotional, foreignNotional: foreignNotional, posState: posState, posCost: posCost, posCost2: posCost2, posCross: posCross, posInit: posInit, posComm: posComm, posLoss: posLoss, posMargin: posMargin, posMaint: posMaint, posAllowance: posAllowance, taxableMargin: taxableMargin, initMargin: initMargin, maintMargin: maintMargin, sessionMargin: sessionMargin, targetExcessMargin: targetExcessMargin, varMargin: varMargin, realisedGrossPnl: realisedGrossPnl, realisedTax: realisedTax, realisedPnl: realisedPnl, unrealisedGrossPnl: unrealisedGrossPnl, longBankrupt: longBankrupt, shortBankrupt: shortBankrupt, taxBase: taxBase, indicativeTaxRate: indicativeTaxRate, indicativeTax: indicativeTax, unrealisedTax: unrealisedTax, unrealisedPnl: unrealisedPnl, unrealisedPnlPcnt: unrealisedPnlPcnt, unrealisedRoePcnt: unrealisedRoePcnt, simpleQty: simpleQty, simpleCost: simpleCost, simpleValue: simpleValue, simplePnl: simplePnl, simplePnlPcnt: simplePnlPcnt, avgCostPrice: avgCostPrice, avgEntryPrice: avgEntryPrice, breakEvenPrice: breakEvenPrice, marginCallPrice: marginCallPrice, liquidationPrice: liquidationPrice, bankruptPrice: bankruptPrice, timestamp: timestamp, lastPrice: lastPrice, lastValue: lastValue)
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
                    let account: Int = item["account"] as! Int
                    let symbol: String = item["symbol"] as! String
                    let currency: String = item["currency"] as! String
                    let underlying: String? = item["underlying"] as? String
                    let quoteCurrency: String? = item["quoteCurrency"] as? String
                    let commission: Double? = item["commission"] as? Double
                    let initMarginReq: Double? = item["initMarginReq"] as? Double
                    let maintMarginReq: Double? = item["maintMarginReq"] as? Double
                    let riskLimit: Double? = item["riskLimit"] as? Double
                    let leverage: Double? = item["leverage"] as? Double
                    let crossMargin: Bool? = item["crossMargin"] as? Bool
                    let deleveragePercentile: Double? = item["deleveragePercentile"] as? Double
                    let rebalancedPnl: Double? = item["rebalancedPnl"] as? Double
                    let prevRealisedPnl: Double? = item["prevRealisedPnl"] as? Double
                    let prevUnrealisedPnl: Double? = item["prevUnrealisedPnl"] as? Double
                    let prevClosePrice: Double? = item["prevClosePrice"] as? Double
                    let openingTimestamp: String? = item["openingTimestamp"] as? String
                    let openingQty: Double? = item["openingQty"] as? Double
                    let openingCost: Double? = item["openingCost"] as? Double
                    let openingComm: Double? = item["openingComm"] as? Double
                    let openOrderBuyQty: Double? = item["openOrderBuyQty"] as? Double
                    let openOrderBuyCost: Double? = item["openOrderBuyCost"] as? Double
                    let openOrderBuyPremium: Double? = item["openOrderBuyPremium"] as? Double
                    let openOrderSellQty: Double? = item["openOrderSellQty"] as? Double
                    let openOrderSellCost: Double? = item["openOrderSellCost"] as? Double
                    let openOrderSellPremium: Double? = item["openOrderSellPremium"] as? Double
                    let execBuyQty: Double? = item["execBuyQty"] as? Double
                    let execBuyCost: Double? = item["execBuyCost"] as? Double
                    let execSellQty: Double? = item["execSellQty"] as? Double
                    let execSellCost: Double? = item["execSellCost"] as? Double
                    let execQty: Double? = item["execQty"] as? Double
                    let execCost: Double? = item["execCost"] as? Double
                    let execComm: Double? = item["execComm"] as? Double
                    let currentTimestamp: String? = item["currentTimestamp"] as? String
                    let currentQty: Double? = item["currentQty"] as? Double
                    let currentCost: Double? = item["currentCost"] as? Double
                    let currentComm: Double? = item["currentComm"] as? Double
                    let realisedCost: Double? = item["realisedCost"] as? Double
                    let unrealisedCost: Double? = item["unrealisedCost"] as? Double
                    let grossOpenCost: Double? = item["grossOpenCost"] as? Double
                    let grossOpenPremium: Double? = item["grossOpenPremium"] as? Double
                    let grossExecCost: Double? = item["grossExecCost"] as? Double
                    let isOpen: Bool? = item["isOpen"] as? Bool
                    let markPrice: Double? = item["markPrice"] as? Double
                    let markValue: Double? = item["markValue"] as? Double
                    let riskValue: Double? = item["riskValue"] as? Double
                    let homeNotional: Double? = item["homeNotional"] as? Double
                    let foreignNotional: Double? = item["foreignNotional"] as? Double
                    let posState: String? = item["posState"] as? String
                    let posCost: Double? = item["posCost"] as? Double
                    let posCost2: Double? = item["posCost2"] as? Double
                    let posCross: Double? = item["posCross"] as? Double
                    let posInit: Double? = item["posInit"] as? Double
                    let posComm: Double? = item["posComm"] as? Double
                    let posLoss: Double? = item["posLoss"] as? Double
                    let posMargin: Double? = item["posMargin"] as? Double
                    let posMaint: Double? = item["posMaint"] as? Double
                    let posAllowance: Double? = item["posAllowance"] as? Double
                    let taxableMargin: Double? = item["taxableMargin"] as? Double
                    let initMargin: Double? = item["initMargin"] as? Double
                    let maintMargin: Double? = item["maintMargin"] as? Double
                    let sessionMargin: Double? = item["sessionMargin"] as? Double
                    let targetExcessMargin: Double? = item["targetExcessMargin"] as? Double
                    let varMargin: Double? = item["varMargin"] as? Double
                    let realisedGrossPnl: Double? = item["realisedGrossPnl"] as? Double
                    let realisedTax: Double? = item["realisedTax"] as? Double
                    let realisedPnl: Double? = item["realisedPnl"] as? Double
                    let unrealisedGrossPnl: Double? = item["unrealisedGrossPnl"] as? Double
                    let longBankrupt: Double? = item["longBankrupt"] as? Double
                    let shortBankrupt: Double? = item["shortBankrupt"] as? Double
                    let taxBase: Double? = item["taxBase"] as? Double
                    let indicativeTaxRate: Double? = item["indicativeTaxRate"] as? Double
                    let indicativeTax: Double? = item["indicativeTax"] as? Double
                    let unrealisedTax: Double? = item["unrealisedTax"] as? Double
                    let unrealisedPnl: Double? = item["unrealisedPnl"] as? Double
                    let unrealisedPnlPcnt: Double? = item["unrealisedPnlPcnt"] as? Double
                    let unrealisedRoePcnt: Double? = item["unrealisedRoePcnt"] as? Double
                    let simpleQty: Double? = item["simpleQty"] as? Double
                    let simpleCost: Double? = item["simpleCost"] as? Double
                    let simpleValue: Double? = item["simpleValue"] as? Double
                    let simplePnl: Double? = item["simplePnl"] as? Double
                    let simplePnlPcnt: Double? = item["simplePnlPcnt"] as? Double
                    let avgCostPrice: Double? = item["avgCostPrice"] as? Double
                    let avgEntryPrice: Double? = item["avgEntryPrice"] as? Double
                    let breakEvenPrice: Double? = item["breakEvenPrice"] as? Double
                    let marginCallPrice: Double? = item["marginCallPrice"] as? Double
                    let liquidationPrice: Double? = item["liquidationPrice"] as? Double
                    let bankruptPrice: Double? = item["bankruptPrice"] as? Double
                    let timestamp: String? = item["timestamp"] as? String
                    let lastPrice: Double? = item["lastPrice"] as? Double
                    let lastValue: Double? = item["lastValue"] as? Double
                    let position = Position(account: account, symbol: symbol, currency: currency, underlying: underlying, quoteCurrency: quoteCurrency, commission: commission, initMarginReq: initMarginReq, maintMarginReq: maintMarginReq, riskLimit: riskLimit, leverage: leverage, crossMargin: crossMargin, deleveragePercentile: deleveragePercentile, rebalancedPnl: rebalancedPnl, prevRealisedPnl: prevRealisedPnl, prevUnrealisedPnl: prevUnrealisedPnl, prevClosePrice: prevClosePrice, openingTimestamp: openingTimestamp, openingQty: openingQty, openingCost: openingCost, openingComm: openingComm, openOrderBuyQty: openOrderBuyQty, openOrderBuyCost: openOrderBuyCost, openOrderBuyPremium: openOrderBuyPremium, openOrderSellQty: openOrderSellQty, openOrderSellCost: openOrderSellCost, openOrderSellPremium: openOrderSellPremium, execBuyQty: execBuyQty, execBuyCost: execBuyCost, execSellQty: execSellQty, execSellCost: execSellCost, execQty: execQty, execCost: execCost, execComm: execComm, currentTimestamp: currentTimestamp, currentQty: currentQty, currentCost: currentCost, currentComm: currentComm, realisedCost: realisedCost, unrealisedCost: unrealisedCost, grossOpenCost: grossOpenCost, grossOpenPremium: grossOpenPremium, grossExecCost: grossExecCost, isOpen: isOpen, markPrice: markPrice, markValue: markValue, riskValue: riskValue, homeNotional: homeNotional, foreignNotional: foreignNotional, posState: posState, posCost: posCost, posCost2: posCost2, posCross: posCross, posInit: posInit, posComm: posComm, posLoss: posLoss, posMargin: posMargin, posMaint: posMaint, posAllowance: posAllowance, taxableMargin: taxableMargin, initMargin: initMargin, maintMargin: maintMargin, sessionMargin: sessionMargin, targetExcessMargin: targetExcessMargin, varMargin: varMargin, realisedGrossPnl: realisedGrossPnl, realisedTax: realisedTax, realisedPnl: realisedPnl, unrealisedGrossPnl: unrealisedGrossPnl, longBankrupt: longBankrupt, shortBankrupt: shortBankrupt, taxBase: taxBase, indicativeTaxRate: indicativeTaxRate, indicativeTax: indicativeTax, unrealisedTax: unrealisedTax, unrealisedPnl: unrealisedPnl, unrealisedPnlPcnt: unrealisedPnlPcnt, unrealisedRoePcnt: unrealisedRoePcnt, simpleQty: simpleQty, simpleCost: simpleCost, simpleValue: simpleValue, simplePnl: simplePnl, simplePnlPcnt: simplePnlPcnt, avgCostPrice: avgCostPrice, avgEntryPrice: avgEntryPrice, breakEvenPrice: breakEvenPrice, marginCallPrice: marginCallPrice, liquidationPrice: liquidationPrice, bankruptPrice: bankruptPrice, timestamp: timestamp, lastPrice: lastPrice, lastValue: lastValue)
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
                    let account: Int = item["account"] as! Int
                    let symbol: String = item["symbol"] as! String
                    let currency: String = item["currency"] as! String
                    let underlying: String? = item["underlying"] as? String
                    let quoteCurrency: String? = item["quoteCurrency"] as? String
                    let commission: Double? = item["commission"] as? Double
                    let initMarginReq: Double? = item["initMarginReq"] as? Double
                    let maintMarginReq: Double? = item["maintMarginReq"] as? Double
                    let riskLimit: Double? = item["riskLimit"] as? Double
                    let leverage: Double? = item["leverage"] as? Double
                    let crossMargin: Bool? = item["crossMargin"] as? Bool
                    let deleveragePercentile: Double? = item["deleveragePercentile"] as? Double
                    let rebalancedPnl: Double? = item["rebalancedPnl"] as? Double
                    let prevRealisedPnl: Double? = item["prevRealisedPnl"] as? Double
                    let prevUnrealisedPnl: Double? = item["prevUnrealisedPnl"] as? Double
                    let prevClosePrice: Double? = item["prevClosePrice"] as? Double
                    let openingTimestamp: String? = item["openingTimestamp"] as? String
                    let openingQty: Double? = item["openingQty"] as? Double
                    let openingCost: Double? = item["openingCost"] as? Double
                    let openingComm: Double? = item["openingComm"] as? Double
                    let openOrderBuyQty: Double? = item["openOrderBuyQty"] as? Double
                    let openOrderBuyCost: Double? = item["openOrderBuyCost"] as? Double
                    let openOrderBuyPremium: Double? = item["openOrderBuyPremium"] as? Double
                    let openOrderSellQty: Double? = item["openOrderSellQty"] as? Double
                    let openOrderSellCost: Double? = item["openOrderSellCost"] as? Double
                    let openOrderSellPremium: Double? = item["openOrderSellPremium"] as? Double
                    let execBuyQty: Double? = item["execBuyQty"] as? Double
                    let execBuyCost: Double? = item["execBuyCost"] as? Double
                    let execSellQty: Double? = item["execSellQty"] as? Double
                    let execSellCost: Double? = item["execSellCost"] as? Double
                    let execQty: Double? = item["execQty"] as? Double
                    let execCost: Double? = item["execCost"] as? Double
                    let execComm: Double? = item["execComm"] as? Double
                    let currentTimestamp: String? = item["currentTimestamp"] as? String
                    let currentQty: Double? = item["currentQty"] as? Double
                    let currentCost: Double? = item["currentCost"] as? Double
                    let currentComm: Double? = item["currentComm"] as? Double
                    let realisedCost: Double? = item["realisedCost"] as? Double
                    let unrealisedCost: Double? = item["unrealisedCost"] as? Double
                    let grossOpenCost: Double? = item["grossOpenCost"] as? Double
                    let grossOpenPremium: Double? = item["grossOpenPremium"] as? Double
                    let grossExecCost: Double? = item["grossExecCost"] as? Double
                    let isOpen: Bool? = item["isOpen"] as? Bool
                    let markPrice: Double? = item["markPrice"] as? Double
                    let markValue: Double? = item["markValue"] as? Double
                    let riskValue: Double? = item["riskValue"] as? Double
                    let homeNotional: Double? = item["homeNotional"] as? Double
                    let foreignNotional: Double? = item["foreignNotional"] as? Double
                    let posState: String? = item["posState"] as? String
                    let posCost: Double? = item["posCost"] as? Double
                    let posCost2: Double? = item["posCost2"] as? Double
                    let posCross: Double? = item["posCross"] as? Double
                    let posInit: Double? = item["posInit"] as? Double
                    let posComm: Double? = item["posComm"] as? Double
                    let posLoss: Double? = item["posLoss"] as? Double
                    let posMargin: Double? = item["posMargin"] as? Double
                    let posMaint: Double? = item["posMaint"] as? Double
                    let posAllowance: Double? = item["posAllowance"] as? Double
                    let taxableMargin: Double? = item["taxableMargin"] as? Double
                    let initMargin: Double? = item["initMargin"] as? Double
                    let maintMargin: Double? = item["maintMargin"] as? Double
                    let sessionMargin: Double? = item["sessionMargin"] as? Double
                    let targetExcessMargin: Double? = item["targetExcessMargin"] as? Double
                    let varMargin: Double? = item["varMargin"] as? Double
                    let realisedGrossPnl: Double? = item["realisedGrossPnl"] as? Double
                    let realisedTax: Double? = item["realisedTax"] as? Double
                    let realisedPnl: Double? = item["realisedPnl"] as? Double
                    let unrealisedGrossPnl: Double? = item["unrealisedGrossPnl"] as? Double
                    let longBankrupt: Double? = item["longBankrupt"] as? Double
                    let shortBankrupt: Double? = item["shortBankrupt"] as? Double
                    let taxBase: Double? = item["taxBase"] as? Double
                    let indicativeTaxRate: Double? = item["indicativeTaxRate"] as? Double
                    let indicativeTax: Double? = item["indicativeTax"] as? Double
                    let unrealisedTax: Double? = item["unrealisedTax"] as? Double
                    let unrealisedPnl: Double? = item["unrealisedPnl"] as? Double
                    let unrealisedPnlPcnt: Double? = item["unrealisedPnlPcnt"] as? Double
                    let unrealisedRoePcnt: Double? = item["unrealisedRoePcnt"] as? Double
                    let simpleQty: Double? = item["simpleQty"] as? Double
                    let simpleCost: Double? = item["simpleCost"] as? Double
                    let simpleValue: Double? = item["simpleValue"] as? Double
                    let simplePnl: Double? = item["simplePnl"] as? Double
                    let simplePnlPcnt: Double? = item["simplePnlPcnt"] as? Double
                    let avgCostPrice: Double? = item["avgCostPrice"] as? Double
                    let avgEntryPrice: Double? = item["avgEntryPrice"] as? Double
                    let breakEvenPrice: Double? = item["breakEvenPrice"] as? Double
                    let marginCallPrice: Double? = item["marginCallPrice"] as? Double
                    let liquidationPrice: Double? = item["liquidationPrice"] as? Double
                    let bankruptPrice: Double? = item["bankruptPrice"] as? Double
                    let timestamp: String? = item["timestamp"] as? String
                    let lastPrice: Double? = item["lastPrice"] as? Double
                    let lastValue: Double? = item["lastValue"] as? Double
                    let position = Position(account: account, symbol: symbol, currency: currency, underlying: underlying, quoteCurrency: quoteCurrency, commission: commission, initMarginReq: initMarginReq, maintMarginReq: maintMarginReq, riskLimit: riskLimit, leverage: leverage, crossMargin: crossMargin, deleveragePercentile: deleveragePercentile, rebalancedPnl: rebalancedPnl, prevRealisedPnl: prevRealisedPnl, prevUnrealisedPnl: prevUnrealisedPnl, prevClosePrice: prevClosePrice, openingTimestamp: openingTimestamp, openingQty: openingQty, openingCost: openingCost, openingComm: openingComm, openOrderBuyQty: openOrderBuyQty, openOrderBuyCost: openOrderBuyCost, openOrderBuyPremium: openOrderBuyPremium, openOrderSellQty: openOrderSellQty, openOrderSellCost: openOrderSellCost, openOrderSellPremium: openOrderSellPremium, execBuyQty: execBuyQty, execBuyCost: execBuyCost, execSellQty: execSellQty, execSellCost: execSellCost, execQty: execQty, execCost: execCost, execComm: execComm, currentTimestamp: currentTimestamp, currentQty: currentQty, currentCost: currentCost, currentComm: currentComm, realisedCost: realisedCost, unrealisedCost: unrealisedCost, grossOpenCost: grossOpenCost, grossOpenPremium: grossOpenPremium, grossExecCost: grossExecCost, isOpen: isOpen, markPrice: markPrice, markValue: markValue, riskValue: riskValue, homeNotional: homeNotional, foreignNotional: foreignNotional, posState: posState, posCost: posCost, posCost2: posCost2, posCross: posCross, posInit: posInit, posComm: posComm, posLoss: posLoss, posMargin: posMargin, posMaint: posMaint, posAllowance: posAllowance, taxableMargin: taxableMargin, initMargin: initMargin, maintMargin: maintMargin, sessionMargin: sessionMargin, targetExcessMargin: targetExcessMargin, varMargin: varMargin, realisedGrossPnl: realisedGrossPnl, realisedTax: realisedTax, realisedPnl: realisedPnl, unrealisedGrossPnl: unrealisedGrossPnl, longBankrupt: longBankrupt, shortBankrupt: shortBankrupt, taxBase: taxBase, indicativeTaxRate: indicativeTaxRate, indicativeTax: indicativeTax, unrealisedTax: unrealisedTax, unrealisedPnl: unrealisedPnl, unrealisedPnlPcnt: unrealisedPnlPcnt, unrealisedRoePcnt: unrealisedRoePcnt, simpleQty: simpleQty, simpleCost: simpleCost, simpleValue: simpleValue, simplePnl: simplePnl, simplePnlPcnt: simplePnlPcnt, avgCostPrice: avgCostPrice, avgEntryPrice: avgEntryPrice, breakEvenPrice: breakEvenPrice, marginCallPrice: marginCallPrice, liquidationPrice: liquidationPrice, bankruptPrice: bankruptPrice, timestamp: timestamp, lastPrice: lastPrice, lastValue: lastValue)
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
}
