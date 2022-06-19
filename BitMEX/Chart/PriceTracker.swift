//
//  PriceTracker.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/8/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class PriceTracker: UIView {
    
    //MARK: - Properties
    var chart: Chart? {
        return (UIApplication.shared.delegate as? AppDelegate)?.app.chart
    }
    
    var visibleCandles: [Candle]? {
        return chart?.visibleCandles.reversed()
    }
    
    var isEnabled = false
    var timer: Timer?
    var app: App!
    
    //MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.app = (UIApplication.shared.delegate as? AppDelegate)?.app
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.app = (UIApplication.shared.delegate as? AppDelegate)?.app
    }
    
    
    
    //MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isEnabled { return }
        
        guard let chart = self.chart else { return }
        if chart.CHARTSHOULDNOTBEREDRAWN { return }
        guard let visibleCandles = self.visibleCandles else { return }
        guard let priceView = chart.priceView else { return }
        guard let valueBars = chart.valueBars else { return }
        let valueBarWidth = chart.valueBarWidth
        
        let price = visibleCandles.last!.close
        let y = priceView.y(price: price, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
        
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        let path = UIBezierPath()
        let w = priceView.bounds.width
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: w, y: y))
        
        let color = (visibleCandles.last!.isGreen() ? App.BullColor : App.BearColor)
        ctx.setLineWidth(0.25)
        ctx.setLineCap(.round)
        ctx.setLineDash(phase: 0, lengths: [0.5, 0.8])
        ctx.setStrokeColor(color.cgColor)
        
        path.stroke()
        
        
        
        let str = (" " + chart.instrument!.priceFormatted(price)).asAttributedString(color: .white, textAlignment: .left)
        let strWidth = valueBarWidth - 6 > str.size().width ? valueBarWidth - 6 : str.size().width
        let strHeight = str.size().height
        let strRect = CGRect(x: rect.width - valueBarWidth + 6, y: y - strHeight / 2, width: strWidth, height: strHeight)
        let bgRect = CGRect(x: rect.width - valueBarWidth, y: y - strHeight * 0.75, width: valueBarWidth, height: strHeight * 1.5)
        ctx.setFillColor(color.cgColor)
        ctx.fill(bgRect)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.strokeLineSegments(between: [CGPoint(x: valueBars.frame.origin.x, y: y), CGPoint(x: valueBars.frame.origin.x + 6, y: y)])
        str.draw(in: strRect)
        
        
        if chart.timeframe == .daily || chart.timeframe == .weekly || chart.timeframe == .monthly {
            return
        }
        let time = app.game.currentTime
        let calendar = App.myCalendar
        let toTime = self.app.game.currentTime.nextOpenTime(timeframe: chart.timeframe!)!
        let comps = calendar.dateComponents([.hour, .minute, .second], from: time, to: toTime)
        var hour = comps.hour ?? 0
        var minute = comps.minute ?? 0
        var second = comps.second ?? 0
        
        if hour < 0 || minute < 0 || second < 0 {
            hour = 0
            minute = 0
            second = 0
        }
        let hourStr = String(format: "%02d", hour)
        let minuteStr = String(format: "%02d", minute)
        let secondStr = String(format:"%02d", second)
        
        var timeString: String?
        switch chart.timeframe {
        case .oneMinute, .fiveMinutes, .fifteenMinutes, .thirtyMinutes, .hourly:
            timeString = minuteStr + ":" + secondStr
        case .twoHourly, .fourHourly, .twelveHourly, .daily:
            if hour == 0 {
                timeString = minuteStr + ":" + secondStr
            } else {
                timeString = hourStr + ":" + minuteStr + ":" + secondStr
            }
            
        default:
            break
        }
        
        if let string = timeString {
            let s = ("" + string).asAttributedString(color: .white, textAlignment: .center)
            let sWidth = valueBarWidth - 6 > s.size().width ? valueBarWidth - 6 : s.size().width
            let sHeight = s.size().height
            
            let sRect = CGRect(x: rect.width - valueBarWidth + 6, y: y + strHeight * 0.75 + sHeight * 0.25, width: sWidth, height: sHeight)
            let bgRect = CGRect(x: rect.width - valueBarWidth, y: y + strHeight * 0.75, width: chart.valueBarWidth, height: sHeight * 1.5)
            ctx.setFillColor(color.cgColor)
            ctx.fill(bgRect)
            s.draw(in: sRect)
        }
        
        
    }
    
    
    func redraw() {
        setNeedsDisplay()
    }
    
    
}
