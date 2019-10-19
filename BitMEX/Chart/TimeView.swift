//
//  TimeView.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/1/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class TimeView: UIView {
    //MARK: - Properties
    var chart: Chart? {
        return (UIApplication.shared.delegate as? AppDelegate)?.app.chart
    }
    
    var verticalGridLines = [CGFloat]()
    
    private var ticks = [Int]()
    private var blockWidth: CGFloat? {
        return chart?.blockWidth
    }
    private var visibleCandles: [Candle]? {
        return chart?.visibleCandles.reversed()
    }
    
    
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        clipsToBounds = true
    }
    
    
    
    //MARK: - DRAW
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let chart = self.chart else { return }
        if chart.CHARTSHOULDNOTBEREDRAWN { return }
        guard chart.timeframe != nil else { return }
        guard let visibleCandles: [Candle] = self.visibleCandles else { return }
        if visibleCandles.isEmpty { return }
        
        
        verticalGridLines.removeAll()
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        findTicks()
        
        var stringRects = [CGRect]()
        for tick in ticks {
            var x: CGFloat
            if tick < visibleCandles.count {
                x = visibleCandles[tick].x
            } else {
                x = visibleCandles.last!.x + CGFloat(tick - visibleCandles.count + 1) * blockWidth!
            }
            
            let string = getTickAttributedString(text: tickToText(tick: tick))
            let stringSize = string.size()
            let stringRect = CGRect(x: x - stringSize.width / 2, y: stringSize.height, width: stringSize.width, height: stringSize.height)
            var enoughSpaceToAddTick = true
            for r in stringRects {
                let r1 = CGRect(x: r.origin.x - r.width / 2, y: r.origin.y, width: r.width * 2, height: r.height)
                if r1.intersects(stringRect) {
                    enoughSpaceToAddTick = false
                    break
                }
            }

            if !enoughSpaceToAddTick { continue }
            
            stringRects.append(stringRect)
            
            ctx.setStrokeColor(UIColor.black.cgColor)
            ctx.strokeLineSegments(between: [CGPoint(x: x, y: 0), CGPoint(x: x, y: stringSize.height * 0.6)])
            
            string.draw(in: stringRect)
            verticalGridLines.append(x)
        }
//        ctx.setLineWidth(2.0)
//        ctx.strokeLineSegments(between: [CGPoint(x: rect.width, y: 0), CGPoint(x: rect.width, y: rect.height)])
    }
    
    func redraw() {
        self.setNeedsDisplay()
    }
    
    
    
