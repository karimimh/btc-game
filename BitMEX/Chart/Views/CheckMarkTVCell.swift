//
//  CheckMarkTVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/12/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class CheckMarkTVCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    static let identidier = "CheckMarkTVCell2"
    
    var switchValueChanged: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        switchValueChanged?(self.switch.isOn)
    }
    
}
