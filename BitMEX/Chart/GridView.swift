//
//  GridView.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/7/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class GridView: UIView {
    var chart: Chart? {
        return (UIApplication.shared.delegate as? AppDelegate)?.app.chart
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let timeView = chart?.timeView else { return }
        guard let priceView = chart?.priceView else { return }
        if chart!.CHARTSHOULDNOTBEREDRAWN { return }
        guard priceView.valueBar != nil else { return }
        let indicatorViews = chart!.indicatorViews
        
        
        let path = UIBezierPath()
        let w = rect.width
        let h = rect.height
        
        for x in timeView.verticalGridLines {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: h))
        }

        for y in priceView.valueBar!.horizontalGridLines {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: w, y: y))
        }
        
        for indicatorView in indicatorViews {
            if indicatorView.indicator.getRow() == 0 { continue }
            let bottomViewsY = chart!.bottomViews!.frame.origin.y
            let indicatorViewY = bottomViewsY + indicatorView.frame.origin.y
            for y in indicatorView.valueBar.horizontalGridLines {
                path.move(to: CGPoint(x: 0, y: y + indicatorViewY))
                path.addLine(to: CGPoint(x: w, y: y + indicatorViewY))
            }
        }
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.setLineWidth(0.1)
        ctx.setStrokeColor(chart!.app.settings.gridLinesColor.cgColor)
        
        path.stroke()
    }
    
    func redraw() {
        setNeedsDisplay()
    }

}
