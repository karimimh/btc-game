//
//  IndicatorView.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/1/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class IndicatorView: UIView {
    //MARK: - Properties
    var chart: Chart?
    var valueBar: ValueBar!
    var app: App! {
        return (UIApplication.shared.delegate as? AppDelegate)!.app
    }
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented!")
    }
    
    init(chart: Chart, indicator: Indicator) {
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = true
        self.chart = chart
        self.indicator = indicator
        
        indicator.computeValue(candles: chart.candles.reversed().self)
        if indicator.getRow() == 0 {
            valueBar = nil
        } else if let systemName = Indicator.SystemName(rawValue: indicator.name) {
            switch systemName {
            case .volume:
                var highestVolume: Decimal = 0
                for candle in visibleCandles {
                    if candle.volume.decimalValue > highestVolume {
                        highestVolume = candle.volume.decimalValue
                    }
                }
                if highestVolume == 0 {
                    return
                }
                valueBar = ValueBar(chart: chart, highestValue: highestVolume, lowestValue: 0, tickSize: Decimal(chart.instrument!.lotSize!))
            case .ma:
                valueBar = ValueBar(chart: chart, highestValue: Decimal(chart.highestPrice), lowestValue: Decimal(chart.lowestPrice), tickSize: Decimal(chart.instrument!.tickSize!))
            case .rsi:
                valueBar = ValueBar(chart: chart, highestValue: 100, lowestValue: 0, tickSize: -1.0, requiredTickPrices: [30, 70], precision: 2)
            }
        }
        
        if indicator.getRow() == 0 {
            isUserInteractionEnabled = false
        }
    }
    
    
    
    //MARK: - Update View
    func redraw() {
        setNeedsDisplay()
    }
    
    
    
    //MARK: - Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard self.chart != nil, self.indicator != nil else { return }
        if chart!.CHARTSHOULDNOTBEREDRAWN { return }
        let ctx = UIGraphicsGetCurrentContext()!
        
        if let systemName = Indicator.SystemName(rawValue: indicator.name) {
            switch systemName {
            case .volume:
                drawVolume(in: rect, using: ctx)
            case .ma:
                drawMA(in: rect, using: ctx)
            case .rsi:
                drawRSI(in: rect, using: ctx)
            }
        }
