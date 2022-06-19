//
//  Candle.swift
//  Binance+
//
//  Created by Behnam Karimi on 12/22/1397 AP.
//  Copyright © 1397 AP Behnam Karimi. All rights reserved.
//

import UIKit

class Candle {
    
    
    //MARK: - Properties
    var open, close, high, low: Double
    var volume: Double
    var timeframe: Timeframe
    /// in utc time
    var closeTime: Date
    
    
    //MARK: For Drawing
    var x: CGFloat = 0
    
    
    //MARK: - Initialization
    init(open: Double, close: Double, high: Double, low: Double, volume: Double, timeframe: Timeframe, closeTime: Date) {
        self.open = open
        self.close = close
        self.high = high
        self.low = low
        self.volume = volume
        self.timeframe = timeframe
        self.closeTime = closeTime
        
    }
    
    //MARK: - Methods
    func isGreen() -> Bool {
        return close > open
    }
    
    func nextCandleOpenTime() -> Date {
        return openTime.advanced(by: TimeInterval(timeframe.toMinutes()) * 60)
    }
    
    func description() -> String {
        return String(close) + ""
    }
    
    /// in utc time
    var openTime: Date {
        return closeTime.dateBy(subtracting: timeframe)
    }
    
    
    
    
    
    //MARK: - Static Methods
    
    
    static func downloadPartial(open: Double, timeframe: Timeframe, instrument: Instrument, startTime: TimeInterval, endTime: TimeInterval, completion: @escaping (Candle?, URLResponse?, Error?) -> Void) {
        switch timeframe {
        case .oneMinute:
            Trade.GET(symbol: instrument.symbol, count: nil, reverse: true, start: nil, startTime: Date(timeIntervalSince1970: startTime).bitMEXStringWithSeconds(), endTime: Date(timeIntervalSince1970: endTime).bitMEXStringWithSeconds(), filter: nil, columns: nil) { (_trades, response, error) in
                guard error == nil && response != nil else { completion(nil, response, error); return }
                if (response as! HTTPURLResponse).statusCode == 200 {
                    if let trades = _trades {
                        if !trades.isEmpty {
                            var high = trades.first!.price!
                            let close = trades.first!.price!
                            var low = trades.first!.price!
                            var volume = 0.0
                            for trade in trades {
                                let ti = Date.fromBitMEXString(str: trade.timestamp)!.timeIntervalSince1970
                                if ti >= startTime && ti < endTime {
                                    if trade.price! > high {
                                        high = trade.price!
                                    }
                                    if trade.price! < low {
                                        low = trade.price!
                                    }
                                    volume += trade.size!
                                }
                            }
                            let candle = Candle(open: open, close: close, high: high, low: low, volume: volume, timeframe: timeframe, closeTime: Date(timeIntervalSince1970: startTime + 60))
                            completion(candle, response, error)
                            return
                        } else {
                            let candle = Candle(open: open, close: open, high: open, low: open, volume: 0, timeframe: timeframe, closeTime: Date(timeIntervalSince1970: startTime + 60))
                            completion(candle, response, error)
                        }
                    }
                } else {
                    completion(nil, response, error)
                }
            }
        default:
            var lowerTF: Timeframe = timeframe.lowerTimeframe()
            if timeframe == .thirtyMinutes || timeframe == .hourly {
                lowerTF = .fiveMinutes
            } else if timeframe == .fourHourly || timeframe == .twelveHourly || timeframe == .daily {
                lowerTF = .hourly
            } else if timeframe == .monthly {
                lowerTF = .daily
            }
            
            let diff = endTime - startTime
            let buckets = Int(diff / Double(lowerTF.toMinutes() * 60))
            let lowerTimeframeStartTime = startTime + Double(lowerTF.toMinutes()) * Double(buckets)
            if buckets > 0 {
                download(timeframe: lowerTF, instrument: instrument, partialCandle: false, reverse: true, count: buckets, startTime: Date(timeIntervalSince1970: startTime).bitMEXString(), endTime: Date(timeIntervalSince1970: endTime).bitMEXString()) { (_candles, response, error) in
                    guard error == nil && response != nil else { completion(nil, response, error); return }
                    if (response as! HTTPURLResponse).statusCode == 200 {
                        
                        var high = open
                        var low = open
                        var volume = 0.0
                        var close = open
                        
                        if let candles = _candles {
                            for candle in candles {
                                if candle.low < low { low = candle.low }
                                if candle.high > high { high = candle.high }
                                volume += candle.volume
                            }
                            if !candles.isEmpty {
                                close = candles.first!.close
                            }
                        }
                        downloadPartial(open: close, timeframe: lowerTF, instrument: instrument, startTime: lowerTimeframeStartTime, endTime: endTime) { (_candle, resp, err) in
                            guard err == nil && resp != nil else { completion(nil, resp, err); return }
                            if (resp as! HTTPURLResponse).statusCode == 200 {
                                if let candle = _candle {
                                    if candle.low < low { low = candle.low }
                                    if candle.high > high { high = candle.high }
                                    volume += candle.volume
                                    close = candle.close
                                }
                                let result = Candle(open: open, close: close, high: high, low: low, volume: volume, timeframe: timeframe, closeTime: Date(timeIntervalSince1970: startTime).nextOpenTime(timeframe: timeframe)!)
                                completion(result, resp, err)
                            } else {
                                completion(nil, resp, err)
                            }
                        }
                    } else {
                        completion(nil, response, error)
                    }
                }
            } else {
                downloadPartial(open: open, timeframe: lowerTF, instrument: instrument, startTime: lowerTimeframeStartTime, endTime: endTime) { (_candle, resp, err) in
                    guard err == nil && resp != nil else { completion(nil, resp, err); return }
                    if (resp as! HTTPURLResponse).statusCode == 200 {
                        _candle?.closeTime = Date(timeIntervalSince1970: startTime).nextOpenTime(timeframe: timeframe)!
                        completion(_candle, resp, err)
                    } else {
                        completion(nil, resp, err)
                    }
                }
            }
        }
    }
    
