//
//  _Indicator.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/11/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit
import os.log

class Indicator: NSObject, NSCoding {
    //MARK: - Properties
    var id: String
    var name: String
    var inputs: [String: Any]
    var style: [String: Any]
    
    var value = [Date: Any]()
    
    
    
    
    //MARK: - Types
    enum SystemName: String {
        case volume
        case ma
        case rsi
        //case custom
        static func all() -> [String] {
            return ["volume", "ma", "rsi"]
        }
        
        func getAbbriviation() -> String {
            switch self {
            case .volume:
                return "vol"
            case .ma:
                return "ma"
            case .rsi:
                return "rsi"
            }
        }
    }
    
    enum Source: String {
        case open
        case high
        case low
        case close
        
        static func all() -> [String] {
            return ["open", "high", "low", "close"]
        }
    }
    
    enum Method: String {
        case simple
        case exponential
        
        static func all() -> [String] {
            return ["simple", "exponential"]
        }
    }
    
    
    struct InputKey: Hashable {
        ///type: Int
        static let length = "length"
        ///type: String
        static let source = "source"
        ///type: Bool
        static let bullish = "bullish"
        ///type: String
        static let method = "method"
        
    }
    
    struct StyleKey: Hashable {
        ///type: UIColor
        static let color = "color"
        ///type: CGFloat
        static let lineWidth = "lineWidth"
        
        ///type: Int
        static let row = "row"
        ///type: Double in Percentage (height = percentage of frame occupying bottomViews)
        static let height = "height"
        ///type: Bool
        static let hidden = "hidden"
        ///type: Double
        static let zIndex = "zIndex"
        
    }
    
    
    
    
    
    //MARK: - Initialization
    private init?(name: String, id: String, defaultInputs: [String: Any], defaultStyle: [String: Any]) {
        guard !name.isEmpty else { return nil }
        self.name = name
        self.inputs = defaultInputs
        self.style = defaultStyle
        self.id = id
    }
    
    
    
    static func fromSystem(name: SystemName, row: Int, height: Double, withInputs: [String: Any] = [:], andStyle: [String: Any] = [:]) -> Indicator {
        let indicator: Indicator
        
        let timestamp = Date().toMillis()
        let id = "\(name.rawValue)_\(timestamp)"
        
        switch name {
        case .volume:
            let defaultInputs: [String: Any] = [InputKey.method: Method.simple.rawValue,
                                                InputKey.length: 20]
            let defaultStyle: [String: Any] = [StyleKey.color: UIColor.orange,
                                               StyleKey.lineWidth: 0.5.toCGFLoat(),
                                               StyleKey.row: row,
                                               StyleKey.height: height]
            indicator = Indicator(name: name.rawValue, id: id, defaultInputs: defaultInputs, defaultStyle: defaultStyle)!
        case .ma:
            let defaultInputs: [String: Any] = [InputKey.source: Source.close.rawValue,
                                                InputKey.method: Method.exponential.rawValue,
                                                InputKey.length: 20]
            let defaultStyle: [String: Any] = [StyleKey.color: UIColor.orange,
                                               StyleKey.lineWidth: 0.5.toCGFLoat(),
                                               StyleKey.row: row,
                                               StyleKey.height: height]
            indicator = Indicator(name: name.rawValue, id: id, defaultInputs: defaultInputs, defaultStyle: defaultStyle)!
        case .rsi:
            let defaultInputs: [String: Any] = [InputKey.source: Source.close.rawValue,
                                                InputKey.length: 20]
            let defaultStyle: [String: Any] = [StyleKey.color: UIColor.orange,
                                               StyleKey.lineWidth: 0.5.toCGFLoat(),
                                               StyleKey.row: row,
                                               StyleKey.height: height]
            indicator = Indicator(name: name.rawValue, id: id, defaultInputs: defaultInputs, defaultStyle: defaultStyle)!
        }
        
        for (key, value) in withInputs {
            indicator.inputs[key] = value
        }
        for (key, value) in andStyle {
            indicator.style[key] = value
        }
        
        return indicator
    }
    
    
    
