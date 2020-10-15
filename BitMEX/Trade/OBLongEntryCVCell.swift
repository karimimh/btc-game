//
//  OBLongEntryCVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/15/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class OBLongEntryCVCell: UICollectionViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var progressView: OrderBookProgressView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        amountLabel.text = ""
        priceLabel.text = ""
        progressView.progress = 0
        progressView.setNeedsDisplay()
        amountLabel.setNeedsDisplay()
        priceLabel.setNeedsDisplay()
        contentView.backgroundColor = App.BullColor.withAlphaComponent(0.5)
        
    }
}