    static func download(timeframe: Timeframe, instrument: Instrument, partialCandle: Bool? = nil, reverse: Bool? = nil, count: Int? = nil, startTime: String? = nil, endTime: String? = nil, completion: @escaping ([Candle]?, URLResponse?, Error?) -> Void) {
        var bucket: Timeframe = timeframe
        switch timeframe {
        case .oneMinute, .fiveMinutes, .hourly, .daily:
            Trade.GET_Bucketed(binSize: bucket.rawValue, partial: partialCandle, symbol: instrument.symbol, count: count, reverse: reverse, startTime: startTime, endTime: endTime) { (opBucketed, opResponse, opError) in
                
                guard opError == nil else {
                    completion(nil, opResponse, opError)
                    return
                }
                guard opResponse != nil else {
                    completion(nil, nil, opError)
                    return
                }
                if let response = opResponse as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let bucketed = opBucketed {
                            var arr = [Candle]()
                            for i in 0 ..< bucketed.count {
                                let b = bucketed[i]
                                let closeTime = Date.fromBitMEXString(str: b.timestamp)!
                                if let open = b.open, var high = b.high, var low = b.low, let close = b.close, let volume = b.volume {
                                    if open > high {high = open}
                                    if close > high {high = close}
                                    if open < low {low = open}
                                    if close < low {low = close}
                                    let candle = Candle(open: open, close: close, high: high, low: low, volume: volume, timeframe: timeframe, closeTime: closeTime)
                                    arr.append(candle)
                                }
                            }
                            if partialCandle != nil && partialCandle! {
                                if !arr.isEmpty && endTime != nil {
                                    var latestCandle = arr.last!
                                    if let rev = reverse {
                                        if rev {
                                            latestCandle = arr.first!
                                        }
                                    }
                                    if latestCandle.closeTime.timeIntervalSince1970 < Date.fromBitMEXString(str: endTime!)!.timeIntervalSince1970 {
                                        downloadPartial(open: latestCandle.close, timeframe: timeframe, instrument: instrument, startTime: latestCandle.closeTime.timeIntervalSince1970, endTime: Date.fromBitMEXString(str: endTime!)!.timeIntervalSince1970) { (_candle, _response, _error) in
                                            guard _error == nil && _response != nil else { completion(nil, _response, _error); return }
                                            if (_response as! HTTPURLResponse).statusCode == 200 {
                                                if let candle = _candle {
                                                    if let rev = reverse {
                                                        if rev {
                                                            arr.insert(candle, at: 0)
                                                        } else {
                                                            arr.append(candle)
                                                        }
                                                    } else {
                                                        arr.append(candle)
                                                    }
                                                    completion(arr, _response, _error)
                                                } else {
                                                    completion(arr, _response, opError)
                                                }
                                            } else {
                                                completion(nil, _response, _error)
                                            }
                                        }
                                        
                                    } else {
                                        completion(arr, response, opError)
                                    }
                                } else {
                                    completion(arr, opResponse, nil)
                                }
                            } else {
                                completion(arr, opResponse, nil)
                            }
                        } else {
                            completion(nil, opResponse, nil)
                            return
                        }
                    } else {
                        completion(nil, opResponse, nil)
                        return
                    }
                } else {
                    completion(nil, opResponse, nil)
                    return
                }
            }

