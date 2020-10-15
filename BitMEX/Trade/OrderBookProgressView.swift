//
//  OrderBookProgressView.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/15/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class OrderBookProgressView: UIView {
    var progress: Double = 0.0
    var isBullish: Bool = true

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()!

        if isBullish {
            ctx.setFillColor(App.BullColor.cgColor)
            ctx.fill(CGRect(x: 0, y: 0, width: rect.width * CGFloat(progress), height: rect.height))
        } else {
            ctx.setFillColor(App.BearColor.cgColor)
            ctx.fill(CGRect(x: rect.width * CGFloat(1.0 - progress), y: 0, width: rect.width * CGFloat(progress), height: rect.height))
        }
    }

}
