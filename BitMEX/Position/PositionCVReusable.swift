//
//  PositionCVReusable.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/27/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class PositionCVReusable: UICollectionReusableView {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var closeButtonCompletion: (() -> Void)?
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.closeButtonCompletion?()
    }
}
