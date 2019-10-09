//
//  ColorTVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/13/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ColorTVCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var colorView: UIButton!
    var colorChangedCompletion: ((UIColor) -> Void)?
    var colorPicker = ColorPicker(frame: .zero)
    
    static let identidier = "ColorTVCell"
    var currentColor = UIColor.black {
        didSet {
            colorView.backgroundColor = currentColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.borderWidth = 1.0
        colorView.layer.cornerRadius = 4.0
    }

    
    @IBAction func colorViewTapped(_ sender: UIButton) {
        let comps = currentColor.rgb()!
        colorPicker.currentColor = UIColor(red: comps.red, green: comps.green, blue: comps.blue, alpha: 1.0)
        colorPicker.currentAlpha = comps.alpha
        colorPicker.show(at: self.colorView) { color in
            self.currentColor = color
            self.colorChangedCompletion?(color)
        }
    }

}
