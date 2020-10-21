//
//  LabelButtonCVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/27/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class LabelButtonCVCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var buttonTappedCompletion: (() -> Void)?
    @IBAction func buttonTapped(_ sender: Any) {
        self.buttonTappedCompletion?()
    }
}
