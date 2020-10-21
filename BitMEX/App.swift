//
//  App.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/23/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit
import os.log

class App {
    
    //MARK: - Properties
    var settings: Settings
    var defaultSettings = Settings()
    var activeInstruments = [Instrument]()
    var chart: Chart? {
        return chartVC?.chart
    }
    var chartVC: ChartVC?
    var orderVC: OrderVC?
    var viewController: ViewController?
    var tabBarVC: UITabBarController?
    
    var chartNeedsSetupOnViewAppeared = true
    
    var viewAnimationDuration = 0.15
    //MARK: Convinience Properties
    static var BullColor = UIColor.fromHex(hex: "#26A69A")
    static var BearColor = UIColor.fromHex(hex: "#EF5350")
    
    var webSocket = WebSocket("wss://www.bitmex.com/realtime")
    var authentication: Authentication? {
        didSet {
            if let vc = orderVC {
                vc.initWebsocket()
            }
            if let vc = chartVC {
                vc.chart.activateWebsocket()
            }
        }
    }
    
    var user: User?
    var walletHistory: [User.WalletHistory]?
    var wallet: User.Wallet?
    var margin: User.Margin?
    var position: [Position]?
    var orders: [Order]?
    
    var insX = 0
    var margX = 0
    
    var websocketCompletions: [String: [([String: Any]) -> Void]] = [:]
    private var realtimeSubscriptionArgs: [String] = []
    private var partials: [String: [String: Any]?] = [:]
    

    
    //MARK: - Initialization
    init() {
        settings = Settings()
        settings = loadSettings() ?? Settings()
        App.BullColor = settings.bullCandleColor
        App.BearColor = settings.bearCandleColor
    }
    
    
    
    //MARK: - Methods
    func resetWebSocket() {
        if !websocketCompletions.isEmpty {
            var tableNames: [String] = []
            for (k, _) in websocketCompletions {
                tableNames.append(k)
            }
            unsubscribeRealTime()
            webSocket = WebSocket("wss://www.bitmex.com/realtime")
        }
        partials.removeAll()
        realtimeSubscriptionArgs.removeAll()
        websocketCompletions.removeAll()
        
        realtimeSubscriptionArgs = ["instrument:\(settings.chartSymbol)", "position", "wallet", "margin", "order", "orderBookL2_25:\(settings.chartSymbol)", "trade:\(settings.chartSymbol)"]
        for arg in realtimeSubscriptionArgs {
            websocketCompletions[arg] = []
        }
        subscribeRealTime()
    }
    
    func removeLatestWebsocketCompletion(arg: String) {
        if websocketCompletions[arg] != nil {
            if !websocketCompletions[arg]!.isEmpty {
                websocketCompletions[arg]!.removeLast()
            }
        }
    }
    
    
    
