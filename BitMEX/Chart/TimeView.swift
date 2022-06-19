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
        
        
        var candleInd = mostImportantCandleDateIndex()!
        let d_min = getTickAttributedString(text: "20:30").size().width * 2
        let n_min = Int(d_min / chart.blockWidth)
//        let N = visibleCandles.count / n_min
        
        while candleInd >= 0 {
            candleInd -= n_min
        }
        candleInd += n_min
        
        let N = Int((rect.width / (chart.blockWidth)) / CGFloat(n_min))
        
        var stringRects = [CGRect]()
        for i in 0...N {
            let tick = candleInd + n_min * i
            
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
    
    func mostImportantCandleDateIndex() -> Int? {
        guard let timeframe = chart?.timeframe else { return nil }
        guard let visibleCandles: [Candle] = self.visibleCandles else { return nil }
        
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
        
        
        var date: Date = visibleCandles.first!.openTime
        var i = 0
        while blockWidth! * CGFloat(i) < bounds.width {
            if i < visibleCandles.count {
                date = visibleCandles[i].openTime
            } else {
                date = date.dateBy(adding: timeframe)
            }
            let calendar = App.myCalendar
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

        if !_2y.isEmpty {
            return _2y[0]
        }
        
        if !_1y.isEmpty {
            return _1y[0]
        }
        
        if !_6M.isEmpty {
            return _6M[0]
        }
        
        if !_4M.isEmpty {
            return _4M[0]
        }
        
        if !_3M.isEmpty {
            return _3M[0]
        }
        
        if !_2M.isEmpty {
            return _2M[0]
        }
        
        if !_1M.isEmpty {
            return _1M[0]
        }
        
        if !_10d.isEmpty {
            return _10d[0]
        }
        
        if !_5d.isEmpty {
            return _5d[0]
        }
        
        if !_1d.isEmpty {
            return _1d[0]
        }
        
        if !_12h.isEmpty {
            return _12h[0]
        }
        
        if !_6h.isEmpty {
            return _6h[0]
        }
        
        if !_4h.isEmpty {
            return _4h[0]
        }
        
        if !_3h.isEmpty {
            return _3h[0]
        }
        
        if !_2h.isEmpty {
            return _2h[0]
        }
        
        if !_1h.isEmpty {
            return _1h[0]
        }
        
        if !_30m.isEmpty {
            return _30m[0]
        }
        
        if !_15m.isEmpty {
            return _15m[0]
        }
        
        if !_5m.isEmpty {
            return _5m[0]
        }
        
        if !_2m.isEmpty {
            return _2m[0]
        }
        
        if !_1m.isEmpty {
            return _1m[0]
        }
        
        return nil
        
    }
    
    
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
        
        
        var date: Date = visibleCandles.first!.openTime
        var i = 0
        while blockWidth! * CGFloat(i) < bounds.width {
            if i < visibleCandles.count {
                date = visibleCandles[i].openTime
            } else {
                date = date.dateBy(adding: timeframe)
            }
            let calendar = App.myCalendar
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
            time = visibleCandles[tick].openTime
        } else {
            time = visibleCandles.last!.openTime
            for _ in visibleCandles.count ... tick {
                time = time.dateBy(adding: timeframe)
            }
        }
        
        
        
        var text = ""
        let minute = App.myCalendar.component(.minute, from: time)
        let hour = App.myCalendar.component(.hour, from: time)
        let day = App.myCalendar.component(.day, from: time)
        let month = App.myCalendar.component(.month, from: time)
        let year = App.myCalendar.component(.year, from: time)
        
        if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) && (month == 1) {
            text = String(year)
        } else if (minute % 60 == 0) && (hour % 24 == 0) && (day == 1) {
            text = App.myCalendar.monthSymbols[month - 1]
            text = String(text[text.startIndex ..< text.index(text.startIndex, offsetBy: 3)])
        } else if (minute % 60 == 0) && (hour % 24 == 0) {
            text = String(day)
        } else if (minute % 60 == 0) {
            text = String(format: "%d:%02d", hour, minute)
        } else {
            text = String(format: "%d:%0d", hour, minute)
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
