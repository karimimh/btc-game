//
//  Instrument.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Instrument {
    //MARK: Constants
    static let endpoint = "/instrument"
    static let endpoint_active = "/instrument/active"
    static let endpoint_activeAndIndices = "/instrument/activeAndIndices"
//    static let endpoint_activeIntervals = "/instrument/activeIntervals"
//    static let endpoint_compositeIndex = "/instrument/compositeIndex"
    static let endpoint_indices = "/instrument/indices"
    
    
    //MARK: Properties
    var symbol: String
    var rootSymbol: String?
    var state: String?
    var typ: String?
    var listing: String?
    var front: String?
    var expiry: String?
    var settle: String?
    var relistInterval: String?
    var inverseLeg: String?
    var sellLeg: String?
    var buyLeg: String?
    var optionStrikePcnt: Double?
    var optionStrikeRound: Double?
    var optionStrikePrice: Double?
    var optionMultiplier: Double?
    var positionCurrency: String?
    var underlying: String?
    var quoteCurrency: String?
    var underlyingSymbol: String?
    var reference: String?
    var referenceSymbol: String?
    var calcInterval: String?
    var publishInterval: String?
    var publishTime: String?
    var maxOrderQty: Double?
    var maxPrice: Double?
    var lotSize: Double?
    var tickSize: Double?
    var multiplier: Double?
    var settlCurrency: String?
    var underlyingToPositionMultiplier: Double?
    var underlyingToSettleMultiplier: Double?
    var quoteToSettleMultiplier: Double?
    var isQuanto: Bool?
    var isInverse: Bool?
    var initMargin: Double?
    var maintMargin: Double?
    var riskLimit: Double?
    var riskStep: Double?
    var limit: Double?
    var capped: Bool?
    var taxed: Bool?
    var deleverage: Bool?
    var makerFee: Double?
    var takerFee: Double?
    var settlementFee: Double?
    var insuranceFee: Double?
    var fundingBaseSymbol: String?
    var fundingQuoteSymbol: String?
    var fundingPremiumSymbol: String?
    var fundingTimestamp: String?
    var fundingInterval: String?
    var fundingRate: Double?
    var indicativeFundingRate: Double?
    var rebalanceTimestamp: String?
    var rebalanceInterval: String?
    var openingTimestamp: String?
    var closingTimestamp: String?
    var sessionInterval: String?
    var prevClosePrice: Double?
    var limitDownPrice: Double?
    var limitUpPrice: Double?
    var bankruptLimitDownPrice: Double?
    var bankruptLimitUpPrice: Double?
    var prevTotalVolume: Double?
    var totalVolume: Double?
    var volume: Double?
    var volume24h: Double?
    var prevTotalTurnover: Double?
    var totalTurnover: Double?
    var turnover: Double?
    var turnover24h: Double?
    var homeNotional24h: Double?
    var foreignNotional24h: Double?
    var prevPrice24h: Double?
    var vwap: Double?
    var highPrice: Double?
    var lowPrice: Double?
    var lastPrice: Double?
    var lastPriceProtected: Double?
    var lastTickDirection: String?
    var lastChangePcnt: Double?
    var bidPrice: Double?
    var midPrice: Double?
    var askPrice: Double?
    var impactBidPrice: Double?
    var impactMidPrice: Double?
    var impactAskPrice: Double?
    var hasLiquidity: Bool?
    var openInterest: Double?
    var openValue: Double?
    var fairMethod: String?
    var fairBasisRate: Double?
    var fairBasis: Double?
    var fairPrice: Double?
    var markMethod: String?
    var markPrice: Double?
    var indicativeTaxRate: Double?
    var indicativeSettlePrice: Double?
    var optionUnderlyingPrice: Double?
    var settledPrice: Double?
    var timestamp: String?
    
    
    
    
    init(item: [String: Any]) {
        symbol = item["symbol"] as! String
        rootSymbol = item["rootSymbol"] as? String
        state = item["state"] as? String
        typ = item["typ"] as? String
        listing = item["listing"] as? String
        front = item["front"] as? String
        expiry = item["expiry"] as? String
        settle = item["settle"] as? String
        relistInterval = item["relistInterval"] as? String
        inverseLeg = item["inverseLeg"] as? String
        sellLeg = item["sellLeg"] as? String
        buyLeg = item["buyLeg"] as? String
        optionStrikePcnt = item["optionStrikePcnt"] as? Double
        optionStrikeRound = item["optionStrikeRound"] as? Double
        optionStrikePrice = item["optionStrikePrice"] as? Double
        optionMultiplier = item["optionMultiplier"] as? Double
        positionCurrency = item["positionCurrency"] as? String
        underlying = item["underlying"] as? String
        quoteCurrency = item["quoteCurrency"] as? String
        underlyingSymbol = item["underlyingSymbol"] as? String
        reference = item["reference"] as? String
        referenceSymbol = item["referenceSymbol"] as? String
        calcInterval = item["calcInterval"] as? String
        publishInterval = item["publishInterval"] as? String
        publishTime = item["publishTime"] as? String
        maxOrderQty = item["maxOrderQty"] as? Double
        maxPrice = item["maxPrice"] as? Double
        lotSize = item["lotSize"] as? Double
        tickSize = item["tickSize"] as? Double
        multiplier = item["multiplier"] as? Double
        settlCurrency = item["settlCurrency"] as? String
        underlyingToPositionMultiplier = item["underlyingToPositionMultiplier"] as? Double
        underlyingToSettleMultiplier = item["underlyingToSettleMultiplier"] as? Double
        quoteToSettleMultiplier = item["quoteToSettleMultiplier"] as? Double
        isQuanto = item["isQuanto"] as? Bool
        isInverse = item["isInverse"] as? Bool
        initMargin = item["initMargin"] as? Double
        maintMargin = item["maintMargin"] as? Double
        riskLimit = item["riskLimit"] as? Double
        riskStep = item["riskStep"] as? Double
        limit = item["limit"] as? Double
        capped = item["capped"] as? Bool
        taxed = item["taxed"] as? Bool
        deleverage = item["deleverage"] as? Bool
        makerFee = item["makerFee"] as? Double
        takerFee = item["takerFee"] as? Double
        settlementFee = item["settlementFee"] as? Double
        insuranceFee = item["insuranceFee"] as? Double
        fundingBaseSymbol = item["fundingBaseSymbol"] as? String
        fundingQuoteSymbol = item["fundingQuoteSymbol"] as? String
        fundingPremiumSymbol = item["fundingPremiumSymbol"] as? String
        fundingTimestamp = item["fundingTimestamp"] as? String
        fundingInterval = item["fundingInterval"] as? String
        fundingRate = item["fundingRate"] as? Double
        indicativeFundingRate = item["indicativeFundingRate"] as? Double
        rebalanceTimestamp = item["rebalanceTimestamp"] as? String
        rebalanceInterval = item["rebalanceInterval"] as? String
        openingTimestamp = item["openingTimestamp"] as? String
        closingTimestamp = item["closingTimestamp"] as? String
        sessionInterval = item["sessionInterval"] as? String
        prevClosePrice = item["prevClosePrice"] as? Double
        limitDownPrice = item["limitDownPrice"] as? Double
        limitUpPrice = item["limitUpPrice"] as? Double
        bankruptLimitDownPrice = item["bankruptLimitDownPrice"] as? Double
        bankruptLimitUpPrice = item["bankruptLimitUpPrice"] as? Double
        prevTotalVolume = item["prevTotalVolume"] as? Double
        totalVolume = item["totalVolume"] as? Double
        volume = item["volume"] as? Double
        volume24h = item["volume24h"] as? Double
        prevTotalTurnover = item["prevTotalTurnover"] as? Double
        totalTurnover = item["totalTurnover"] as? Double
        turnover = item["turnover"] as? Double
        turnover24h = item["turnover24h"] as? Double
        homeNotional24h = item["homeNotional24h"] as? Double
        foreignNotional24h = item["foreignNotional24h"] as? Double
        prevPrice24h = item["prevPrice24h"] as? Double
        vwap = item["vwap"] as? Double
        highPrice = item["highPrice"] as? Double
        lowPrice = item["lowPrice"] as? Double
        lastPrice = item["lastPrice"] as? Double
        lastPriceProtected = item["lastPriceProtected"] as? Double
        lastTickDirection = item["lastTickDirection"] as? String
        lastChangePcnt = item["lastChangePcnt"] as? Double
        bidPrice = item["bidPrice"] as? Double
        midPrice = item["midPrice"] as? Double
        askPrice = item["askPrice"] as? Double
        impactBidPrice = item["impactBidPrice"] as? Double
        impactMidPrice = item["impactMidPrice"] as? Double
        impactAskPrice = item["impactAskPrice"] as? Double
        hasLiquidity = item["hasLiquidity"] as? Bool
        openInterest = item["openInterest"] as? Double
        openValue = item["openValue"] as? Double
        fairMethod = item["fairMethod"] as? String
        fairBasisRate = item["fairBasisRate"] as? Double
        fairBasis = item["fairBasis"] as? Double
        fairPrice = item["fairPrice"] as? Double
        markMethod = item["markMethod"] as? String
        markPrice = item["markPrice"] as? Double
        indicativeTaxRate = item["indicativeTaxRate"] as? Double
        indicativeSettlePrice = item["indicativeSettlePrice"] as? Double
        optionUnderlyingPrice = item["optionUnderlyingPrice"] as? Double
        settledPrice = item["settledPrice"] as? Double
        timestamp = item["timestamp"] as? String
    }
    
    
    //MARK: Types
    struct Columns {
        static let symbol = "symbol"
        static let rootSymbol = "rootSymbol"
        static let state = "state"
        static let typ = "typ"
        static let listing = "listing"
        static let front = "front"
        static let expiry = "expiry"
        static let settle = "settle"
        static let relistInterval = "relistInterval"
        static let inverseLeg = "inverseLeg"
        static let sellLeg = "sellLeg"
        static let buyLeg = "buyLeg"
        static let optionStrikePcnt = "optionStrikePcnt"
        static let optionStrikeRound = "optionStrikeRound"
        static let optionStrikePrice = "optionStrikePrice"
        static let optionMultiplier = "optionMultiplier"
        static let positionCurrency = "positionCurrency"
        static let underlying = "underlying"
        static let quoteCurrency = "quoteCurrency"
        static let underlyingSymbol = "underlyingSymbol"
        static let reference = "reference"
        static let referenceSymbol = "referenceSymbol"
        static let calcInterval = "calcInterval"
        static let publishInterval = "publishInterval"
        static let publishTime = "publishTime"
        static let maxOrderQty = "maxOrderQty"
        static let maxPrice = "maxPrice"
        static let lotSize = "lotSize"
        static let tickSize = "tickSize"
        static let multiplier = "multiplier"
        static let settlCurrency = "settlCurrency"
        static let underlyingToPositionMultiplier = "underlyingToPositionMultiplier"
        static let underlyingToSettleMultiplier = "underlyingToSettleMultiplier"
        static let quoteToSettleMultiplier = "quoteToSettleMultiplier"
        static let isQuanto = "isQuanto"
        static let isInverse = "isInverse"
        static let initMargin = "initMargin"
        static let maintMargin = "maintMargin"
        static let riskLimit = "riskLimit"
        static let riskStep = "riskStep"
        static let limit = "limit"
        static let capped = "capped"
        static let taxed = "taxed"
        static let deleverage = "deleverage"
        static let makerFee = "makerFee"
        static let takerFee = "takerFee"
        static let settlementFee = "settlementFee"
        static let insuranceFee = "insuranceFee"
        static let fundingBaseSymbol = "fundingBaseSymbol"
        static let fundingQuoteSymbol = "fundingQuoteSymbol"
        static let fundingPremiumSymbol = "fundingPremiumSymbol"
        static let fundingTimestamp = "fundingTimestamp"
        static let fundingInterval = "fundingInterval"
        static let fundingRate = "fundingRate"
        static let indicativeFundingRate = "indicativeFundingRate"
        static let rebalanceTimestamp = "rebalanceTimestamp"
        static let rebalanceInterval = "rebalanceInterval"
        static let openingTimestamp = "openingTimestamp"
        static let closingTimestamp = "closingTimestamp"
        static let sessionInterval = "sessionInterval"
        static let prevClosePrice = "prevClosePrice"
        static let limitDownPrice = "limitDownPrice"
        static let limitUpPrice = "limitUpPrice"
        static let bankruptLimitDownPrice = "bankruptLimitDownPrice"
        static let bankruptLimitUpPrice = "bankruptLimitUpPrice"
        static let prevTotalVolume = "prevTotalVolume"
        static let totalVolume = "totalVolume"
        static let volume = "volume"
        static let volume24h = "volume24h"
        static let prevTotalTurnover = "prevTotalTurnover"
        static let totalTurnover = "totalTurnover"
        static let turnover = "turnover"
        static let turnover24h = "turnover24h"
        static let homeNotional24h = "homeNotional24h"
        static let foreignNotional24h = "foreignNotional24h"
        static let prevPrice24h = "prevPrice24h"
        static let vwap = "vwap"
        static let highPrice = "highPrice"
        static let lowPrice = "lowPrice"
        static let lastPrice = "lastPrice"
        static let lastPriceProtected = "lastPriceProtected"
        static let lastTickDirection = "lastTickDirection"
        static let lastChangePcnt = "lastChangePcnt"
        static let bidPrice = "bidPrice"
        static let midPrice = "midPrice"
        static let askPrice = "askPrice"
        static let impactBidPrice = "impactBidPrice"
        static let impactMidPrice = "impactMidPrice"
        static let impactAskPrice = "impactAskPrice"
        static let hasLiquidity = "hasLiquidity"
        static let openInterest = "openInterest"
        static let openValue = "openValue"
        static let fairMethod = "fairMethod"
        static let fairBasisRate = "fairBasisRate"
        static let fairBasis = "fairBasis"
        static let fairPrice = "fairPrice"
        static let markMethod = "markMethod"
        static let markPrice = "markPrice"
        static let indicativeTaxRate = "indicativeTaxRate"
        static let indicativeSettlePrice = "indicativeSettlePrice"
        static let optionUnderlyingPrice = "optionUnderlyingPrice"
        static let settledPrice = "settledPrice"
        static let timestamp = "timestamp"
        
    }
    
    //MARK: static Methods
    static func GET(symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Instrument]?, URLResponse?, Error?) -> Void) {
        _GET(symbol: symbol, count: count, reverse: reverse, start: start, startTime: startTime, endTime: endTime, filter: filter, columns: columns, completion: completion)
    }
    
    static func GET_Active(symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Instrument]?, URLResponse?, Error?) -> Void) {
        _GET(ENDPOINT: endpoint_active, symbol: symbol, count: count, reverse: reverse, start: start, startTime: startTime, endTime: endTime, filter: filter, columns: columns, completion: completion)
    }
    
    static func GET_Indices(symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Instrument]?, URLResponse?, Error?) -> Void) {
        _GET(ENDPOINT: endpoint_indices, symbol: symbol, count: count, reverse: reverse, start: start, startTime: startTime, endTime: endTime, filter: filter, columns: columns, completion: completion)
    }
    
    static func GET_ActiveAndIndices(symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Instrument]?, URLResponse?, Error?) -> Void) {
        _GET(ENDPOINT: endpoint_activeAndIndices, symbol: symbol, count: count, reverse: reverse, start: start, startTime: startTime, endTime: endTime, filter: filter, columns: columns, completion: completion)
    }
    
    private static func _GET(ENDPOINT: String = Instrument.endpoint, symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Instrument]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + ENDPOINT
        
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
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 429 {
                    if let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryAfter)!) {
                            Instrument._GET(ENDPOINT: ENDPOINT, symbol: symbol, count: count, reverse: reverse, start: start, startTime: startTime, endTime: endTime, filter: filter, columns: columns, completion: completion)
                        }
                        return
                    }
                } else if httpResponse.statusCode != 200 {
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
                    var result = [Instrument]()
                    for item in json {
                        let instrument = Instrument(item: item)
                        result.append(instrument)
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
    
    
    
    class CompositeIndex {
        //MARK: Constants
        static let endpoint = "/compositeIndex"
        
        //MARK: Properties
        var timestamp: String
        var symbol: String?
        var indexSymbol: String?
        var reference: String?
        var lastPrice: String?
        var weight: String?
        var logged: String?
        
        
        //MARK: Initialization
        private init(timestamp: String, symbol: String?, indexSymbol: String?, reference: String?, lastPrice: String?, weight: String?, logged: String?) {
            self.timestamp = timestamp
            self.symbol = symbol
            self.indexSymbol = indexSymbol
            self.reference = reference
            self.lastPrice = lastPrice
            self.weight = weight
            self.logged = logged
        }
        
        //MARK: Types
        struct Columns {
            static let symbols = "symbols"
            static let timestamp = "timestamp"
            static let indexSymbol = "indexSymbol"
            static let reference = "reference"
            static let lastPrice = "lastPrice"
            static let weight = "weight"
            static let logged = "logged"
        }
        
        //MARK: Static Methods
        static func GET(symbol: String = ".XBT", count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([CompositeIndex]?, URLResponse?, Error?) -> Void) {
            let scheme = "https"
            let host = "www.bitmex.com"
            let path = "/api/v1" + endpoint
            
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = path
            
            var queryItems = [URLQueryItem]()
            
            queryItems.append(URLQueryItem(name: "symbol", value: symbol))
            
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
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completion(nil, response, error)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 429 {
                        if let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After") {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryAfter)!) {
                                CompositeIndex.GET(symbol: symbol, count: count, reverse: reverse, start: start, startTime: startTime, endTime: endpoint, filter: filter, columns: columns, completion: completion)
                            }
                            return
                        }
                    } else if httpResponse.statusCode != 200 {
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
                        var result = [CompositeIndex]()
                        for item in json {
                            let timestamp: String = item["timestamp"] as! String
                            let symbol: String? = item["symbol"] as? String
                            let indexSymbol: String? = item["indexSymbol"] as? String
                            let reference: String? = item["reference"] as? String
                            let lastPrice: String? = item["lastPrice"] as? String
                            let weight: String? = item["weight"] as? String
                            let logged: String? = item["logged"] as? String
                            let ci = CompositeIndex(timestamp: timestamp, symbol: symbol, indexSymbol: indexSymbol, reference: reference, lastPrice: lastPrice, weight: weight, logged: logged)
                            result.append(ci)
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
    
    
    class ActiveInterval {
        
        //MARK: Constants
        static let endpoint = "/activeIntervals"
        
        //MARK: Properties
        var intervals: [String]
        var symbols: [String]
        
        //MARK: Initialization
        private init(intervals: [String], symbols: [String]) {
            self.intervals = intervals
            self.symbols = symbols
        }
        
        //MARK: Types
        struct Columns {
            static let intervals = "intervals"
            static let symbols = "symbols"
        }
        
        //MARK: Static Methods
        static func GET(completion: @escaping ([ActiveInterval]?, URLResponse?, Error?) -> Void) {
            let scheme = "https"
            let host = "www.bitmex.com"
            let path = "/api/v1" + endpoint
            
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = path
            
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
                        var result = [ActiveInterval]()
                        for item in json {
                            let symbols: [String] = item["symbols"] as! [String]
                            let intervals: [String] = item["intervals"] as! [String]
                            
                            let interval = ActiveInterval(intervals: intervals, symbols: symbols)
                            result.append(interval)
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
    
    
    
}