//        if indicator.getRow() > 0 {
//            ctx.setStrokeColor(UIColor.black.cgColor)
//            ctx.setLineWidth(2.0)
//            ctx.strokeLineSegments(between: [CGPoint(x: 0, y: rect.height), CGPoint(x: rect.width, y: rect.height)])
//            ctx.strokeLineSegments(between: [CGPoint(x: rect.width, y: 0), CGPoint(x: rect.width, y: rect.height)])
//        }
        
        //Draw Title
        if indicator.getRow() > 0 && app.settings.showTitles {
            let titleString = indicator.getNameInFunctionForm().asAttributedString()
            let stringSize = titleString.size()
            let stringRect = CGRect(x: 5, y: 5, width: stringSize.width, height: stringSize.height)
            titleString.draw(in: stringRect)
        }
    }

    
    func getPreviewImage() -> UIImage {
        let width: CGFloat = 150.0
        let height: CGFloat = 50.0
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(CGRect(x: 0, y: 0, width: width, height: height))
        let image =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: - Private Methods
    
    private func drawVolume(in rect: CGRect, using ctx: CGContext) {
        guard let chart = self.chart else {
            return
        }
        let visibleCandles = self.visibleCandles
        var highestVolume: Double = 0
        for candle in visibleCandles {
            if candle.volume > highestVolume {
                highestVolume = candle.volume
            }
        }
        if highestVolume == 0 {
            return
        }
        let smaColor = indicator.style[Indicator.StyleKey.color] as! UIColor
        let smaLineWidth = indicator.style[Indicator.StyleKey.lineWidth] as! CGFloat
        let smaLength = indicator.inputs[Indicator.InputKey.length] as! Int
        
        if visibleCandles.isEmpty { return }
        
        var smaPoints = [CGPoint]()
        for i in 0..<visibleCandles.count {
            let candle = visibleCandles[i]
            let pair = indicator.value[candle.openTime] as! (Double, Double)
            let volume = pair.0
            let sma = pair.1
            
            let height: CGFloat = CGFloat(volume / highestVolume) * frame.height

            ctx.setFillColor((candle.isGreen() ? App.BullColor : App.BearColor).withAlphaComponent(0.5).cgColor)
            ctx.fill(CGRect(x: candle.x - chart.blockWidth / 3, y: frame.height - height, width: chart.blockWidth * 2 / 3, height: height))
            
            let candleIndex =  i + chart.candles.count - 1 - chart.priceView!.oldestVisibleCandleIndex
            if candleIndex < smaLength { continue }
            smaPoints.append(CGPoint(x: candle.x, y: frame.height - CGFloat(sma / highestVolume) * frame.height))
        }
        
        if chart.candles.count < smaLength  || smaPoints.isEmpty { return }
        
        ctx.setStrokeColor(smaColor.cgColor)
        ctx.setLineWidth(smaLineWidth)
        ctx.setLineJoin(.round)
        ctx.beginPath()
        ctx.move(to: smaPoints[0])
        for i in 1 ..< smaPoints.count {
            ctx.addLine(to: smaPoints[i])
        }
        ctx.strokePath()
        
    }
    
    
    
    
    private func drawMA(in rect: CGRect, using ctx: CGContext) {
        guard let chart = self.chart else {
            return
        }
        let visibleCandles = self.visibleCandles
        
        let length = inputs[Indicator.InputKey.length] as! Int
        
        if length > chart.candles.count { return }
        if visibleCandles.isEmpty { return }
        
        var points = [CGPoint]()
        for i in 0..<visibleCandles.count {
            let candle = visibleCandles[i]
            let candleIndex =  i + chart.candles.count - 1 - chart.priceView!.oldestVisibleCandleIndex
            if candleIndex < length { continue }
            let ema = indicator.value[candle.openTime] as! Double
            let point = CGPoint(x: candle.x, y: chart.priceView!.y(price: ema, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: app.settings.chartLogScale))
            points.append(point)
        }
        if points.count <= 1 { return }
        let color = style[Indicator.StyleKey.color] as! UIColor
        
        let lineWidth = style[Indicator.StyleKey.lineWidth] as! CGFloat
        
        
        
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.setLineJoin(.round)
        ctx.beginPath()
        ctx.move(to: points[0])
        for i in 1 ..< points.count {
            ctx.addLine(to: points[i])
        }
        ctx.strokePath()
    }
    
    
    
    
    
    private func drawRSI(in rect: CGRect, using ctx: CGContext) {
        guard let chart = self.chart else {
            return
        }
        let visibleCandles = self.visibleCandles
        
        let length = inputs[Indicator.InputKey.length] as! Int
        
        if length > chart.candles.count { return }
        if visibleCandles.isEmpty { return }
        
        var highestRSI: Double = 70
        var lowestRSI: Double = 30
        for candle in visibleCandles {
            let rsi = indicator.value[candle.openTime] as! Double
            if rsi > highestRSI {
                highestRSI = rsi
            } else if rsi < lowestRSI {
                lowestRSI = rsi
            }
        }
        let diff = highestRSI - lowestRSI
        valueBar.redraw(newhighestValue: Decimal(highestRSI + 0.1 * diff), newLowestValue: Decimal(lowestRSI - 0.1 * diff))
        
        var points = [CGPoint]()
        for i in 0..<visibleCandles.count {
            let candle = visibleCandles[i]
            let candleIndex =  i + chart.candles.count - 1 - chart.priceView!.oldestVisibleCandleIndex
            if candleIndex < length { continue }
            let rsi = indicator.value[candle.openTime] as! Double
            let point = CGPoint(x: candle.x, y: Util.y(price: rsi.decimalValue, frameHeight: frame.height, highestPrice: valueBar.highestValue, lowestPrice: valueBar.lowestValue))
            points.append(point)
        }
        if points.count <= 1 { return }
        let color = style[Indicator.StyleKey.color] as! UIColor
        
        let lineWidth = style[Indicator.StyleKey.lineWidth] as! CGFloat
        
        
        ctx.setStrokeColor(color.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.setLineJoin(.round)
        ctx.beginPath()
        ctx.move(to: points[0])
        for i in 1 ..< points.count {
            ctx.addLine(to: points[i])
        }
        ctx.strokePath()
    }
    
    
    
    
    
    
    //MARK: - Convenience Properties
    
    private var visibleCandles: [Candle] {
        return chart!.visibleCandles.reversed()
    }
    private var inputs: [String: Any] {
        return indicator.inputs
    }
    private var style: [String: Any] {
        return indicator.style
    }
    
    var frameRow: Int {
        return indicator.getRow()
    }
    var indicator: Indicator!
    
    
    
    
}
