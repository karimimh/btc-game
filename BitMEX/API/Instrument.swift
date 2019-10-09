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
    
    
    
    
    private init(symbol: String, rootSymbol: String?, state: String?, typ: String?, listing: String?, front: String?, expiry: String?, settle: String?, relistInterval: String?, inverseLeg: String?, sellLeg: String?, buyLeg: String?, optionStrikePcnt: Double?, optionStrikeRound: Double?, optionStrikePrice: Double?, optionMultiplier: Double?, positionCurrency: String?, underlying: String?, quoteCurrency: String?, underlyingSymbol: String?, reference: String?, referenceSymbol: String?, calcInterval: String?, publishInterval: String?, publishTime: String?, maxOrderQty: Double?, maxPrice: Double?, lotSize: Double?, tickSize: Double?, multiplier: Double?, settlCurrency: String?, underlyingToPositionMultiplier: Double?, underlyingToSettleMultiplier: Double?, quoteToSettleMultiplier: Double?, isQuanto: Bool?, isInverse: Bool?, initMargin: Double?, maintMargin: Double?, riskLimit: Double?, riskStep: Double?, limit: Double?, capped: Bool?, taxed: Bool?, deleverage: Bool?, makerFee: Double?, takerFee: Double?, settlementFee: Double?, insuranceFee: Double?, fundingBaseSymbol: String?, fundingQuoteSymbol: String?, fundingPremiumSymbol: String?, fundingTimestamp: String?, fundingInterval: String?, fundingRate: Double?, indicativeFundingRate: Double?, rebalanceTimestamp: String?, rebalanceInterval: String?, openingTimestamp: String?, closingTimestamp: String?, sessionInterval: String?, prevClosePrice: Double?, limitDownPrice: Double?, limitUpPrice: Double?, bankruptLimitDownPrice: Double?, bankruptLimitUpPrice: Double?, prevTotalVolume: Double?, totalVolume: Double?, volume: Double?, volume24h: Double?, prevTotalTurnover: Double?, totalTurnover: Double?, turnover: Double?, turnover24h: Double?, homeNotional24h: Double?, foreignNotional24h: Double?, prevPrice24h: Double?, vwap: Double?, highPrice: Double?, lowPrice: Double?, lastPrice: Double?, lastPriceProtected: Double?, lastTickDirection: String?, lastChangePcnt: Double?, bidPrice: Double?, midPrice: Double?, askPrice: Double?, impactBidPrice: Double?, impactMidPrice: Double?, impactAskPrice: Double?, hasLiquidity: Bool?, openInterest: Double?, openValue: Double?, fairMethod: String?, fairBasisRate: Double?, fairBasis: Double?, fairPrice: Double?, markMethod: String?, markPrice: Double?, indicativeTaxRate: Double?, indicativeSettlePrice: Double?, optionUnderlyingPrice: Double?, settledPrice: Double?, timestamp: String?) {
        self.symbol = symbol
        self.rootSymbol = rootSymbol
        self.state = state
        self.typ = typ
        self.listing = listing
        self.front = front
        self.expiry = expiry
        self.settle = settle
        self.relistInterval = relistInterval
        self.inverseLeg = inverseLeg
        self.sellLeg = sellLeg
        self.buyLeg = buyLeg
        self.optionStrikePcnt = optionStrikePcnt
        self.optionStrikeRound = optionStrikeRound
        self.optionStrikePrice = optionStrikePrice
        self.optionMultiplier = optionMultiplier
        self.positionCurrency = positionCurrency
        self.underlying = underlying
        self.quoteCurrency = quoteCurrency
        self.underlyingSymbol = underlyingSymbol
        self.reference = reference
        self.referenceSymbol = referenceSymbol
        self.calcInterval = calcInterval
        self.publishInterval = publishInterval
        self.publishTime = publishTime
        self.maxOrderQty = maxOrderQty
        self.maxPrice = maxPrice
        self.lotSize = lotSize
        self.tickSize = tickSize
        self.multiplier = multiplier
        self.settlCurrency = settlCurrency
        self.underlyingToPositionMultiplier = underlyingToPositionMultiplier
        self.underlyingToSettleMultiplier = underlyingToSettleMultiplier
        self.quoteToSettleMultiplier = quoteToSettleMultiplier
        self.isQuanto = isQuanto
        self.isInverse = isInverse
        self.initMargin = initMargin
        self.maintMargin = maintMargin
        self.riskLimit = riskLimit
        self.riskStep = riskStep
        self.limit = limit
        self.capped = capped
        self.taxed = taxed
        self.deleverage = deleverage
        self.makerFee = makerFee
        self.takerFee = takerFee
        self.settlementFee = settlementFee
        self.insuranceFee = insuranceFee
        self.fundingBaseSymbol = fundingBaseSymbol
        self.fundingQuoteSymbol = fundingQuoteSymbol
        self.fundingPremiumSymbol = fundingPremiumSymbol
        self.fundingTimestamp = fundingTimestamp
        self.fundingInterval = fundingInterval
        self.fundingRate = fundingRate
        self.indicativeFundingRate = indicativeFundingRate
        self.rebalanceTimestamp = rebalanceTimestamp
        self.rebalanceInterval = rebalanceInterval
        self.openingTimestamp = openingTimestamp
        self.closingTimestamp = closingTimestamp
        self.sessionInterval = sessionInterval
        self.prevClosePrice = prevClosePrice
        self.limitDownPrice = limitDownPrice
        self.limitUpPrice = limitUpPrice
        self.bankruptLimitDownPrice = bankruptLimitDownPrice
        self.bankruptLimitUpPrice = bankruptLimitUpPrice
        self.prevTotalVolume = prevTotalVolume
        self.totalVolume = totalVolume
        self.volume = volume
        self.volume24h = volume24h
        self.prevTotalTurnover = prevTotalTurnover
        self.totalTurnover = totalTurnover
        self.turnover = turnover
        self.turnover24h = turnover24h
        self.homeNotional24h = homeNotional24h
        self.foreignNotional24h = foreignNotional24h
        self.prevPrice24h = prevPrice24h
        self.vwap = vwap
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.lastPrice = lastPrice
        self.lastPriceProtected = lastPriceProtected
        self.lastTickDirection = lastTickDirection
        self.lastChangePcnt = lastChangePcnt
        self.bidPrice = bidPrice
        self.midPrice = midPrice
        self.askPrice = askPrice
        self.impactBidPrice = impactBidPrice
        self.impactMidPrice = impactMidPrice
        self.impactAskPrice = impactAskPrice
        self.hasLiquidity = hasLiquidity
        self.openInterest = openInterest
        self.openValue = openValue
        self.fairMethod = fairMethod
        self.fairBasisRate = fairBasisRate
        self.fairBasis = fairBasis
        self.fairPrice = fairPrice
        self.markMethod = markMethod
        self.markPrice = markPrice
        self.indicativeTaxRate = indicativeTaxRate
        self.indicativeSettlePrice = indicativeSettlePrice
        self.optionUnderlyingPrice = optionUnderlyingPrice
        self.settledPrice = settledPrice
        self.timestamp = timestamp
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
                    var result = [Instrument]()
                    for item in json {
                        let symbol: String = item["symbol"] as! String
                        let rootSymbol: String? = item["rootSymbol"] as? String
                        let state: String? = item["state"] as? String
                        let typ: String? = item["typ"] as? String
                        let listing: String? = item["listing"] as? String
                        let front: String? = item["front"] as? String
                        let expiry: String? = item["expiry"] as? String
                        let settle: String? = item["settle"] as? String
                        let relistInterval: String? = item["relistInterval"] as? String
                        let inverseLeg: String? = item["inverseLeg"] as? String
                        let sellLeg: String? = item["sellLeg"] as? String
                        let buyLeg: String? = item["buyLeg"] as? String
                        let optionStrikePcnt: Double? = item["optionStrikePcnt"] as? Double
                        let optionStrikeRound: Double? = item["optionStrikeRound"] as? Double
                        let optionStrikePrice: Double? = item["optionStrikePrice"] as? Double
                        let optionMultiplier: Double? = item["optionMultiplier"] as? Double
                        let positionCurrency: String? = item["positionCurrency"] as? String
                        let underlying: String? = item["underlying"] as? String
                        let quoteCurrency: String? = item["quoteCurrency"] as? String
                        let underlyingSymbol: String? = item["underlyingSymbol"] as? String
                        let reference: String? = item["reference"] as? String
                        let referenceSymbol: String? = item["referenceSymbol"] as? String
                        let calcInterval: String? = item["calcInterval"] as? String
                        let publishInterval: String? = item["publishInterval"] as? String
                        let publishTime: String? = item["publishTime"] as? String
                        let maxOrderQty: Double? = item["maxOrderQty"] as? Double
                        let maxPrice: Double? = item["maxPrice"] as? Double
                        let lotSize: Double? = item["lotSize"] as? Double
                        let tickSize: Double? = item["tickSize"] as? Double
                        let multiplier: Double? = item["multiplier"] as? Double
                        let settlCurrency: String? = item["settlCurrency"] as? String
                        let underlyingToPositionMultiplier: Double? = item["underlyingToPositionMultiplier"] as? Double
                        let underlyingToSettleMultiplier: Double? = item["underlyingToSettleMultiplier"] as? Double
                        let quoteToSettleMultiplier: Double? = item["quoteToSettleMultiplier"] as? Double
                        let isQuanto: Bool? = item["isQuanto"] as? Bool
                        let isInverse: Bool? = item["isInverse"] as? Bool
                        let initMargin: Double? = item["initMargin"] as? Double
                        let maintMargin: Double? = item["maintMargin"] as? Double
                        let riskLimit: Double? = item["riskLimit"] as? Double
                        let riskStep: Double? = item["riskStep"] as? Double
                        let limit: Double? = item["limit"] as? Double
                        let capped: Bool? = item["capped"] as? Bool
                        let taxed: Bool? = item["taxed"] as? Bool
                        let deleverage: Bool? = item["deleverage"] as? Bool
                        let makerFee: Double? = item["makerFee"] as? Double
                        let takerFee: Double? = item["takerFee"] as? Double
                        let settlementFee: Double? = item["settlementFee"] as? Double
                        let insuranceFee: Double? = item["insuranceFee"] as? Double
                        let fundingBaseSymbol: String? = item["fundingBaseSymbol"] as? String
                        let fundingQuoteSymbol: String? = item["fundingQuoteSymbol"] as? String
                        let fundingPremiumSymbol: String? = item["fundingPremiumSymbol"] as? String
                        let fundingTimestamp: String? = item["fundingTimestamp"] as? String
                        let fundingInterval: String? = item["fundingInterval"] as? String
                        let fundingRate: Double? = item["fundingRate"] as? Double
                        let indicativeFundingRate: Double? = item["indicativeFundingRate"] as? Double
                        let rebalanceTimestamp: String? = item["rebalanceTimestamp"] as? String
                        let rebalanceInterval: String? = item["rebalanceInterval"] as? String
                        let openingTimestamp: String? = item["openingTimestamp"] as? String
                        let closingTimestamp: String? = item["closingTimestamp"] as? String
                        let sessionInterval: String? = item["sessionInterval"] as? String
                        let prevClosePrice: Double? = item["prevClosePrice"] as? Double
                        let limitDownPrice: Double? = item["limitDownPrice"] as? Double
                        let limitUpPrice: Double? = item["limitUpPrice"] as? Double
                        let bankruptLimitDownPrice: Double? = item["bankruptLimitDownPrice"] as? Double
                        let bankruptLimitUpPrice: Double? = item["bankruptLimitUpPrice"] as? Double
                        let prevTotalVolume: Double? = item["prevTotalVolume"] as? Double
                        let totalVolume: Double? = item["totalVolume"] as? Double
                        let volume: Double? = item["volume"] as? Double
                        let volume24h: Double? = item["volume24h"] as? Double
                        let prevTotalTurnover: Double? = item["prevTotalTurnover"] as? Double
                        let totalTurnover: Double? = item["totalTurnover"] as? Double
                        let turnover: Double? = item["turnover"] as? Double
                        let turnover24h: Double? = item["turnover24h"] as? Double
                        let homeNotional24h: Double? = item["homeNotional24h"] as? Double
                        let foreignNotional24h: Double? = item["foreignNotional24h"] as? Double
                        let prevPrice24h: Double? = item["prevPrice24h"] as? Double
                        let vwap: Double? = item["vwap"] as? Double
                        let highPrice: Double? = item["highPrice"] as? Double
                        let lowPrice: Double? = item["lowPrice"] as? Double
                        let lastPrice: Double? = item["lastPrice"] as? Double
                        let lastPriceProtected: Double? = item["lastPriceProtected"] as? Double
                        let lastTickDirection: String? = item["lastTickDirection"] as? String
                        let lastChangePcnt: Double? = item["lastChangePcnt"] as? Double
                        let bidPrice: Double? = item["bidPrice"] as? Double
                        let midPrice: Double? = item["midPrice"] as? Double
                        let askPrice: Double? = item["askPrice"] as? Double
                        let impactBidPrice: Double? = item["impactBidPrice"] as? Double
                        let impactMidPrice: Double? = item["impactMidPrice"] as? Double
                        let impactAskPrice: Double? = item["impactAskPrice"] as? Double
                        let hasLiquidity: Bool? = item["hasLiquidity"] as? Bool
                        let openInterest: Double? = item["openInterest"] as? Double
                        let openValue: Double? = item["openValue"] as? Double
                        let fairMethod: String? = item["fairMethod"] as? String
                        let fairBasisRate: Double? = item["fairBasisRate"] as? Double
                        let fairBasis: Double? = item["fairBasis"] as? Double
                        let fairPrice: Double? = item["fairPrice"] as? Double
                        let markMethod: String? = item["markMethod"] as? String
                        let markPrice: Double? = item["markPrice"] as? Double
                        let indicativeTaxRate: Double? = item["indicativeTaxRate"] as? Double
                        let indicativeSettlePrice: Double? = item["indicativeSettlePrice"] as? Double
                        let optionUnderlyingPrice: Double? = item["optionUnderlyingPrice"] as? Double
                        let settledPrice: Double? = item["settledPrice"] as? Double
                        let timestamp: String? = item["timestamp"] as? String
                        
                        let instrument = Instrument(symbol: symbol, rootSymbol: rootSymbol, state: state, typ: typ, listing: listing, front: front, expiry: expiry, settle: settle, relistInterval: relistInterval, inverseLeg: inverseLeg, sellLeg: sellLeg, buyLeg: buyLeg, optionStrikePcnt: optionStrikePcnt, optionStrikeRound: optionStrikeRound, optionStrikePrice: optionStrikePrice, optionMultiplier: optionMultiplier, positionCurrency: positionCurrency, underlying: underlying, quoteCurrency: quoteCurrency, underlyingSymbol: underlyingSymbol, reference: reference, referenceSymbol: referenceSymbol, calcInterval: calcInterval, publishInterval: publishInterval, publishTime: publishTime, maxOrderQty: maxOrderQty, maxPrice: maxPrice, lotSize: lotSize, tickSize: tickSize, multiplier: multiplier, settlCurrency: settlCurrency, underlyingToPositionMultiplier: underlyingToPositionMultiplier, underlyingToSettleMultiplier: underlyingToSettleMultiplier, quoteToSettleMultiplier: quoteToSettleMultiplier, isQuanto: isQuanto, isInverse: isInverse, initMargin: initMargin, maintMargin: maintMargin, riskLimit: riskLimit, riskStep: riskStep, limit: limit, capped: capped, taxed: taxed, deleverage: deleverage, makerFee: makerFee, takerFee: takerFee, settlementFee: settlementFee, insuranceFee: insuranceFee, fundingBaseSymbol: fundingBaseSymbol, fundingQuoteSymbol: fundingQuoteSymbol, fundingPremiumSymbol: fundingPremiumSymbol, fundingTimestamp: fundingTimestamp, fundingInterval: fundingInterval, fundingRate: fundingRate, indicativeFundingRate: indicativeFundingRate, rebalanceTimestamp: rebalanceTimestamp, rebalanceInterval: rebalanceInterval, openingTimestamp: openingTimestamp, closingTimestamp: closingTimestamp, sessionInterval: sessionInterval, prevClosePrice: prevClosePrice, limitDownPrice: limitDownPrice, limitUpPrice: limitUpPrice, bankruptLimitDownPrice: bankruptLimitDownPrice, bankruptLimitUpPrice: bankruptLimitUpPrice, prevTotalVolume: prevTotalVolume, totalVolume: totalVolume, volume: volume, volume24h: volume24h, prevTotalTurnover: prevTotalTurnover, totalTurnover: totalTurnover, turnover: turnover, turnover24h: turnover24h, homeNotional24h: homeNotional24h, foreignNotional24h: foreignNotional24h, prevPrice24h: prevPrice24h, vwap: vwap, highPrice: highPrice, lowPrice: lowPrice, lastPrice: lastPrice, lastPriceProtected: lastPriceProtected, lastTickDirection: lastTickDirection, lastChangePcnt: lastChangePcnt, bidPrice: bidPrice, midPrice: midPrice, askPrice: askPrice, impactBidPrice: impactBidPrice, impactMidPrice: impactMidPrice, impactAskPrice: impactAskPrice, hasLiquidity: hasLiquidity, openInterest: openInterest, openValue: openValue, fairMethod: fairMethod, fairBasisRate: fairBasisRate, fairBasis: fairBasis, fairPrice: fairPrice, markMethod: markMethod, markPrice: markPrice, indicativeTaxRate: indicativeTaxRate, indicativeSettlePrice: indicativeSettlePrice, optionUnderlyingPrice: optionUnderlyingPrice, settledPrice: settledPrice, timestamp: timestamp)
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
