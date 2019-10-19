//
//  Guidlines.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/24/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class Guidlines: UIView {
    var chart: Chart? {
        return (UIApplication.shared.delegate as? AppDelegate)?.app.chart
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let timeView = chart?.timeView else { return }
        guard let priceView = chart?.priceView else { return }
        if chart!.CHARTSHOULDNOTBEREDRAWN { return }
        guard priceView.valueBar != nil else { return }
        let bottomViews = chart!.bottomViews!
        let indicatorViews = chart!.indicatorViews
        
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let w = rect.width
        let h = rect.height
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: priceView.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: priceView.bounds.width, y: h))
        
        for indicatorView in indicatorViews {
            if indicatorView.indicator.getRow() == 0 { continue }
            path.move(to: CGPoint(x: 0, y: bottomViews.frame.origin.y + indicatorView.frame.origin.y))
            path.addLine(to: CGPoint(x: w, y: bottomViews.frame.origin.y + indicatorView.frame.origin.y))
        }
        
        path.move(to: CGPoint(x: 0, y: timeView.frame.origin.y))
        path.addLine(to: CGPoint(x: w, y: timeView.frame.origin.y))
        
        
        ctx.setLineWidth(1.0)
        ctx.setStrokeColor(UIColor.black.cgColor)
        
        
        path.stroke()
        
        
    }
    
    func redraw() {
        setNeedsDisplay()
    }

}
