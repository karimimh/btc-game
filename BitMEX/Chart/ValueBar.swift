//
//  ValueBar.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/4/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ValueBar: UIView {
    
    //MARK: - Properties
    var chart: Chart
    var highestValue: Decimal
    var lowestValue: Decimal
    var tickSize: Decimal
    var requiredTickPrices = [Decimal]()
    var precision = -1
    var topMargin: Double?
    var bottomMargin: Double?
    var logScale: Bool = false
    
    var horizontalGridLines = [CGFloat]()
    
    private var maxNumberOfTicks: CGFloat = 0
    private var minNumberOfTicks: CGFloat = 0
    private var tickGap: Decimal
    private var tickStrings = [NSAttributedString]()
    private var tickPrices = [Decimal]()
    private var numberOfTicks: Int = 1
    
    
    // MARK: - Initialization
    init(chart: Chart, highestValue: Decimal, lowestValue: Decimal, tickSize: Decimal, requiredTickPrices: [Decimal] = [Decimal](), precision: Int = -1, topMargin: Double? = nil, bottomMargin: Double? = nil, logScale: Bool = false) {
        self.tickSize = tickSize
        self.highestValue = highestValue
        self.lowestValue = lowestValue
        self.chart = chart
        self.tickGap = tickSize
        self.requiredTickPrices = requiredTickPrices
        self.precision = precision
        self.logScale = logScale
        self.topMargin = topMargin
        self.bottomMargin = bottomMargin
        super.init(frame: .zero)
        
        clipsToBounds = true
        backgroundColor = .clear
        if tickSize > 0 {
            calculateTicks()
        } else {
            var width: CGFloat = 0
            for p in requiredTickPrices {
                let attrStr =  (" " + ((precision == -1) ? p.stringValue : p.formattedWith(fractionDigitCount: precision))).asAttributedString()
                tickStrings.append(attrStr)
                if attrStr.size().width + 6 > width {
                    width = attrStr.size().width + 6
                }
                tickPrices.append(p)
            }
            if width > chart.valueBarWidth {
                chart.valueBarWidth = width
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented!")
    }
    
    
    
    // MARK: - Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if chart.CHARTSHOULDNOTBEREDRAWN { return }
        if tickSize > 0 {
            calculateTicks()
        }
        
        horizontalGridLines.removeAll()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setLineWidth(2.0)
        ctx.strokeLineSegments(between: [CGPoint(x: 0, y: 0), CGPoint(x: rect.width, y: 0)])
        ctx.strokeLineSegments(between: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: rect.height)])
        ctx.setLineWidth(1.0)
        
        let L: Decimal = lowestValue
        let H: Decimal = highestValue
        
//        if let t = self.topMargin, let b = self.bottomMargin {
//            let c1: Double = b / (100.0 - b - t)
//            L = lowestValue - (highestValue - lowestValue) * c1.decimalValue
//            let c2: Double = (100.0 - b) / (100.0 - b - t)
//            H = lowestValue + (highestValue - lowestValue) * c2.decimalValue
//        }
        
        for i in 0..<tickPrices.count {
            let string = tickStrings[i]
            let price = tickPrices[i]
            let stringSize = string.size()
            let y = self.y(price: price.doubleValue, highestPrice: H.doubleValue, lowestPrice: L.doubleValue, topMargin: topMargin ?? 0, bottomMargin: bottomMargin ?? 0, logScale: logScale)
            let stringRect = CGRect(x: 6, y: y - stringSize.height / 2, width: stringSize.width, height: stringSize.height)
            horizontalGridLines.append(y)
            ctx.strokeLineSegments(between: [CGPoint(x: 1, y: y), CGPoint(x: 6, y: y)])
            string.draw(in: stringRect)
        }
    }
    
    
    func redraw(newhighestValue: Decimal, newLowestValue: Decimal, logScale: Bool? = nil) {
        highestValue = newhighestValue
        lowestValue = newLowestValue
        if let ls = logScale {
            self.logScale = ls
        }
        setNeedsDisplay()
    }
    
    
    
    
    
    
    // MARK: - Private Methods
    
    private func calculateTicks() {
        if bounds.height <= 0 { return }
        calculateTickGap()
        tickStrings.removeAll()
        tickPrices.removeAll()
        var width: CGFloat = 0
        
        let L: Decimal = lowestValue
        let H: Decimal = highestValue
        
//        if let t = self.topMargin, let b = self.bottomMargin {
//            let c1: Double = b / (100.0 - b - t)
//            L = lowestValue - (highestValue - lowestValue) * c1.decimalValue
//            let c2: Double = (100.0 - b) / (100.0 - b - t)
//            H = lowestValue + (highestValue - lowestValue) * c2.decimalValue
//        }
        
        let m = Int((L / tickGap).doubleValue)
        
        var p = Decimal(m + 1) * tickGap
        while p < H {
            let attrStr = (" " + ((precision == -1) ? chart.instrument!.priceFormatted(p) : p.formattedWith(fractionDigitCount: precision))).asAttributedString()
            tickStrings.append(attrStr)
            if attrStr.size().width + 6 > width {
                width = attrStr.size().width + 6
            }
            tickPrices.append(p)
            p += tickGap
        }
        for p in requiredTickPrices {
            let attrStr = (" " + ((precision == -1) ? chart.instrument!.priceFormatted(p) : p.formattedWith(fractionDigitCount: precision))).asAttributedString()
            tickStrings.append(attrStr)
            if attrStr.size().width + 6 > width {
                width = attrStr.size().width + 6
            }
            tickPrices.append(p)
        }
        if width > chart.valueBarWidth {
            chart.valueBarWidth = width
        }
    }
    
    
    private func calculateTickGap() {
        let diff = (highestValue - lowestValue)
//        if let t = topMargin, let b = bottomMargin {
//            diff *= Decimal(100.0 / (100.0 - (t + b)))
//        }
        
        let n = diff / tickSize
        
        var m: [Decimal] = [1, 2, 4, 5]
        let p = Util.greatestPowerOfTenLess(than: n)
        
        
        if p >= 1 {
            for i in 1..<(p+1) {
                for j in 0..<4 {
                    let m1 = pow(10, i) * m[j]
                    if m1 < n {
                        m.append(m1)
                    }
                }
            }
        }
        
        m.reverse()
        
        let tickHeight = ("0.00002135").asAttributedString().size().height
        maxNumberOfTicks = bounds.height / (tickHeight * 3)
        
        var bestM: Decimal = m.first!
        for m1 in m {
            numberOfTicks = Int((diff / (m1 * tickSize)).doubleValue)
            if numberOfTicks <= Int(maxNumberOfTicks) {
                bestM = m1
            } else {
                break
            }
        }
        
        tickGap = bestM * tickSize
    }
    
    
    
    
    


}
