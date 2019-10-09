//
//  PreviousVersionsOfCodes.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/12/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation



/*
 
 

 class Indicator : NSObject, NSCoding {
     
     var indicatorType: IndicatorType
     var properties = [String: Any]()
     var frameRow: Int = 0
     var frameHeightPercentage: Double
     var app: App? {
         let delegate = UIApplication.shared.delegate as? AppDelegate
         return delegate?.app
     }
     
     var indicatorValue = [Date: Any]()//(OPEN, VALUE)
     
     
     
     init(indicatorType: IndicatorType, properties: [String: Any] = [:], frameRow: Int, frameHeightPercentage: Double = 10) {
         self.indicatorType = indicatorType
         
         //Set Default Properties:
         switch indicatorType {
         case .volume:
             self.properties = [PropertyKey.length: 20, PropertyKey.color_1: UIColor.fromHex(hex: "#caf8fc"), PropertyKey.color_2: UIColor.blue.withAlphaComponent(0.3), PropertyKey.line_width_1: CGFloat(1), PropertyKey.layerIndex: Double(2.0)]
         case .sma:
             self.properties = [PropertyKey.source: "Close", PropertyKey.length: 8, PropertyKey.color_1: UIColor.blue.withAlphaComponent(0.5), PropertyKey.line_width_1: CGFloat(1), PropertyKey.layerIndex: Double(4.0)]
         case .ema:
             self.properties = [PropertyKey.source: "Close", PropertyKey.length: 8, PropertyKey.color_1: UIColor.blue.withAlphaComponent(0.5), PropertyKey.line_width_1: CGFloat(1), PropertyKey.layerIndex: Double(4.0)]
         case .rsi:
             self.properties = [PropertyKey.source: "Close", PropertyKey.length: 14, PropertyKey.color_1: UIColor.blue.withAlphaComponent(0.5), PropertyKey.line_width_1: CGFloat(1)]
         case .macd:
             self.properties = [PropertyKey.source: "Close", PropertyKey.fastLength: 12, PropertyKey.slowLength: 26, PropertyKey.signalSmoothingLength: 9, PropertyKey.color_1: UIColor.blue, PropertyKey.color_2: UIColor.red, PropertyKey.line_width_1: CGFloat(1), PropertyKey.line_width_2: CGFloat(1), PropertyKey.color_3: UIColor.green, PropertyKey.color_4: UIColor.red]
         case .bollinger_bands:
             self.properties = [PropertyKey.source: "Close", PropertyKey.fastLength: 20, PropertyKey.slowLength: 2, PropertyKey.showMiddleBand: false, PropertyKey.color_1: UIColor.gray, PropertyKey.line_width_1: CGFloat(1), PropertyKey.layerIndex: Double(3.0)]
         }
         
         for (key, value) in properties {
             self.properties[key] = value
         }
         
         
         
         self.frameRow = frameRow
         self.frameHeightPercentage = frameHeightPercentage
         super.init()
         
     }
     static func SMA(_ length: Int = 20, color: UIColor = UIColor.orange, lineWidth: CGFloat = 0.5, frameRow: Int = 0, layerIndex: Double) -> Indicator {
         return Indicator(indicatorType: .ema, properties: [Indicator.PropertyKey.length: length, Indicator.PropertyKey.color_1: color, Indicator.PropertyKey.line_width_1: lineWidth, Indicator.PropertyKey.layerIndex: layerIndex], frameRow: frameRow, frameHeightPercentage: 0)
     }
     static func EMA(_ length: Int = 20, color: UIColor = UIColor.orange, lineWidth: CGFloat = 0.5, frameRow: Int = 0, layerIndex: Double) -> Indicator {
         return Indicator(indicatorType: .ema, properties: [Indicator.PropertyKey.length: length, Indicator.PropertyKey.color_1: color, Indicator.PropertyKey.line_width_1: lineWidth, Indicator.PropertyKey.layerIndex: layerIndex], frameRow: frameRow, frameHeightPercentage: 0)
     }
     static func VOLUME(_ length: Int = 20, lineWidth: CGFloat = 0.5, frameRow: Int = 0) -> Indicator {
         return Indicator(indicatorType: .volume, properties: [Indicator.PropertyKey.length: length, Indicator.PropertyKey.line_width_1: lineWidth, Indicator.PropertyKey.layerIndex: Double(2.0)], frameRow: frameRow, frameHeightPercentage: 0)
     }
     static func RSI(_ length: Int = 14, color: UIColor = UIColor.orange, lineWidth: CGFloat = 0.5, frameRow: Int, frameHeightPercentage: Double) -> Indicator {
         return Indicator(indicatorType: .rsi, properties: [Indicator.PropertyKey.length: length, Indicator.PropertyKey.color_1: color, Indicator.PropertyKey.line_width_1: lineWidth], frameRow: frameRow, frameHeightPercentage: frameHeightPercentage)
     }
     
     //MARK: - Methods
     func calculateIndicatorValue(candles: [Candle]) {
         indicatorValue.removeAll()
         switch indicatorType {
         case .volume:
             var data = [Decimal]()
             for candle in candles {
                 data.append(candle.volume.decimalValue)
             }
             let smaLength = properties[PropertyKey.length] as! Int
             let sma = Indicator.sma(data: data, length: smaLength)
             for i in 0 ..< data.count {
                 indicatorValue[candles[i].openTime] = (data[i], sma[i])
             }
         case .sma:
             var data = [Decimal]()
             let source = properties[PropertyKey.source] as! String
             for candle in candles {
                 if source == "Open" {
                     data.append(candle.open.decimalValue)
                 } else if source == "Low" {
                     data.append(candle.low.decimalValue)
                 } else if source == "High" {
                     data.append(candle.high.decimalValue)
                 } else {
                     data.append(candle.close.decimalValue)
                 }
             }
             let smaLength = properties[PropertyKey.length] as! Int
             let sma = Indicator.sma(data: data, length: smaLength)
             for i in 0 ..< data.count {
                 indicatorValue[candles[i].openTime] = sma[i]
             }
         case .ema:
             var data = [Decimal]()
             let source = properties[PropertyKey.source] as! String
             for candle in candles {
                 if source == "Open" {
                     data.append(candle.open.decimalValue)
                 } else if source == "Low" {
                     data.append(candle.low.decimalValue)
                 } else if source == "High" {
                     data.append(candle.high.decimalValue)
                 } else {
                     data.append(candle.close.decimalValue)
                 }
             }
             let emaLength = properties[PropertyKey.length] as! Int
             let ema = Indicator.ema(data: data, length: emaLength)
             for i in 0 ..< data.count {
                 indicatorValue[candles[i].openTime] = ema[i]
             }
         case .rsi:
             var data = [Decimal]()
             let source = properties[PropertyKey.source] as! String
             for candle in candles {
                 if source == "Open" {
                     data.append(candle.open.decimalValue)
                 } else if source == "Low" {
                     data.append(candle.low.decimalValue)
                 } else if source == "High" {
                     data.append(candle.high.decimalValue)
                 } else {
                     data.append(candle.close.decimalValue)
                 }
             }
             let length = properties[PropertyKey.length] as! Int
             let rsi = Indicator.rsi(data: data, length: length)
             for i in 0 ..< rsi.count {
                 indicatorValue[candles[i].openTime] = rsi[i]
             }
         case .macd:
             var data = [Decimal]()
             let source = properties[PropertyKey.source] as! String
             for candle in candles {
                 if source == "Open" {
                     data.append(candle.open.decimalValue)
                 } else if source == "Low" {
                     data.append(candle.low.decimalValue)
                 } else if source == "High" {
                     data.append(candle.high.decimalValue)
                 } else {
                     data.append(candle.close.decimalValue)
                 }
             }
             let fastLength = properties[PropertyKey.fastLength] as! Int
             let slowLength = properties[PropertyKey.slowLength] as! Int
             let signalSmoothingLength = properties[Indicator.PropertyKey.signalSmoothingLength] as! Int
             let macd = Indicator.macd(data: data, fastLength: fastLength, slowLength: slowLength, signalSmoothingLength: signalSmoothingLength)
             for i in 0 ..< macd.count {
                 indicatorValue[candles[i].openTime] = macd[i]
             }
         case .bollinger_bands:
             var data = [Decimal]()
             let source = properties[PropertyKey.source] as! String
             for candle in candles {
                 if source == "Open" {
                     data.append(candle.open.decimalValue)
                 } else if source == "Low" {
                     data.append(candle.low.decimalValue)
                 } else if source == "High" {
                     data.append(candle.high.decimalValue)
                 } else {
                     data.append(candle.close.decimalValue)
                 }
             }
             let fastLength = properties[PropertyKey.fastLength] as! Int
             let slowLength = properties[PropertyKey.slowLength] as! Int
             let bb = Indicator.bollinger_bands(data: data, length: fastLength, stdDev: slowLength)
             for i in 0 ..< bb.count {
                 indicatorValue[candles[i].openTime] = bb[i]
             }
         }
     }
     
     
     
     func getNameInFunctionForm() -> String {
         switch indicatorType {
         case .volume:
             return "Volume(\(properties[PropertyKey.length] as! Int))"
         case .sma:
             return "SMA(\(properties[PropertyKey.length] as! Int))"
         case .ema:
             return "EMA(\(properties[PropertyKey.length] as! Int))"
         case .rsi:
             return "RSI(\(properties[PropertyKey.length] as! Int))"
         case .macd:
             return "MACD(\(properties[PropertyKey.fastLength] as! Int), \(properties[PropertyKey.slowLength] as! Int))"
         case .bollinger_bands:
             return "BOLL(\(properties[PropertyKey.fastLength] as! Int), \(properties[PropertyKey.slowLength] as! Int))"
         }
     }
     
     func getColor() -> UIColor {
         return properties[PropertyKey.color_1] as! UIColor
     }
     
     
     
     
     
     
     //MARK: - NSCoding
     private struct Key {
         static let indicatorType = "indicatorType"
         static let properties = "properties"
         static let frameRow = "frameRow"
         static let frameHeightPercentage = "frameHeightPercentage"
     }
     
     func encode(with aCoder: NSCoder) {
         aCoder.encode(indicatorType.rawValue, forKey: Key.indicatorType)
         aCoder.encode(properties, forKey: Key.properties)
         aCoder.encode(frameRow, forKey: Key.frameRow)
         aCoder.encode(frameHeightPercentage, forKey: Key.frameHeightPercentage)
     }
     
     required convenience init?(coder aDecoder: NSCoder) {
         guard let indicatorType = aDecoder.decodeObject(forKey: Key.indicatorType) as? String else {
             os_log("Unable to decode the indicatorType for a Indicator object.", log: OSLog.default, type: .debug)
             return nil
         }
         guard let properties = aDecoder.decodeObject(forKey: Key.properties) as? [String: Any] else {
             os_log("Unable to decode the properties for a Indicator object.", log: OSLog.default, type: .debug)
             return nil
         }
         let frameRow = aDecoder.decodeInteger(forKey: Key.frameRow)
         let frameHeightPercentage = aDecoder.decodeDouble(forKey: Key.frameHeightPercentage)
         self.init(indicatorType: Indicator.IndicatorType(rawValue: indicatorType)!, properties: properties, frameRow: frameRow, frameHeightPercentage: frameHeightPercentage)
     }
     
     
     
     
     
     //MARK: - Types
     
     enum IndicatorType: String {
         case volume
         case sma
         case ema
         case rsi
         case macd
         case bollinger_bands
         
         static func all() -> [IndicatorType] {
             return [.volume, .sma, .ema, .rsi]
         }
     }
     
     struct PropertyKey: Hashable {
         static let length = "length"//Int
         static let fastLength = "fastLength"//Int
         static let slowLength = "slowLength"//Int
         static let signalSmoothingLength = "signalSmoothingLength"//Int
         static let source = "source"//String
         static let showMiddleBand = "showMiddleBand"//Bool
         static let layerIndex = "layerIndex"//Double
         
         static let color_1 = "color_1"//UIColor
         static let line_width_1 = "line_width_1"//CGFloat
         static let color_2 = "color_2"//UIColor
         static let line_width_2 = "line_width_2"//CGFloat
         static let color_3 = "color_3"//UIColor
         static let line_width_3 = "line_width_3"//CGFloat
         static let color_4 = "color_4"//UIColor
         
         static let bullishOrBearish = "bullish/bearish"//Bool
     }
     
     
     
     
     //MARK: - static Functions
     
     static func sma(data: [Decimal], length: Int) -> [Decimal] {
         var result = [Decimal]()
         if length > data.count {
             for _ in 0..<data.count {
                 result.append(0)
             }
             return result
         }
         var sum: Decimal = 0
         for i in 0..<length-1 {
             result.append(0)
             sum += data[i]
         }
         sum += data[length - 1]
         result.append(sum / Decimal(length))
         
         for i in length ..< data.count {
             sum -= data[i - length]
             sum += data[i]
             result.append(sum / Decimal(length))
         }
         return result
     }
     
     
     static func ema(data: [Decimal], length: Int) -> [Decimal] {
         var result = [Decimal]()
         if length > data.count {
             for _ in 0..<data.count {
                 result.append(0)
             }
             return result
         }
         var sum: Decimal = 0
         for i in 0..<length-1 {
             result.append(0)
             sum += data[i]
         }
         sum += data[length - 1]
         result.append(sum / Decimal(length))
         
         let multiplier: Double = (2.0 / (Double(length) + 1))
         for i in length ..< data.count {
             let r = result[i - 1] + Decimal(multiplier) * (data[i] - result[i - 1])
             result.append(r)
         }
         return result
     }
     
     
     private static func standardDeviation(data: [Decimal]) -> Double {
         var sum: Decimal = 0
         for d in data {
             sum += d
         }
         let mean = sum / Decimal(data.count)
         
         var s: Decimal = 0
         for d in data {
             s += ((d - mean) * (d - mean))
         }
         s = s / Decimal(data.count)
         
         return sqrt(s.doubleValue)
     }
     
     private static func std(data: [Decimal], length: Int) -> [Decimal] {
         var result = [Decimal]()
         
         if length > data.count {
             for _ in 0..<data.count {
                 result.append(0)
             }
             return result
         }
         var pickedData = [Decimal]()
         for i in 0..<length-1 {
             result.append(0)
             pickedData.append(data[i])
         }
         pickedData.append(data[length - 1])
         result.append(Decimal(standardDeviation(data: pickedData)))
         
         for i in length ..< data.count {
             for j in 0..<length {
                 pickedData[j] = data[j + i - length + 1]
             }
             result.append(Decimal(standardDeviation(data: pickedData)))
         }
         return result
     }
     
     
     static func rsi(data: [Decimal], length: Int) -> [Decimal] {
         var result = [Decimal]()
         if length >= data.count {
             for _ in 0..<data.count {
                 result.append(0)
             }
             return result
         }
         
         var adv = [Decimal]()
         var dec = [Decimal]()
         
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
         var avgGain: Decimal = 0
         for a in adv {
             avgGain += a
         }
         avgGain /= Decimal(length)
         var avgLoss: Decimal = 0
         for d in dec {
             avgLoss += d
         }
         avgLoss /= Decimal(length)
         
         var rs = avgGain / avgLoss
         var rsi = 100 * rs / (1 + rs)
         result.append(rsi)
         
         for i in length ..< data.count - 1 {
             let change = data[i + 1] - data[i]
             let ad = (change > 0) ? change : 0
             let de = (change > 0) ? 0 : -change
             avgGain = (avgGain * Decimal(length - 1) + ad) / Decimal(length)
             avgLoss = (avgLoss * Decimal(length - 1) + de) / Decimal(length)
             rs = avgGain / avgLoss
             rsi = 100 * rs / (1 + rs)
             result.append(rsi)
         }
         return result
     }
     
     
     
     static func macd(data: [Decimal], fastLength: Int, slowLength: Int, signalSmoothingLength: Int) -> [(Decimal, Decimal)] {
         var macd = [Decimal]()
         let emaSlow = ema(data: data, length: slowLength)
         let emaFast = ema(data: data, length: fastLength)
         
         for i in 0..<data.count {
             macd.append(emaFast[i] - emaSlow[i])
         }
         
         let signal = ema(data: macd, length: signalSmoothingLength)
         
         var result = [(Decimal, Decimal)]()
         for i in 0 ..< data.count {
             result.append((macd[i], signal[i]))
         }
         return result
     }
     
     /// return order: (upper, middle, lower)
     static func bollinger_bands(data: [Decimal], length: Int, stdDev: Int) -> [(Decimal, Decimal, Decimal)] {
         var result = [(Decimal, Decimal, Decimal)] ()
         if length > data.count {
             for _ in 0..<data.count {
                 result.append((0, 0, 0))
             }
             return result
         }
         let sma = self.sma(data: data, length: length)
         let std = self.std(data: data, length: length)
         
         for i in 0..<data.count {
             result.append((sma[i] + Decimal(stdDev) * std[i], sma[i], sma[i] - Decimal(stdDev) * std[i]))
         }
         return result
     }
     
     
     
     
 }


 
 
 
 
 
 */