        default:
            if timeframe == .fifteenMinutes || timeframe == .thirtyMinutes {
                bucket = Timeframe.fiveMinutes
            } else if timeframe == .twoHourly || timeframe == .fourHourly || timeframe == .twelveHourly {
                bucket = Timeframe.hourly
            } else {
                bucket = Timeframe.daily
            }
            
            self.download(timeframe: bucket, instrument: instrument, partialCandle: true, reverse: true, count: count, startTime: startTime, endTime: endTime) { (opCandles, opResponse, opError) in
                guard opError == nil else {
                    completion(nil, opResponse, opError)
                    return
                }
                guard opResponse != nil else {
                    completion(nil, nil, opError)
                    return
                }
                if let response = opResponse as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let candles = opCandles {
                            var result = self.mergeCandles(candles, destinationTimeframe: timeframe)
                            if let listing = instrument.listing {
                                if let listingDate = Date.fromBitMEXString(str: listing) {
                                    if listingDate > result.last!.openTime {
                                        result.removeLast()
                                    }
                                }
                            }
                            if let partial = partialCandle {
                                if !partial && !result.isEmpty {
                                    result.removeFirst()
                                }
                            }
                            if let rev = reverse {
                                if !rev {
                                    result.reverse()
                                }
                            }
                            completion(result, opResponse, nil)
                        } else {
                            completion(nil, opResponse, nil)
                            return
                        }
                    } else {
                        completion(nil, opResponse, nil)
                        return
                    }
                } else {
                    completion(nil, opResponse, nil)
                    return
                }
            }
        }
    }
    
    
    private static func mergeCandles(_ sourceCandles: [Candle], destinationTimeframe: Timeframe) -> [Candle] {
        var result = [Candle]()
        let srcCandles: [Candle] = sourceCandles
        
        for i in 0 ..< srcCandles.count {
            let srcCandle = srcCandles[i]
            if i == 0 {
                let destCandle = Candle(open: srcCandle.open, close: srcCandle.close, high: srcCandle.high, low: srcCandle.low, volume: srcCandle.volume, timeframe: destinationTimeframe, closeTime: srcCandle.openTime.nextOpenTime(timeframe: destinationTimeframe)!)
                result.append(destCandle)
            } else {
                if srcCandle.closeTime.toMillis() <= result.last!.openTime.toMillis() {
                    let destCandle = Candle(open: srcCandle.open, close: srcCandle.close, high: srcCandle.high, low: srcCandle.low, volume: srcCandle.volume, timeframe: destinationTimeframe, closeTime: srcCandle.openTime.nextOpenTime(timeframe: destinationTimeframe)!)
                    result.append(destCandle)
                } else {
                    result.last!.open = srcCandle.open
                    if srcCandle.low < result.last!.low {
                        result.last!.low = srcCandle.low
                    }
                    if srcCandle.high > result.last!.high {
                        result.last!.high = srcCandle.high
                    }
                    result.last!.volume += srcCandle.volume
                    
                }
            }
        }
        
        return result
    }
    
    
    
    static func draw(_ candle: Candle, x: CGFloat, yo: CGFloat, yh: CGFloat, yl: CGFloat, yc: CGFloat, using ctx: CGContext, blockWidth: CGFloat, candleWidth: CGFloat, spacing: CGFloat, wickWidth: CGFloat) {

        let x0 = x
        
        if candle.high == candle.low {
            ctx.setStrokeColor(App.BullColor.cgColor)
            
            ctx.setLineWidth(0.5)
            ctx.move(to: CGPoint(x: x0 - candleWidth / 2, y: yh))
            ctx.addLine(to: CGPoint(x: x0 + candleWidth / 2, y: yh))
            
            ctx.strokePath()
            
            return
        }
        
        
        
        let isGreen = candle.isGreen()
        let color: UIColor
        if isGreen {
            color = App.BullColor
        } else {
            color = App.BearColor
        }
        
        let upperWickHeight = (isGreen ? yc : yo) - yh
        let lowerWickHeight = yl - (isGreen ? yo : yc)
        
        
        //set Stroke and Fill color:
        ctx.setStrokeColor(color.cgColor)
        ctx.setFillColor(color.cgColor)
        
        
        //draw Path:
        
        if blockWidth < 1.0 {
            let bodyPath = UIBezierPath()
            bodyPath.lineWidth = wickWidth
            bodyPath.move(to: CGPoint(x: x0, y: yh))
            bodyPath.addLine(to: CGPoint(x: x0, y: yl))
            bodyPath.close()
            bodyPath.stroke()
            return
        }
        
        
        
        let upperWickPath = UIBezierPath()
        upperWickPath.lineWidth = wickWidth
        if upperWickHeight > 0 {
            upperWickPath.move(to: CGPoint(x: x0, y: yh))
            upperWickPath.addLine(to: CGPoint(x: x0, y: isGreen ? yc : yo))
            upperWickPath.close()
            upperWickPath.stroke()
        }
        
        let lowerWickPath = UIBezierPath()
        lowerWickPath.lineWidth = wickWidth
        if lowerWickHeight > 0 {
            lowerWickPath.move(to: CGPoint(x: x0, y: isGreen ? yo : yc))
            lowerWickPath.addLine(to: CGPoint(x: x0, y: yl))
            lowerWickPath.close()
            lowerWickPath.stroke()
        }
        let bodyPath = UIBezierPath()
        bodyPath.lineWidth = wickWidth
        bodyPath.move(to: CGPoint(x: x0 - candleWidth / 2, y: isGreen ? yc : yo))
        bodyPath.addLine(to: CGPoint(x: x0 + candleWidth / 2, y: isGreen ? yc : yo))
        bodyPath.addLine(to: CGPoint(x: x0 + candleWidth / 2, y: isGreen ? yo : yc))
        bodyPath.addLine(to: CGPoint(x: x0 - candleWidth / 2, y: isGreen ? yo : yc))
        bodyPath.addLine(to: CGPoint(x: x0 - candleWidth / 2, y: isGreen ? yc : yo))
        bodyPath.close()
        
        bodyPath.stroke()
        bodyPath.fill()
        
    }
    
    
    
    
}






