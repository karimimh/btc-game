//
//  Crosshair.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/8/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class Crosshair: UIView {
    //MARK: - Properties
    var chart: Chart? {
        return (UIApplication.shared.delegate as? AppDelegate)?.app.chart
    }
    
    var visibleCandles: [Candle]? {
        return chart?.visibleCandles.reversed()
    }
    
    
    var position = CGPoint.zero
    var initialPosition = CGPoint.zero {
        didSet {
            position = initialPosition
        }
    }
    var isEnabled = false
    private var currentCandleIndex = -1
    
    
    //MARK: - Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isEnabled {
            return
        }
        guard let chart = self.chart else { return }
        if chart.CHARTSHOULDNOTBEREDRAWN { return }
        guard let timeView = self.chart?.timeView else { return }
        guard let priceView = self.chart?.priceView else { return }
        guard chart.instrument != nil else { return }
        guard priceView.valueBar != nil else { return }
        
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        let path = UIBezierPath()
        
        let w = chart.bounds.width - chart.valueBarWidth
        let h = chart.bounds.height - timeView.bounds.height
        
        
        path.move(to: CGPoint(x: position.x, y: 0))
        path.addLine(to: CGPoint(x: position.x, y: h))
        
        path.move(to: CGPoint(x: 0, y: position.y))
        path.addLine(to: CGPoint(x: w, y: position.y))
        
        ctx.setLineDash(phase: 0, lengths: [4.0, 4.0])
        ctx.setLineWidth(0.5)
        ctx.setStrokeColor(UIColor.darkGray.cgColor)
        
        path.stroke()
        
        
        //Draw Time:
        let _candleIndex = Int((position.x - chart.oldestCandleX) / chart.blockWidth)
        currentCandleIndex = _candleIndex - (priceView.candles.count - priceView.oldestVisibleCandleIndex - 1)
        

        let string = timeToText(tick: currentCandleIndex)
        let stringSize = string.size()
        let bgTRect = CGRect(x: position.x - stringSize.width / 2, y: chart.timeView!.frame.origin.y, width: stringSize.width, height: TimeView.getHeight())
        let strRect = CGRect(x: position.x - stringSize.width / 2, y: chart.timeView!.frame.origin.y + (TimeView.getHeight() - stringSize.height) / 2, width: stringSize.width, height: stringSize.height)
        ctx.setFillColor(UIColor.black.withAlphaComponent(0.5).cgColor)
        ctx.fill(bgTRect)
        string.draw(in: strRect)