    func subscribeRealTime() {
        if let auth = self.authentication {
            let api_expires = String(Int(Date().timeIntervalSince1970.rounded()) + 5)
            let api_signature: String = "GET/realtime" + api_expires
            let sig = api_signature.hmac(algorithm: .SHA256, key: auth.apiSecret)
            webSocket.send(text: "{\"op\": \"authKeyExpires\", \"args\": [\"\(auth.apiKey)\", \(api_expires), \"\(sig)\"]}")
        }
        
        let message: String = "{\"op\": \"subscribe\", \"args\": " + realtimeSubscriptionArgs.description + "}"
        webSocket.send(text: message)
        
        webSocket.event.message = { msg in
            guard let message = msg as? String  else {
                return
            }
            guard let data = message.data(using: .utf8) else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: Any] {
                    if let table = json["table"] as? String {
                        let comps = self.websocketCompletions.first { (element) -> Bool in
                            return element.key.split(separator: ":")[0] == table
                        }?.value
                        guard let completions = comps else { return }
                        if table == "trade" {
                            completions.first?(json)
                        } else {
                            self.partials[table] = RealTime.processPayload(payload: json, partial: self.partials[table] ?? nil)
                            
                            for completion in completions {
                                if let p = self.partials[table]! as [String: Any]? {
                                    completion(p)
                                }
                            }
                        }
                    }
                }
            } catch {
            }
        }
    }
    
    private func unsubscribeRealTime() {
        if realtimeSubscriptionArgs.isEmpty { return }
        if let auth = self.authentication {
            let api_expires = String(Int(Date().timeIntervalSince1970.rounded()) + 5)
            let api_signature: String = "GET/realtime" + api_expires
            let sig = api_signature.hmac(algorithm: .SHA256, key: auth.apiSecret)
            webSocket.send(text: "{\"op\": \"authKeyExpires\", \"args\": [\"\(auth.apiKey)\", \(api_expires), \"\(sig)\"]}")
        }
        
        
        let message: String = "{\"op\": \"unsubscribe\", \"args\": " + realtimeSubscriptionArgs.description + "}"
        webSocket.send(text: message)
        webSocket.close()
    }
    
    func getInstrument(_ symbol: String) -> Instrument? {
        for instrument in activeInstruments {
            if instrument.symbol.lowercased() == symbol.lowercased() {
                return instrument
            }
        }
        return nil
    }
    
    func getSortedActiveInstruments() -> [Instrument] {
        var arr = getSortedActiveInstrumentsAscending()
        if settings.sortDirection == .DESCENDING {
            arr.reverse()
        }
        return arr
    }
    
    private func getSortedActiveInstrumentsAscending() -> [Instrument] {
        if settings.sortBy == .DEFAULT {
            return activeInstruments
        }
        return activeInstruments.sorted(by: { (i1, i2) -> Bool in
            switch settings.sortBy {
            case .DEFAULT:
                return true
            case .SYMBOL:
                return i1.symbol < i2.symbol
            case . VOLUME:
                if let v1 = i1.volume, let v2 = i2.volume {
                    return v1 < v2
                } else {
                    return false
                }
            case .PRICE:
                if let p1 = i1.lastPrice, let p2 = i2.lastPrice {
                    return p1 > p2
                } else {
                    return false
                }
            case .PERCENT_CHANGE:
                if let c1 = i1.lastPrice, let c2 = i2.lastPrice, let o1 = i1.prevClosePrice, let o2 = i2.prevClosePrice {
                    if o1 > 0 && o2 > 0 {
                        let ch1 = c1 / o1, ch2 = c2 / o2
                        return ch1 > ch2
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            }
        })
    }
    
    func saveSettings() {
        settings.save()
    }
    
    func loadSettings() -> Settings? {
        guard let data = try? Data(contentsOf: Settings.ArchiveURL) else {
            os_log("Failed to decode app settings url data content...", log: OSLog.default, type: .error)
            return nil
        }
        var result: Settings?
        do {
            result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Settings
        } catch {
            os_log("Failed to load App Settings...", log: OSLog.default, type: .error)
        }
        return result
    }
    
}

class Settings: NSObject, NSCoding {
    
    //MARK: - Properties
    
    var bullCandleColor = UIColor.fromHex(hex: "#26A69A") {
        didSet {
            App.BullColor = bullCandleColor
        }
    }
    var bearCandleColor = UIColor.fromHex(hex: "#EF5350") {
        didSet {
            App.BearColor = bearCandleColor
        }
    }
    var priceLineColor: UIColor = .systemBlue
    var chartBackgroundColor: UIColor = .white
    var gridLinesColor: UIColor = UIColor.lightGray.withAlphaComponent(0.1)
    var crosshairColor: UIColor = .black
    var showTitles = true
    
    var chartTopMargin: Double = 10
    var chartBottomMargin: Double = 10
    var chartAutoScale = true
    var chartLogScale = false
    var chartSymbol: String = "XBTUSD"
    var chartTimeframe: Timeframe = .daily
    var chartLatestX: CGFloat = UIScreen.main.bounds.width * 0.75
    var chartBlockWidth: CGFloat = 5
    var chartHighestPrice: Double = 0
    var chartLowestPrice: Double = 0
    var chartIndicators: [Indicator] = [
        Indicator.fromSystem(name: .volume, row: 0, height: 20.0),
        Indicator.fromSystem(name: .ma, row: 0, height: 100.0, withInputs: [Indicator.InputKey.length: 20], andStyle: [Indicator.StyleKey.color: UIColor.fromHex(hex: "#FF981C"), Indicator.StyleKey.lineWidth: CGFloat(1.0), Indicator.StyleKey.zIndex: 6.0]),
        Indicator.fromSystem(name: .ma, row: 0, height: 100.0, withInputs: [Indicator.InputKey.length: 50], andStyle: [Indicator.StyleKey.color: UIColor.fromHex(hex: "#AC47B9"), Indicator.StyleKey.lineWidth: CGFloat(1.5), Indicator.StyleKey.zIndex: 5.0]),
        Indicator.fromSystem(name: .ma, row: 0, height: 100.0, withInputs: [Indicator.InputKey.length: 200], andStyle: [Indicator.StyleKey.color: UIColor.fromHex(hex: "#EB1E61"), Indicator.StyleKey.lineWidth: CGFloat(2.0), Indicator.StyleKey.zIndex: 4.0]),
        Indicator.fromSystem(name: .rsi, row: 1, height: 20.0)]
    
    var sortBy = SortBy.VOLUME
    var sortDirection = SortDirection.DESCENDING
    
    
    
    var accountApiKey: String = "aKWQfFXJqFM0sZ7Zts14_1u6"
    var accountApiSecret: String = "ILi7K_G1fYdRn79QcJFRlZ3jOGvchX5PnWrkd4Q37E8SSdv9"
    
    var app: App? {
        return (UIApplication.shared.delegate as? AppDelegate)?.app
    }
    
    init(sortBy: Int?, sortDirection: Int?, bullCandleColor: UIColor?, bearCandleColor: UIColor?, chartAutoScale: Bool?, chartLogScale: Bool?, chartSymbol: String?, chartTimeframe: String?, chartBlockWidth: CGFloat?, chartLatestX: CGFloat?, chartHighestPrice: Double?, chartLowestPrice: Double?, chartIndicators: [Indicator]?, chartTopMargin: Double?, chartBottomMargin: Double?, priceLineColor: UIColor?, chartBackgroundColor: UIColor?, gridLinesColor: UIColor?, crosshairColor: UIColor?, showTitles: Bool?, accountApiKey: String?, accountApiSecret: String?) {
        if let q = sortBy, let s = SortBy(rawValue: q) { self.sortBy = s}
        if let q = sortDirection, let s = SortDirection(rawValue: q) { self.sortDirection = s}
        if let q = bullCandleColor { self.bullCandleColor = q}
        if let q = bearCandleColor { self.bearCandleColor = q}
        if let q = chartAutoScale { self.chartAutoScale = q}
        if let q = chartLogScale { self.chartLogScale = q}
        if let s = chartSymbol { self.chartSymbol = s }
        if let q = chartTimeframe, let timeframe = Timeframe(rawValue: q) { self.chartTimeframe = timeframe}
        if let q = chartBlockWidth { self.chartBlockWidth = q}
        if let q = chartHighestPrice { self.chartHighestPrice = q}
        if let q = chartLowestPrice { self.chartLowestPrice = q}
        if let q = chartIndicators { self.chartIndicators = q}
        if let q = chartTopMargin { self.chartTopMargin = q}
        if let q = chartBottomMargin { self.chartBottomMargin = q}
        if let q = chartLatestX { self.chartLatestX = q}
        if let q = priceLineColor { self.priceLineColor = q}
        if let q = chartBackgroundColor { self.chartBackgroundColor = q}
        if let q = gridLinesColor { self.gridLinesColor = q}
        if let q = crosshairColor { self.crosshairColor = q}
        if let q = showTitles { self.showTitles = q}
        if let q = accountApiKey { self.accountApiKey = q}
        if let q = accountApiSecret { self.accountApiSecret = q}
        super.init()
        self.chartIndicators = sort(indicators: self.chartIndicators)
    }
    
    override init() {
        super.init()
        chartIndicators = sort(indicators: chartIndicators)
    }
    
    //MARK: Types
    struct Key {
        static let sortBy = "sortBy"
        static let sortDirection = "sortDirection"
        static let chartSymbol = "chartSymbol"
        static let bullCandleColor = "bullCandleColor"
        static let bearCandleColor = "bearCandleColor"
        static let chartAutoScale = "chartAutoScale"
        static let chartLogScale = "chartLogScale"
        static let chartTimeframe = "chartTimeframe"
        static let chartBlockWidth = "chartBlockWidth"
        static let chartHighestPrice = "chartHighestPrice"
        static let chartLowestPrice = "chartLowestPrice"
        static let chartIndicators = "chartIndicators"
        static let chartTopMargin = "chartTopMargin"
        static let chartBottomMargin = "chartBottomMargin"
        static let chartLatestX = "chartLatestX"
        static let priceLineColor = "priceLineColor"
        static let chartBackgroundColor = "chartBackgroundColor"
        static let gridLinesColor = "gridLinesColor"
        static let crosshairColor = "crosshairColor"
        static let showTitles = "showTitles"
        static let accountApiKey = "accountApiKey"
        static let accountApiSecret = "accountApiSecret"
        
    }
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sortBy.rawValue, forKey: Key.sortBy)
        aCoder.encode(sortDirection.rawValue, forKey: Key.sortDirection)
        aCoder.encode(bullCandleColor, forKey: Key.bullCandleColor)
        aCoder.encode(bearCandleColor, forKey: Key.bearCandleColor)
        aCoder.encode(chartAutoScale, forKey: Key.chartAutoScale)
        aCoder.encode(chartLogScale, forKey: Key.chartLogScale)
        aCoder.encode(chartSymbol, forKey: Key.chartSymbol)
        aCoder.encode(chartTopMargin, forKey: Key.chartTopMargin)
        aCoder.encode(chartBottomMargin, forKey: Key.chartBottomMargin)
        aCoder.encode(chartTimeframe.rawValue, forKey: Key.chartTimeframe)
        aCoder.encode(chartIndicators, forKey: Key.chartIndicators)
        aCoder.encode(chartBlockWidth, forKey: Key.chartBlockWidth)
        aCoder.encode(chartHighestPrice, forKey: Key.chartHighestPrice)
        aCoder.encode(chartLowestPrice, forKey: Key.chartLowestPrice)
        aCoder.encode(chartLatestX, forKey: Key.chartLatestX)
        aCoder.encode(priceLineColor, forKey: Key.priceLineColor)
        aCoder.encode(chartBackgroundColor, forKey: Key.chartBackgroundColor)
        aCoder.encode(gridLinesColor, forKey: Key.gridLinesColor)
        aCoder.encode(crosshairColor, forKey: Key.crosshairColor)
        aCoder.encode(showTitles, forKey: Key.showTitles)
        aCoder.encode(accountApiKey, forKey: Key.accountApiKey)
        aCoder.encode(accountApiSecret, forKey: Key.accountApiSecret)
    }
    
    
    required convenience init?(coder decoder: NSCoder) {
        let sortBy: Int? = decoder.containsValue(forKey: Key.sortBy) ? decoder.decodeInteger(forKey: Key.sortBy) : nil
        let sortDirection: Int? = decoder.containsValue(forKey: Key.sortDirection) ? decoder.decodeInteger(forKey: Key.sortDirection) : nil
        let bullCandleColor: UIColor? = decoder.containsValue(forKey: Key.bullCandleColor) ? decoder.decodeObject(forKey: Key.bullCandleColor) as? UIColor : nil
        let bearCandleColor: UIColor? = decoder.containsValue(forKey: Key.bearCandleColor) ? decoder.decodeObject(forKey: Key.bearCandleColor) as? UIColor : nil
        let chartAutoScale: Bool? = decoder.containsValue(forKey: Key.chartAutoScale) ? decoder.decodeBool(forKey: Key.chartAutoScale) : nil
        let chartLogScale: Bool? = decoder.containsValue(forKey: Key.chartLogScale) ? decoder.decodeBool(forKey: Key.chartLogScale) : nil
        let chartSymbol: String? = decoder.containsValue(forKey: Key.chartSymbol) ? decoder.decodeObject(forKey: Key.chartSymbol) as? String : nil
        let chartTimeframe: String? = decoder.containsValue(forKey: Key.chartTimeframe) ? decoder.decodeObject(forKey: Key.chartTimeframe) as? String : nil
        let chartBlockWidth: CGFloat? = decoder.containsValue(forKey: Key.chartBlockWidth) ? decoder.decodeObject(forKey: Key.chartBlockWidth) as? CGFloat : nil
        let chartLatestX: CGFloat? = decoder.containsValue(forKey: Key.chartLatestX) ? decoder.decodeObject(forKey: Key.chartLatestX) as? CGFloat : nil
        let chartHighestPrice: Double? = decoder.containsValue(forKey: Key.chartHighestPrice) ? decoder.decodeDouble(forKey: Key.chartHighestPrice) : nil
        let chartLowestPrice: Double? = decoder.containsValue(forKey: Key.chartLowestPrice) ? decoder.decodeDouble(forKey: Key.chartLowestPrice) : nil
        let chartIndicators: [Indicator]? = decoder.containsValue(forKey: Key.chartIndicators) ? decoder.decodeObject(forKey: Key.chartIndicators) as? [Indicator] : nil
        let chartTopMargin: Double? = decoder.containsValue(forKey: Key.chartTopMargin) ? decoder.decodeDouble(forKey: Key.chartTopMargin) : nil
        let chartBottomMargin: Double? = decoder.containsValue(forKey: Key.chartBottomMargin) ? decoder.decodeDouble(forKey: Key.chartBottomMargin) : nil
        let priceLineColor: UIColor? = decoder.containsValue(forKey: Key.priceLineColor) ? decoder.decodeObject(forKey: Key.priceLineColor) as? UIColor : nil
        let chartBackgroundColor: UIColor? = decoder.containsValue(forKey: Key.chartBackgroundColor) ? decoder.decodeObject(forKey: Key.chartBackgroundColor) as? UIColor : nil
        let gridLinesColor: UIColor? = decoder.containsValue(forKey: Key.gridLinesColor) ? decoder.decodeObject(forKey: Key.gridLinesColor) as? UIColor : nil
        let crosshairColor: UIColor? = decoder.containsValue(forKey: Key.crosshairColor) ? decoder.decodeObject(forKey: Key.crosshairColor) as? UIColor : nil
        let showTitles: Bool? = decoder.containsValue(forKey: Key.showTitles) ? decoder.decodeBool(forKey: Key.showTitles) : nil
        let accountApiKey: String? = decoder.containsValue(forKey: Key.accountApiKey) ? decoder.decodeObject(forKey: Key.accountApiKey) as? String : nil
        let accountApiSecret: String? = decoder.containsValue(forKey: Key.accountApiSecret) ? decoder.decodeObject(forKey: Key.accountApiSecret) as? String : nil
        
        self.init(sortBy: sortBy, sortDirection: sortDirection, bullCandleColor: bullCandleColor, bearCandleColor: bearCandleColor, chartAutoScale: chartAutoScale, chartLogScale: chartLogScale, chartSymbol: chartSymbol, chartTimeframe: chartTimeframe, chartBlockWidth: chartBlockWidth, chartLatestX: chartLatestX, chartHighestPrice: chartHighestPrice, chartLowestPrice: chartLowestPrice, chartIndicators: chartIndicators, chartTopMargin: chartTopMargin, chartBottomMargin: chartBottomMargin, priceLineColor: priceLineColor, chartBackgroundColor: chartBackgroundColor, gridLinesColor: gridLinesColor, crosshairColor: crosshairColor, showTitles: showTitles, accountApiKey: accountApiKey, accountApiSecret: accountApiSecret)
        
    }
    
    func save() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            try data.write(to: Settings.ArchiveURL)
        } catch {
            os_log("Failed to save Settings...", log: OSLog.default, type: .error)
        }
    }
    
    //MARK: Archiving Paths
    fileprivate static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    fileprivate static let ArchiveURL = DocumentsDirectory.appendingPathComponent("bitmex")
    
    
    
    //MARK: Private Methods
    private func sort(indicators: [Indicator]) -> [Indicator] {
        var result = [Indicator]()
        var frameRow = 0
        while result.count < indicators.count {
            let indicatorsInThisFrameRow = indicators.filter { (ind) -> Bool in
                return ind.getRow() == frameRow
            }
            //Find SmallestLayerIndex
            var smallestLayerIndex: Double = 0.0
            indicatorsInThisFrameRow.forEach { (indicator) in
                if let index = indicator.style[Indicator.StyleKey.zIndex] as? Double {
                    if index < smallestLayerIndex {
                        smallestLayerIndex = index
                    }
                }
            }
            indicatorsInThisFrameRow.forEach { (indicator) in
                if indicator.style[Indicator.StyleKey.zIndex] == nil {
                    smallestLayerIndex -= 1.0
                    indicator.style[Indicator.StyleKey.zIndex] = smallestLayerIndex
                }
            }
            
            result.append(contentsOf: indicatorsInThisFrameRow.sorted(by: { (ind1, ind2) -> Bool in
                return (ind1.style[Indicator.StyleKey.zIndex] as! Double) >
                    (ind2.style[Indicator.StyleKey.zIndex] as! Double)
            }))
            
            frameRow += 1
        }
        return result
    }
}