//    func processAllCandlesOpenTimes() {
//        guard let timeframe = chart?.timeframe else { return }
//        guard let candles: [Candle] = chart?.candles else { return }
//        
//        var date: Date = candles.first!.openTime
//        var i = 0
//        while blockWidth! * CGFloat(i) < bounds.width {
//            if i < candles.count {
//                date = candles[i].openTime
//            } else {
//                date = date.nextCandleOpenTime(timeframe: timeframe)
//            }
//            let calendar = Calendar(identifier: .gregorian)
//            let minute = calendar.component(.minute, from: date)
//            let hour = calendar.component(.hour, from: date)
//            let day = calendar.component(.day, from: date)
//            let month = calendar.component(.month, from: date)
//            let year = calendar.component(.year, from: date)
//            let weekDay = calendar.component(.weekday, from: date)
//            let weekOfMonth = calendar.component(.weekOfMonth, from: date)
//            
//            
//            //2 yr
//            if (year % 2 == 0) && (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1) {
//                _2y.append(i)
//            }
//            //1 yr
//            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1) {
//                _1y.append(i)
//            }
//            //6M
//            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1 || month == 7) {
//                _6M.append(i)
//            }
//            //4M
//            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1 || month == 5 || month == 9) {
//                _4M.append(i)
//            }
//            //3M
//            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1 || month == 4 || month == 7 || month == 10) {
//                _3M.append(i)
//            }
//            //2M
//            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1 || month == 3 || month == 5 || month == 7 || month == 9 || month == 11) {
//                _2M.append(i)
//            }
//            //1M
//            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) {
//                _1M.append(i)
//            }
//            //2w
//            if (minute % 60 == 0) && (hour % 24 == 0) && (weekDay == 2) && (weekOfMonth % 2 == 1) {
//                _2w.append(i)
//            }
//            //1w
//            if (minute % 60 == 0) && (hour % 24 == 0) && (weekDay == 2) {
//                _1w.append(i)
//            }
//            //10d
//            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1 || day == 11 || day == 21) {
//                _10d.append(i)
//            }
//            //5d
//            if (minute % 60 == 0) && (hour % 24 == 0) && (day % 5 == 1) {
//                _5d.append(i)
//            }
//            //1d
//            if (minute % 60 == 0) && (hour % 24 == 0) {
//                _1d.append(i)
//            }
//            //12h
//            if (minute % 60 == 0) && (hour % 12 == 0)  {
//                _12h.append(i)
//            }
//            //6h
//            if (minute % 60 == 0) && (hour % 6 == 0)  {
//                _6h.append(i)
//            }
//            //4h
//            if (minute % 60 == 0) && (hour % 4 == 0)  {
//                _4h.append(i)
//            }
//            //3h
//            if (minute % 60 == 0) && (hour % 3 == 0)  {
//                _3h.append(i)
//            }
//            //2h
//            if (minute % 60 == 0) && (hour % 2 == 0)  {
//                _2h.append(i)
//            }
//            //1h
//            if (minute % 60 == 0)  {
//                _1h.append(i)
//            }
//            //30m
//            if (minute % 30 == 0)  {
//                _30m.append(i)
//            }
//            //15m
//            if (minute % 15 == 0)  {
//                _15m.append(i)
//            }
//            //10m
//            if (minute % 10 == 0)  {
//                _10m.append(i)
//            }
//            //5m
//            if (minute % 5 == 0)  {
//                _5m.append(i)
//            }
//            //3m
//            if (minute % 3 == 0)  {
//                _3m.append(i)
//            }
//            //2m
//            if (minute % 2 == 0)  {
//                _2m.append(i)
//            }
//            //1m
//            _1m.append(i)
//            i += 1
//        }
//    }
    
    
    func findTicks() {
        guard let timeframe = chart?.timeframe else { return }

        ticks.removeAll()
        
        guard let visibleCandles: [Candle] = self.visibleCandles else { return }
        
        var _2y = [Int]()
        var _1y = [Int]()
        var _6M = [Int]()
        var _4M = [Int]()
        var _3M = [Int]()
        var _2M = [Int]()
        var _1M = [Int]()
        var _2w = [Int]()
        var _1w = [Int]()
        var _10d = [Int]()
        var _5d = [Int]()
        var _1d = [Int]()
        var _12h = [Int]()
        var _6h = [Int]()
        var _4h = [Int]()
        var _3h = [Int]()
        var _2h = [Int]()
        var _1h = [Int]()
        var _30m = [Int]()
        var _15m = [Int]()
        var _10m = [Int]()
        var _5m = [Int]()
        var _3m = [Int]()
        var _2m = [Int]()
        var _1m = [Int]()
        
        
        var date: Date = visibleCandles.first!.openTime.localToUTC()
        var i = 0
        while blockWidth! * CGFloat(i) < bounds.width {
            if i < visibleCandles.count {
                date = visibleCandles[i].openTime.localToUTC()
            } else {
                date = date.dateBy(adding: timeframe)
            }
            let calendar = Calendar.current
            let minute = calendar.component(.minute, from: date)
            let hour = calendar.component(.hour, from: date)
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            let weekDay = calendar.component(.weekday, from: date)
            let weekOfMonth = calendar.component(.weekOfMonth, from: date)
            
            
            //2 yr
            if (year % 2 == 0) && (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1) {
                _2y.append(i)
            }
            //1 yr
            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1) {
                _1y.append(i)
            }
            //6M
            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1 || month == 7) {
                _6M.append(i)
            }
            //4M
            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1 || month == 5 || month == 9) {
                _4M.append(i)
            }
            //3M
            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1 || month == 4 || month == 7 || month == 10) {
                _3M.append(i)
            }
            //2M
            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1 || month == 3 || month == 5 || month == 7 || month == 9 || month == 11) {
                _2M.append(i)
            }
            //1M
            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) {
                _1M.append(i)
            }
            //2w
            if (minute % 60 == 0) && (hour % 24 == 0) && (weekDay == 2) && (weekOfMonth % 2 == 1) {
                _2w.append(i)
            }
            //1w
            if (minute % 60 == 0) && (hour % 24 == 0) && (weekDay == 2) {
                _1w.append(i)
            }
            //10d
            if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1 || day == 11 || day == 21) {
                _10d.append(i)
            }
            //5d
            if (minute % 60 == 0) && (hour % 24 == 0) && (day % 5 == 1) {
                _5d.append(i)
            }
            //1d
            if (minute % 60 == 0) && (hour % 24 == 0) {
                _1d.append(i)
            }
            //12h
            if (minute % 60 == 0) && (hour % 12 == 0)  {
                _12h.append(i)
            }
            //6h
            if (minute % 60 == 0) && (hour % 6 == 0)  {
                _6h.append(i)
            }
            //4h
            if (minute % 60 == 0) && (hour % 4 == 0)  {
                _4h.append(i)
            }
            //3h
            if (minute % 60 == 0) && (hour % 3 == 0)  {
                _3h.append(i)
            }
            //2h
            if (minute % 60 == 0) && (hour % 2 == 0)  {
                _2h.append(i)
            }
            //1h
            if (minute % 60 == 0)  {
                _1h.append(i)
            }
            //30m
            if (minute % 30 == 0)  {
                _30m.append(i)
            }
            //15m
            if (minute % 15 == 0)  {
                _15m.append(i)
            }
            //10m
            if (minute % 10 == 0)  {
                _10m.append(i)
            }
            //5m
            if (minute % 5 == 0)  {
                _5m.append(i)
            }
            //3m
            if (minute % 3 == 0)  {
                _3m.append(i)
            }
            //2m
            if (minute % 2 == 0)  {
                _2m.append(i)
            }
            //1m
            _1m.append(i)
            i += 1
        }
        
        var arr = [[Int]]()

        switch timeframe {
        case .oneMinute:
            arr.append(_1m)
            arr.append(_2m)
            fallthrough

        case .fiveMinutes:
            arr.append(_5m)
            arr.append(_10m)
            fallthrough
            
        case .fifteenMinutes:
            arr.append(_15m)
            fallthrough
            
        case .thirtyMinutes:
            arr.append(_30m)
            fallthrough
            
        case .hourly:
            arr.append(_1h)
            fallthrough
            
        case .twoHourly:
            arr.append(_2h)
            fallthrough
            
        case .fourHourly:
            arr.append(_4h)
            fallthrough
            
        case .twelveHourly:
            arr.append(_12h)
            fallthrough
            
        case .daily:
            arr.append(_1d)
            arr.append(_5d)
            arr.append(_10d)
            arr.append(_1M)
            arr.append(_2M)
            arr.append(_3M)
            arr.append(_6M)
            arr.append(_1y)
            arr.append(_2y)
            // do not fallthrough
        case .weekly:
            arr.append(_1w)
            arr.append(_2w)
            fallthrough
            
        case .monthly:
            arr.append(_1M)
            arr.append(_2M)
            arr.append(_3M)
            arr.append(_6M)
            arr.append(_1y)
            arr.append(_2y)
        }
        
        let minDistance = getTickAttributedString(text: "19:30").size().width * 1.5
        
        let maxCount = Int(bounds.width / minDistance)
        
        var tickCollectionIndex = 0
        for i in 0 ..< arr.count {
            if arr[i].count < maxCount {
                tickCollectionIndex = i
                break
            }
        }
        
        ticks = arr[tickCollectionIndex]
        
    }
    
    
    
   
    
    func tickToText(tick: Int) -> String {
        guard let timeframe = chart?.timeframe else { return "" }
        guard let visibleCandles: [Candle] = self.visibleCandles else { return ""}
        
        var time: Date
        if tick < visibleCandles.count {
            time = visibleCandles[tick].openTime.localToUTC()
        } else {
            time = visibleCandles.last!.openTime.localToUTC()
            for _ in visibleCandles.count ... tick {
                time = time.dateBy(adding: timeframe)
            }
        }
        
        
        let timeLocal = time.utcToLocal()
        var text = ""
        let minute = Calendar.current.component(.minute, from: time)
        let hour = Calendar.current.component(.hour, from: time)
        let day = Calendar.current.component(.day, from: time)
        let month = Calendar.current.component(.month, from: time)
        
        let dayL = Calendar.current.component(.day, from: timeLocal)
        let monthL = Calendar.current.component(.month, from: timeLocal)
        let yearL = Calendar.current.component(.year, from: timeLocal)
        let minuteL = Calendar.current.component(.minute, from: timeLocal)
        let hourL = Calendar.current.component(.hour, from: timeLocal)
        
        if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1) {
            text = String(yearL)
        } else if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) {
            text = Calendar.current.monthSymbols[monthL - 1]
            text = String(text[text.startIndex ..< text.index(text.startIndex, offsetBy: 3)])
        } else if (minute % 60 == 0) && (hour % 24 == 0) {
            text = String(dayL)
        } else if (minute % 60 == 0) {
            text = "\(hourL):\(minuteL)"
        } else {
            text = "\(hourL):\(minuteL)"
        }
        return text
    }
    
    
    
    
    func getTickAttributedString(text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let string = NSAttributedString(string: text, attributes: attributes)
        return string
    }
    
    
    static func getHeight() -> CGFloat {
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//
//        let attributes = [
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0),
//            NSAttributedString.Key.foregroundColor: UIColor.black
//        ]
//
//        let string = NSAttributedString(string: "M2y", attributes: attributes)
        return 40.0
    }
    
    
    // All Candles Open Times divisble by below timespans:
    
}
