//
//  ToolsView.swift
//  BitMEX
//
//  Created by Behnam Karimi on 8/28/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ToolsView: UIView {
    var app: App!
    var chart: Chart? {
        return app.chart
    }
    var horizontalLines: [HorizontalLine] {
        return chart?.horizontalLines ?? []
    }
    var trendlines: [Trendline] {
        return chart?.trendlines ?? []
    }
    var fibs: [FibRetracement] {
        return chart?.fibs ?? []
    }
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let chart = self.chart else {
            return
        }
        if chart.CHARTSHOULDNOTBEREDRAWN { return }
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        // draw horizontall lines:
        for line in horizontalLines {
            if line.timeframe != chart.timeframe {
                continue
            }
            let pt = self.pt(highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
            let pb = self.pb(highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
            if line.price > Double(pt) || line.price < Double(pb) { return }
            
            let y = self.y(price: line.price, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
            
            ctx.setStrokeColor(line.color.cgColor)
            ctx.setLineWidth(line.lineWidth)
            
            ctx.beginPath()
            ctx.move(to: CGPoint(x: 0, y: y))
            ctx.addLine(to: CGPoint(x: rect.width, y: y))
            ctx.strokePath()
            
            let str = "\(chart.instrument!.priceFormatted(line.price))".asAttributedString(color: line.color, textAlignment: .left)
            str.draw(at: CGPoint(x: rect.width - str.size().width, y: y))
        }
        
        
        //draw trendlines:
        for trendline in trendlines {
            if trendline.timeframe != chart.timeframe {
                continue
            }
            let startY = self.y(price: trendline.start.1, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
            let endY = self.y(price: trendline.end.1, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
            let startDate = trendline.start.0
            let endDate = trendline.end.0
            
            var x1 = chart.priceView!.getX(date: startDate, timeframe: chart.timeframe!)
            var y1 = startY
            
            var x2 = chart.priceView!.getX(date: endDate, timeframe: chart.timeframe!)
            var y2 = endY
            
            ctx.setFillColor(trendline.color.cgColor)
            if x1 == x2 {
                ctx.fillEllipse(in: CGRect(x: x1 - 5, y: y1 - 5, width: 10, height: 10))
                continue
            } else {
                ctx.fillEllipse(in: CGRect(x: x1 - 5.0, y: y1 - 5.0, width: 10.0, height: 10.0))
                ctx.fillEllipse(in: CGRect(x: x2 - 5.0, y: y2 - 5.0, width: 10.0, height: 10.0))
            }
            
            
            let m = (y2 - y1) / (x2 - x1)
            
            if x1 > rect.width {
                continue
            }
            
            if x1 < 0 {
                y1 = y1 + (0 - x1) * m
                x1 = 0
            }
            
            if x2 > rect.width {
                y2 = y2 - (x2 - rect.width) * m
                x2 = rect.width
            } else if x2 < rect.width {
                y2 = y2 + (rect.width - x2) * m
                x2 = rect.width
            }
            
            
            ctx.setStrokeColor(trendline.color.cgColor)
            ctx.setLineWidth(trendline.lineWidth)
            
            ctx.beginPath()
            ctx.move(to: CGPoint(x: x1, y: y1))
            ctx.addLine(to: CGPoint(x: x2, y: y2))
            ctx.strokePath()
            
            
        }
        
        
        //draw Fibs:
        
        for fib in fibs {
            if fib.timeframe != chart.timeframe {
                continue
            }
            
            let priceDiff = fib.start.1 - fib.end.1
            
            let startDate = fib.start.0
            let endDate = fib.end.0
            
            var x1 = chart.priceView!.getX(date: startDate, timeframe: chart.timeframe!)
            let x2 = chart.priceView!.getX(date: endDate, timeframe: chart.timeframe!)
            
            
            
            if min(x1, x2) > rect.width {
                continue
            }
            
            
            ctx.setStrokeColor(fib.color.cgColor)
            ctx.setFillColor(fib.color.cgColor)
            ctx.setLineWidth(fib.lineWidth)
            
            
            let ey1 = self.y(price: fib.start.1, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
            let ey2 = self.y(price: fib.end.1, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
        
        
            ctx.fillEllipse(in: CGRect(x: x2 - 5.0, y: ey2 - 5.0, width: 10.0, height: 10.0))
            ctx.fillEllipse(in: CGRect(x: x1 - 5.0, y: ey1 - 5.0, width: 10.0, height: 10.0))

            
            for level in fib.levels {
                ctx.beginPath()
                
                let p: Double = fib.start.1 - (1 - level) * priceDiff
                let y = self.y(price: p, highestPrice: chart.highestPrice, lowestPrice: chart.lowestPrice, topMargin: chart.topMargin, bottomMargin: chart.bottomMargin, logScale: chart.logScale)
                
                
                x1 = min(x1, x2)
                if x1 < 0 {
                    x1 = 0
                }
                
                
                ctx.move(to: CGPoint(x: x1, y: y))
                ctx.addLine(to: CGPoint(x: rect.width, y: y))
                ctx.strokePath()
                
                "\(level)".asAttributedString(color: fib.color, textAlignment: .left).draw(at: CGPoint(x: x1 + 10.0, y: y))
                let str = "\(chart.instrument!.priceFormatted(p))".asAttributedString(color: fib.color, textAlignment: .left)
                str.draw(at: CGPoint(x: rect.width - str.size().width, y: y))
                
                
            }

            
        }
        
    }
    
    func redraw() {
        setNeedsDisplay()
    }
    
    
}
