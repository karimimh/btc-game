//
//  PositionCVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/14/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class PositionCVCell: UICollectionViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var entryPriceLabel: UILabel!
    @IBOutlet weak var liquidationPriceLabel: UILabel!
    @IBOutlet weak var currentMarginLabel: UILabel!
    @IBOutlet weak var markPriceLabel: UILabel!
    @IBOutlet weak var closePriceLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var closePositionCompletion: (() -> Void)?
    var editPriceCompletion: (() -> Void)?
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        closePositionCompletion?()
    }
    @IBAction func setClosePrice(_ sender: Any) {
        editPriceCompletion?()
    }
    
    
}
