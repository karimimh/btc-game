//
//  OpenOrderCVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/15/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class OpenOrderCVCell: UICollectionViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var qtyPriceLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var onCancelButtonTapped: (() -> Void)?
    var onEditButtonTapped: (() -> Void)?
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        onCancelButtonTapped?()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        onEditButtonTapped?()
    }
    
}
