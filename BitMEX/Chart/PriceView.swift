//
//  PriceView.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/1/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

import UIKit

class PriceView: UIView {
    //MARK: - Properties
    var chart: Chart? {
        return (UIApplication.shared.delegate as? AppDelegate)?.app.chart
    }
    
    
    var newestVisibleCandleIndex = 0
    var oldestVisibleCandleIndex = 0
    
    
    var valueBar: ValueBar?
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        clipsToBounds = true
    }
    
    
    //MARK: - Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard self.chart != nil else { return }
        if chart!.CHARTSHOULDNOTBEREDRAWN { return }
        guard let instrument = self.instrument else { return }
        guard let timeframe = self.timeframe else { return }
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setLineWidth(2.0)
        ctx.strokeLineSegments(between: [CGPoint(x: 0, y: 0), CGPoint(x: rect.width, y: 0)])
        ctx.setLineWidth(1.0)
        
        if !visibleCandles.isEmpty {
            for candle in visibleCandles {
                let y = self.y(price: candle.high, highestPrice: highestPrice, lowestPrice: lowestPrice, topMargin: chart!.topMargin, bottomMargin: chart!.bottomMargin, logScale: app.settings.chartLogScale)
                let h = self.y(price: candle.low, highestPrice: highestPrice, lowestPrice: lowestPrice, topMargin: chart!.topMargin, bottomMargin: chart!.bottomMargin, logScale: app.settings.chartLogScale) - y
                
                let blockWidth = candleWidth + spacing
                if candle.high == candle.low {
                    draw(candle: candle, in: CGRect(x: candle.x - blockWidth / 2, y: y, width: blockWidth, height: wickWidth), using: ctx)
                } else {
                    draw(candle: candle, in: CGRect(x: candle.x - blockWidth / 2, y: y, width: blockWidth, height: h), using: ctx)
                }
            }
        }
        
        //Draw Title:
        if !app.settings.showTitles {
            return
        }
        let titleString = (instrument.symbol + "  " + timeframe.rawValue).asAttributedString()
        let stringSize = titleString.size()
        let stringRect = CGRect(x: 5, y: 5, width: stringSize.width, height: stringSize.height)
        titleString.draw(in: stringRect)

    }
    
    
    
    //MARK: - Update View
    func redraw() {
        setNeedsDisplay()
    }
    
    
    
    
    
    //MARK: - Private Methods
    
    private func draw(candle: Candle, in rect: CGRect, using ctx: CGContext) {
        let candleHeight = rect.height
        
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setLineWidth(0)
        if candle.high == candle.low {
            ctx.setFillColor(App.BullColor.cgColor)
            ctx.setStrokeColor(App.BullColor.cgColor)
            ctx.fill(CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y, width: candleWidth, height: candleHeight))
            ctx.stroke(CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y, width: candleWidth, height: candleHeight))
            return
        }
        
        
        
        let isGreen = (candle.close >= candle.open)
        let color: UIColor
        if isGreen {
            color = App.BullColor
        } else {
            color = App.BearColor
        }
        
        
        var bodyHeight = CGFloat((candle.close - candle.open) / (candle.high - candle.low)) * candleHeight
        if !isGreen {
            bodyHeight = -bodyHeight
        }
        if bodyHeight < wickWidth {
            bodyHeight = wickWidth
        }
        
        
        let upperWickHeight = CGFloat((candle.high - (isGreen ? candle.close : candle.open)) / (candle.high - candle.low)) * candleHeight
        let lowerWickHeight = candleHeight - upperWickHeight - bodyHeight
        
        
        
        ctx.setStrokeColor(color.cgColor)
        ctx.setFillColor(color.cgColor)
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)
        if upperWickHeight > 0 {
            ctx.fill(CGRect(x: spacing / 2 + rect.origin.x + candleWidth / 2 - wickWidth / 2, y: rect.origin.y, width: wickWidth, height: upperWickHeight))
            ctx.stroke(CGRect(x: spacing / 2 + rect.origin.x + candleWidth / 2 - wickWidth / 2, y: rect.origin.y, width: wickWidth, height: upperWickHeight))
        }
        ctx.fill(CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y + upperWickHeight, width: candleWidth, height: bodyHeight))
        ctx.stroke(CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y + upperWickHeight, width: candleWidth, height: bodyHeight))
        if lowerWickHeight > 0 {
            ctx.fill(CGRect(x: spacing / 2 + rect.origin.x + candleWidth / 2 - wickWidth / 2, y: rect.origin.y + upperWickHeight + bodyHeight, width: wickWidth, height: lowerWickHeight))
            ctx.stroke(CGRect(x: spacing / 2 + rect.origin.x + candleWidth / 2 - wickWidth / 2, y: rect.origin.y + upperWickHeight + bodyHeight, width: wickWidth, height: lowerWickHeight))
        }
        
        
        
    }
    
    private func drawRounded(candle: Candle, in rect: CGRect, using ctx: CGContext) {
        let candleHeight = rect.height
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setLineWidth(0)
        if candle.high == candle.low {
            ctx.setFillColor(App.BullColor.cgColor)
            ctx.setStrokeColor(App.BullColor.cgColor)
            ctx.fill(CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y, width: candleWidth, height: candleHeight))
            ctx.stroke(CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y, width: candleWidth, height: candleHeight))
            return
        }
        
        
        
        let isGreen = (candle.close >= candle.open)
        let color: UIColor
        if isGreen {
            color = App.BullColor
        } else {
            color = App.BearColor
        }
        
        
        var bodyHeight = CGFloat((candle.close - candle.open) / (candle.high - candle.low)) * candleHeight
        if !isGreen {
            bodyHeight = -bodyHeight
        }
        if bodyHeight < wickWidth {
            bodyHeight = wickWidth
        }
        
        
        let upperWickHeight = CGFloat((candle.high - (isGreen ? candle.close : candle.open)) / (candle.high - candle.low)) * candleHeight
        let lowerWickHeight = candleHeight - upperWickHeight - bodyHeight
        
        
        
        
        ctx.setStrokeColor(color.cgColor)
        ctx.setFillColor(color.cgColor)
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)
        if upperWickHeight > 0 {
            ctx.fill(CGRect(x: spacing / 2 + rect.origin.x + candleWidth / 2 - wickWidth / 2, y: rect.origin.y, width: wickWidth, height: upperWickHeight))
            ctx.stroke(CGRect(x: spacing / 2 + rect.origin.x + candleWidth / 2 - wickWidth / 2, y: rect.origin.y, width: wickWidth, height: upperWickHeight))
        }
        
        let bodyPath = UIBezierPath(roundedRect: CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y + upperWickHeight, width: candleWidth, height: bodyHeight), cornerRadius: candleWidth / 5)
        ctx.beginPath()
        ctx.addPath(bodyPath.cgPath)
        ctx.fillPath()
        ctx.strokePath()
