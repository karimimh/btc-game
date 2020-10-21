//
//  OpenOrderReusableView.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/27/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class OpenOrderReusableView: UICollectionReusableView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var cancelCompletion: (() -> Void)?
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.cancelCompletion?()
    }
}