//        Draw Price
        
        if chart.priceView!.frame.contains(position) {
            let price = chart.priceView!.price(y: position.y, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
            let str = (" " + chart.instrument!.priceFormatted(price)).asAttributedString(color: .white, textAlignment: .center)
            let strWidth = chart.valueBarWidth
            let strHeight = str.size().height

            let strRect = CGRect(x: self.frame.width + 6 - strWidth, y: position.y - strHeight / 2, width: strWidth, height: strHeight)
            let bgRect = CGRect(x: self.frame.width - strWidth, y: position.y - strHeight * 0.75, width: strWidth, height: strHeight * 1.5)
            ctx.setFillColor(UIColor.black.withAlphaComponent(0.75).cgColor)
            ctx.fill(bgRect)
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.strokeLineSegments(between: [CGPoint(x: self.frame.width - strWidth, y: position.y), CGPoint(x: self.frame.width - strWidth + 6, y: position.y)])
            str.draw(in: strRect)
            
            
            if let vc = visibleCandles{
                if currentCandleIndex < vc.count {
                    let candle = vc[currentCandleIndex]
                    let candleStr = ("O: \(candle.open)  H: \(candle.high)  L: \(candle.low)  C: \(candle.close)").asAttributedString(color: .gray, textAlignment: .center)
                    let candleStrWidth = candleStr.size().width
                    let candleStrHeight = candleStr.size().height

                    let candleStrRect = CGRect(x: 6, y: 30, width: candleStrWidth, height: candleStrHeight)
                    candleStr.draw(in: candleStrRect)
                    
                    for kk in 0 ..< chart.indicators.count {
                        let indicator = chart.indicators[kk]
                        if indicator.name == "ema" || indicator.name == "ma" {
                            let mastr = ("\(indicator.getNameInFunctionForm()): " + chart.instrument!.priceFormatted((indicator.value[candle.openTime] as! Double))).asAttributedString(color: indicator.style["color"] as! UIColor, textAlignment: .center)
                            let mastrWidth = mastr.size().width
                            let mastrHeight = mastr.size().height

                            let candleStrRect = CGRect(x: 6, y: 45 + CGFloat(kk) * 15, width: mastrWidth, height: mastrHeight)
                            mastr.draw(in: candleStrRect)
                        }
                    }
                    
                }
            }
            
        } else {
            var indicatorView: IndicatorView?
            for iv in chart.indicatorViews {
                if iv.indicator.getRow() == 0 { continue }
                let f = iv.frame
                if f.contains(position) {
                    indicatorView = iv
                    break
                }
            }
            if let v = indicatorView {
                let f = CGRect(x: 0, y: chart.bottomViews!.frame.origin.y + v.frame.origin.y, width: chart.bottomViews!.bounds.width, height: v.bounds.height)
                let value = v.valueBar.highestValue.doubleValue - Double(position.y - f.origin.y) / Double(f.height) * (v.valueBar.highestValue - v.valueBar.lowestValue).doubleValue
                let str: NSAttributedString
                switch v.indicator.name {
                case Indicator.SystemName.ma.rawValue:
                    str = (" " + value.formattedWith(fractionDigitCount: 2)).asAttributedString(color: .white, textAlignment: .center)
                default:
                    str = " ".asAttributedString(color: .white, textAlignment: .center)
                }
                
                let strWidth = chart.valueBarWidth
                let strHeight = str.size().height

                let strRect = CGRect(x: self.frame.width + 6 - strWidth, y: position.y - strHeight / 2, width: strWidth, height: strHeight)
                let bgRect = CGRect(x: self.frame.width - strWidth, y: position.y - strHeight * 0.75, width: strWidth, height: strHeight * 1.5)
                ctx.setFillColor(UIColor.black.withAlphaComponent(0.75).cgColor)
                ctx.fill(bgRect)
                ctx.setStrokeColor(UIColor.white.cgColor)
                ctx.strokeLineSegments(between: [CGPoint(x: self.frame.width - strWidth, y: position.y), CGPoint(x: self.frame.width - strWidth + 6, y: position.y)])
                str.draw(in: strRect)
            }
        }
    }
    
    func redraw() {
        setNeedsDisplay()
    }
    
    
    
    
    //MARK: - Private Methods
    
    private func timeToText(tick: Int) -> NSAttributedString {
        guard let visibleCandles = self.visibleCandles else { return "".asAttributedString() }
        
        var time: Date
        if tick < visibleCandles.count {
            time = visibleCandles[tick].openTime
        } else {
            time = visibleCandles.last!.openTime
            for _ in visibleCandles.count ... tick {
                time = time.dateBy(adding: chart!.timeframe!)
            }
        }
        let day = App.myCalendar.component(.day, from: time)
        let month = App.myCalendar.component(.month, from: time)
        let year = App.myCalendar.component(.year, from: time)
        let minuteL = App.myCalendar.component(.minute, from: time)
        let hourL = App.myCalendar.component(.hour, from: time)
        
        
        let text = App.myCalendar.monthSymbols[month - 1]
        let m = String(text[text.startIndex ..< text.index(text.startIndex, offsetBy: 3)])
        
        let d = String(format: "%02d", day)
        let h = String(format: "%02d", hourL)
        let min = String(format: "%02d", minuteL)
        return "  \(d) \(m) \(year)  \(h):\(min)  ".asAttributedString(color: .white, textAlignment: .center)
    }
}