//        ctx.fill(CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y + upperWickHeight, width: candleWidth, height: bodyHeight))
//        ctx.stroke(CGRect(x: spacing / 2 + rect.origin.x, y: rect.origin.y + upperWickHeight, width: candleWidth, height: bodyHeight))
        if lowerWickHeight > 0 {
            ctx.fill(CGRect(x: spacing / 2 + rect.origin.x + candleWidth / 2 - wickWidth / 2, y: rect.origin.y + upperWickHeight + bodyHeight, width: wickWidth, height: lowerWickHeight))
            ctx.stroke(CGRect(x: spacing / 2 + rect.origin.x + candleWidth / 2 - wickWidth / 2, y: rect.origin.y + upperWickHeight + bodyHeight, width: wickWidth, height: lowerWickHeight))
        }
        
        
        
    }
    
    
    
    
    private func getAttString(text: String, color: UIColor) -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0),
            NSAttributedString.Key.foregroundColor: color
        ]
        
        let string = NSAttributedString(string: text, attributes: attributes)
        return string
    }
    
    private func getMutableAttString(text: String, color: UIColor) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 11.0),
            .foregroundColor: color,
        ]
        
        let string = NSMutableAttributedString(string: text, attributes: attributes)
        return string
    }
    
    func processVisibleCandles() {
        guard let chart = self.chart else { return }
        guard !candles.isEmpty else { return }
        
        visibleCandles.removeAll()
        calculateNewestVisibleCandleIndex()
        if newestVisibleCandleIndex < 0 {
            return
        }
        
        
        let auto = chart.autoScale
        if auto {
            highestPrice = -Double.greatestFiniteMagnitude
            lowestPrice = Double.greatestFiniteMagnitude
        }
        
        
        for i in newestVisibleCandleIndex ... oldestVisibleCandleIndex {
            let candle = candles[i]
            let x = newestCandleX - (candleWidth + spacing) * CGFloat(i)
            candle.x = x
            if auto {
                if candle.high > highestPrice {
                    highestPrice = candle.high
                }
                if candle.low < lowestPrice {
                    lowestPrice = candle.low
                }
                
//                for indicator in chart.indicators {
//                    if indicator.getRow() != 0 { continue }
//                    if indicator.indicatorType != .sma && indicator.indicatorType != .ema { continue }
//                    let indicatorValue = (indicator.indicatorValue[candle.openTime] as! Decimal).doubleValue
//                    if indicatorValue <= 0 { continue }
//                    if indicatorValue > highestPrice {
//                        highestPrice = indicatorValue
//                    }
//                    if indicatorValue < lowestPrice {
//                        lowestPrice = indicatorValue
//                    }
//                    
//                }
            }
            visibleCandles.append(candle)
        }
        
        if candles[oldestVisibleCandleIndex].x - chart.blockWidth > 0 {
            chart.downloadOlderCandles()
        }
    }
    
    
    private func calculateNewestVisibleCandleIndex() {
        let w = frame.width
        
        if newestCandleX - candleWidth / 2 <= w && newestCandleX + candleWidth / 2 >= 0 {
            newestVisibleCandleIndex = 0
            let numberOfVisibleCandles = Int(newestCandleX / (candleWidth + spacing)) + 1
            oldestVisibleCandleIndex = newestVisibleCandleIndex + numberOfVisibleCandles
        } else if newestCandleX + candleWidth / 2 < 0 {
            newestVisibleCandleIndex = -1
            oldestVisibleCandleIndex = -1
        } else {
            let dx = newestCandleX - w
            let n = Int(dx / (candleWidth + spacing))
            newestVisibleCandleIndex = n + 1
            let numberOfVisibleCandles = Int(w / (candleWidth + spacing)) + 1
            oldestVisibleCandleIndex = newestVisibleCandleIndex + numberOfVisibleCandles
        }
        
        if oldestVisibleCandleIndex > candles.count - 1 {
            oldestVisibleCandleIndex = candles.count - 1
        }
    }
    
    
    //MARK: Fields
    var instrument: Instrument? {
        return chart?.instrument
    }
    var timeframe: Timeframe? {
        return chart?.timeframe
    }
    var visibleCandles: [Candle] {
        get {
            return chart!.visibleCandles
        }
        set {
            chart!.visibleCandles = newValue
        }
    }
    var candles: [Candle] {
        return chart!.candles
    }
    var highestPrice: Double {
        get {
            return chart!.highestPrice
        }
        set {
            chart!.highestPrice = newValue
        }
    }
    var lowestPrice: Double {
        get {
            return chart!.lowestPrice
        }
        set {
            chart!.lowestPrice = newValue
        }
    }
    
    var spacing: CGFloat {
        return chart!.spacing
    }
    var candleWidth: CGFloat {
        return chart!.candleWidth
    }
    var wickWidth: CGFloat {
        return chart!.wickWidth
    }
    
    var newestCandleX: CGFloat {
        return chart!.newestCandleX
    }
    
    
    
    var app: App! {
        return chart?.app
    }
    
    
    
}