    //MARK: - Methods
    func computeValue(candles: [Candle]) {
        value.removeAll()
        if let systemName = SystemName(rawValue: name) {
            switch systemName {
            case .volume:
                var data = [Double]()
                for candle in candles {
                    data.append(candle.volume)
                }
                let smaLength = inputs[InputKey.length] as! Int
                let sma = Indicator.sma(data: data, length: smaLength)
                for i in 0 ..< data.count {
                    value[candles[i].openTime] = (data[i], sma[i])
                }
            case .ma:
                var data = [Double]()
                let source = Source(rawValue: inputs[InputKey.source] as! String)!
                for candle in candles {
                    switch source {
                    case .open:
                        data.append(candle.open)
                    case .high:
                        data.append(candle.high)
                    case .low:
                        data.append(candle.low)
                    case .close:
                        data.append(candle.close)
                    }
                }
                
                let length = inputs[InputKey.length] as! Int
                let ma: [Double]
                
                let methodRawValue = inputs[InputKey.method] as! String
                let method = Method(rawValue: methodRawValue)!
                switch method {
                case .simple:
                    ma = Indicator.sma(data: data, length: length)
                case .exponential:
                    ma = Indicator.ema(data: data, length: length)
                }
                for i in 0 ..< data.count {
                    value[candles[i].openTime] = ma[i]
                }
                
            case .rsi:
                var data = [Double]()
                let source = Source(rawValue: inputs[InputKey.source] as! String)!
                for candle in candles {
                    switch source {
                    case .open:
                        data.append(candle.open)
                    case .high:
                        data.append(candle.high)
                    case .low:
                        data.append(candle.low)
                    case .close:
                        data.append(candle.close)
                    }
                }
                
                let length = inputs[InputKey.length] as! Int
                let rsi: [Double] = Indicator.rsi(data: data, length: length)
                for i in 0 ..< data.count {
                    value[candles[i].openTime] = rsi[i]
                }
            }
        }
        
    }
    
    
    func getSettings() -> [(String, Any)] {
        var settings = [(String, Any)]()
        
        for (key, value) in inputs {
            settings.append((key, value))
        }
        
        for (key, value) in style {
            if  key.lowercased().contains(StyleKey.color) ||
                key.lowercased().contains(StyleKey.hidden) ||
                key.lowercased().contains(StyleKey.lineWidth.lowercased()) {
                settings.append((key, value))
            }
        }
        
        return settings
    }
    
    
    func getNameInFunctionForm() -> String {
        if let systemName = SystemName(rawValue: name) {
            switch systemName {
            case .volume:
                return "Volume(\(inputs[InputKey.length] as! Int))"
            case .ma:
                return "MA(\(inputs[InputKey.length] as! Int))"
            case .rsi:
                return "RSI(\(inputs[InputKey.length] as! Int))"
            }
        } else {
            return name
        }
    }
    
    
    func isSystemIndicator() -> Bool {
        return SystemName(rawValue: name) != nil
    }
    
    func getRow() -> Int {
        return style[StyleKey.row] as! Int
    }
    
    func getHeight() -> Double {
        return style[StyleKey.height] as! Double
    }
    
    
    //MARK: - Calculation Methods
    static func sma(data: [Double], length: Int) -> [Double] {
        var result = [Double]()
        if length > data.count {
            for _ in 0..<data.count {
                result.append(0)
            }
            return result
        }
        var sum: Double = 0
        for i in 0..<length-1 {
            result.append(0)
            sum += data[i]
        }
        sum += data[length - 1]
        result.append(sum / Double(length))
        
        for i in length ..< data.count {
            sum -= data[i - length]
            sum += data[i]
            result.append(sum / Double(length))
        }
        return result
    }
    
    
    static func ema(data: [Double], length: Int) -> [Double] {
        var result = [Double]()
        if length > data.count {
            for _ in 0..<data.count {
                result.append(0)
            }
            return result
        }
        var sum: Double = 0
        for i in 0..<length-1 {
            result.append(0)
            sum += data[i]
        }
        sum += data[length - 1]
        result.append(sum / Double(length))
        
        let multiplier: Double = (2.0 / (Double(length) + 1))
        for i in length ..< data.count {
            let r = result[i - 1] + Double(multiplier) * (data[i] - result[i - 1])
            result.append(r)
        }
        return result
    }
    
    
    private static func standardDeviation(data: [Double]) -> Double {
        var sum: Double = 0
        for d in data {
            sum += d
        }
        let mean = sum / Double(data.count)
        
        var s: Double = 0
        for d in data {
            s += ((d - mean) * (d - mean))
        }
        s = s / Double(data.count)
        
        return sqrt(s)
    }
    
