//
//  Tools.swift
//  BitMEX
//
//  Created by Behnam Karimi on 8/30/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit
import os.log

class HorizontalLine: NSObject, NSCoding {
    init(price: Double, timeframe: Timeframe, color: UIColor = .blue, lineWidth: CGFloat = 1.0) {
        self.price = price
        self.timeframe = timeframe
        self.color = color
        self.lineWidth = lineWidth
        
    }
    
    var price: Double
    var timeframe: Timeframe
    var color: UIColor = .blue
    var lineWidth: CGFloat = 1.0
    
    
    //MARK: - NSCoding
    private struct Key {
        static let price = "HorizontalLine.price"
        static let timeframe = "HorizontalLine.timeframe"
        static let color = "HorizontalLine.color"
        static let lineWidth = "HorizontalLine.lineWidth"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(price, forKey: Key.price)
        aCoder.encode(timeframe, forKey: Key.timeframe)
        aCoder.encode(color, forKey: Key.color)
        aCoder.encode(lineWidth, forKey: Key.lineWidth)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let price = aDecoder.decodeObject(forKey: Key.price) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let timeframe = aDecoder.decodeObject(forKey: Key.timeframe) as? String else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let color = aDecoder.decodeObject(forKey: Key.color) as? UIColor else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let lineWidth = aDecoder.decodeObject(forKey: Key.lineWidth) as? CGFloat else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(price: price, timeframe: Timeframe(rawValue: timeframe)!, color: color, lineWidth: lineWidth)
    }
}

class Trendline: NSObject, NSCoding  {
    init(start: (Date, Double), end: (Date, Double), timeframe: Timeframe, color: UIColor = .blue, lineWidth: CGFloat = 1.0) {
        self.start = start
        self.end = end
        self.timeframe = timeframe
        self.color = color
        self.lineWidth = lineWidth
        
    }
    
    var start: (Date, Double) // (time, price)
    var end: (Date, Double)
    var timeframe: Timeframe
    var color: UIColor = .blue
    var lineWidth: CGFloat = 1.0
    
    //MARK: - NSCoding
    private struct Key {
        static let startDate = "Trendline.startDate"
        static let startPrice = "Trendline.startPrice"
        static let endDate = "Trendline.endDate"
        static let endPrice = "Trendline.endPrice"
        static let timeframe = "Trendline.timeframe"
        static let color = "Trendline.color"
        static let lineWidth = "Trendline.lineWidth"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(start.0, forKey: Key.startDate)
        aCoder.encode(start.1, forKey: Key.startPrice)
        aCoder.encode(end.0, forKey: Key.endDate)
        aCoder.encode(end.1, forKey: Key.endPrice)
        aCoder.encode(timeframe, forKey: Key.timeframe)
        aCoder.encode(color, forKey: Key.color)
        aCoder.encode(lineWidth, forKey: Key.lineWidth)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let startDate = aDecoder.decodeObject(forKey: Key.startDate) as? Date else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let startPrice = aDecoder.decodeObject(forKey: Key.startPrice) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let endDate = aDecoder.decodeObject(forKey: Key.endDate) as? Date else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let endPrice = aDecoder.decodeObject(forKey: Key.endPrice) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let timeframe = aDecoder.decodeObject(forKey: Key.timeframe) as? String else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let color = aDecoder.decodeObject(forKey: Key.color) as? UIColor else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let lineWidth = aDecoder.decodeObject(forKey: Key.lineWidth) as? CGFloat else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(start: (startDate, startPrice), end: (endDate, endPrice), timeframe: Timeframe(rawValue: timeframe)!, color: color, lineWidth: lineWidth)
    }
}

class FibRetracement: NSObject, NSCoding  {
    init(start: (Date, Double), end: (Date, Double), levels: [Double] = [Levels._0, Levels._1, Levels._0_618], timeframe: Timeframe, color: UIColor = .blue, lineWidth: CGFloat = 1.0) {
        self.start = start
        self.end = end
        self.timeframe = timeframe
        self.color = color
        self.lineWidth = lineWidth
        self.levels = levels
    }
    
    
    var start: (Date, Double) // (time, price)
    var end: (Date, Double)
    var levels: [Double] = [Levels._0, Levels._1, Levels._0_618]
    var timeframe: Timeframe
    var color: UIColor = .blue
    var lineWidth: CGFloat = 1.0
    
    
    
    struct Levels {
        static func all() -> [Double] {
            return [_0, _0_236, _0_382, _0_5, _0_618, _0_786, _1, _1_272, _1_414, _1_618, _2, _2_272, _2_414, _2_618, _3, _3_272, _3_414, _3_618, _4, _4_272, _4_414, _4_618, _4_764]
        }
        static let _0: Double = 0.0
        static let _0_236: Double = 0.236
        static let _0_382: Double = 0.382
        static let _0_5: Double = 0.5
        static let _0_618: Double = 0.618
        static let _0_786: Double = 0.786
        static let _1: Double = 1
        static let _1_272: Double = 1.272
        static let _1_414: Double = 1.414
        static let _1_618: Double = 1.618
        static let _2: Double = 2
        static let _2_272: Double = 2.272
        static let _2_414: Double = 2.414
        static let _2_618: Double = 2.618
        static let _3: Double = 3
        static let _3_272: Double = 3.272
        static let _3_414: Double = 3.414
        static let _3_618: Double = 3.618
        static let _4: Double = 4
        static let _4_272: Double = 4.272
        static let _4_414: Double = 4.414
        static let _4_618: Double = 4.618
        static let _4_764: Double = 4.764
    }
    
    
    //MARK: - NSCoding
    private struct Key {
        static let startDate = "FibRetracement.startDate"
        static let startPrice = "FibRetracement.startPrice"
        static let endDate = "FibRetracement.endDate"
        static let endPrice = "FibRetracement.endPrice"
        static let levels = "FibRetracement.levels"
        static let timeframe = "FibRetracement.timeframe"
        static let color = "FibRetracement.color"
        static let lineWidth = "FibRetracement.lineWidth"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(start.0, forKey: Key.startDate)
        aCoder.encode(start.1, forKey: Key.startPrice)
        aCoder.encode(end.0, forKey: Key.endDate)
        aCoder.encode(end.1, forKey: Key.endPrice)
        aCoder.encode(levels, forKey: Key.levels)
        aCoder.encode(timeframe, forKey: Key.timeframe)
        aCoder.encode(color, forKey: Key.color)
        aCoder.encode(lineWidth, forKey: Key.lineWidth)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let startDate = aDecoder.decodeObject(forKey: Key.startDate) as? Date else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let startPrice = aDecoder.decodeObject(forKey: Key.startPrice) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let endDate = aDecoder.decodeObject(forKey: Key.endDate) as? Date else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let endPrice = aDecoder.decodeObject(forKey: Key.endPrice) as? Double else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let levels = aDecoder.decodeObject(forKey: Key.levels) as? [Double] else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let timeframe = aDecoder.decodeObject(forKey: Key.timeframe) as? String else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let color = aDecoder.decodeObject(forKey: Key.color) as? UIColor else {
            os_log("Unable to decode the qty for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let lineWidth = aDecoder.decodeObject(forKey: Key.lineWidth) as? CGFloat else {
            os_log("Unable to decode the price for a Game object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(start: (startDate, startPrice), end: (endDate, endPrice), levels: levels, timeframe: Timeframe(rawValue: timeframe)!, color: color, lineWidth: lineWidth)
    }
}
