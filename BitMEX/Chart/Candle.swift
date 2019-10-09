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
    
    static func downloadFor(timeframe: Timeframe, instrument: Instrument, partialCandle: Bool? = nil, reverse: Bool? = nil, count: Int? = nil, startTime: String? = nil, endTime: String? = nil, completion: @escaping ([Candle]?, URLResponse?, Error?) -> Void) {
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
                            for b in bucketed {
                                let closeTime = Date.fromBitMEXString(str: b.timestamp)!
                                if let open = b.open, let high = b.high, let low = b.low, let close = b.close, let volume = b.volume {
                                    let candle = Candle(open: open, close: close, high: high, low: low, volume: volume, timeframe: timeframe, closeTime: closeTime)
                                    arr.append(candle)
                                }
                            }
                            completion(arr, opResponse, nil)
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
            
            self.downloadFor(timeframe: bucket, instrument: instrument, partialCandle: true, reverse: true, count: count, startTime: startTime, endTime: endTime) { (opCandles, opResponse, opError) in
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
    
    
    
    
}