    private static func std(data: [Double], length: Int) -> [Double] {
        var result = [Double]()
        
        if length > data.count {
            for _ in 0..<data.count {
                result.append(0)
            }
            return result
        }
        var pickedData = [Double]()
        for i in 0..<length-1 {
            result.append(0)
            pickedData.append(data[i])
        }
        pickedData.append(data[length - 1])
        result.append(Double(standardDeviation(data: pickedData)))
        
        for i in length ..< data.count {
            for j in 0..<length {
                pickedData[j] = data[j + i - length + 1]
            }
            result.append(Double(standardDeviation(data: pickedData)))
        }
        return result
    }
    
    
    static func rsi(data: [Double], length: Int) -> [Double] {
        var result = [Double]()
        if length >= data.count {
            for _ in 0..<data.count {
                result.append(0)
            }
            return result
        }
        
        var adv = [Double]()
        var dec = [Double]()
        
        for i in 0..<length {
            let change = data[i + 1] - data[i]
            if change > 0 {
                adv.append(change)
                dec.append(0)
            } else {
                adv.append(0)
                dec.append(-change)
            }
            result.append(0)
        }
        var avgGain: Double = 0
        for a in adv {
            avgGain += a
        }
        avgGain /= Double(length)
        var avgLoss: Double = 0
        for d in dec {
            avgLoss += d
        }
        avgLoss /= Double(length)
        
        var rs = avgGain / avgLoss
        var rsi = 100 * rs / (1 + rs)
        result.append(rsi)
        
        for i in length ..< data.count - 1 {
            let change = data[i + 1] - data[i]
            let ad = (change > 0) ? change : 0
            let de = (change > 0) ? 0 : -change
            avgGain = (avgGain * Double(length - 1) + ad) / Double(length)
            avgLoss = (avgLoss * Double(length - 1) + de) / Double(length)
            rs = avgGain / avgLoss
            rsi = 100 * rs / (1 + rs)
            result.append(rsi)
        }
        return result
    }
    
    
    
    static func macd(data: [Double], fastLength: Int, slowLength: Int, signalSmoothingLength: Int) -> [(Double, Double)] {
        var macd = [Double]()
        let emaSlow = ema(data: data, length: slowLength)
        let emaFast = ema(data: data, length: fastLength)
        
        for i in 0..<data.count {
            macd.append(emaFast[i] - emaSlow[i])
        }
        
        let signal = ema(data: macd, length: signalSmoothingLength)
        
        var result = [(Double, Double)]()
        for i in 0 ..< data.count {
            result.append((macd[i], signal[i]))
        }
        return result
    }
    
    /// return order: (upper, middle, lower)
    static func bollinger_bands(data: [Double], length: Int, stdDev: Int) -> [(Double, Double, Double)] {
        var result = [(Double, Double, Double)] ()
        if length > data.count {
            for _ in 0..<data.count {
                result.append((0, 0, 0))
            }
            return result
        }
        let sma = self.sma(data: data, length: length)
        let std = self.std(data: data, length: length)
        
        for i in 0..<data.count {
            result.append((sma[i] + Double(stdDev) * std[i], sma[i], sma[i] - Double(stdDev) * std[i]))
        }
        return result
    }
    
    
    
    
    //MARK: - NSCoding
    private struct Key {
        static let id = "indicator.id"
        static let name = "indicator.name"
        static let inputs = "indicator.inputs"
        static let style = "indicator.style"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Key.id)
        aCoder.encode(name, forKey: Key.name)
        aCoder.encode(inputs, forKey: Key.inputs)
        aCoder.encode(style, forKey: Key.style)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Key.id) as? String else {
            os_log("Unable to decode the id for a Indicator object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let name = aDecoder.decodeObject(forKey: Key.name) as? String else {
            os_log("Unable to decode the name for a Indicator object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let inputs = aDecoder.decodeObject(forKey: Key.inputs) as? [String: Any] else {
            os_log("Unable to decode the inputs for a Indicator object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let style = aDecoder.decodeObject(forKey: Key.style) as? [String: Any] else {
            os_log("Unable to decode the style for a Indicator object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(name: name, id: id, defaultInputs: inputs, defaultStyle: style)
    }
}
