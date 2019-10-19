//
//  ColorTVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/13/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ColorTVCell: UITableViewCell {
    static let identidier = "ColorTVCell2"

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var colorView: UIButton!

    var colorChangedCompletion: ((UIColor) -> Void)?
    var currentColor = UIColor.black {
        didSet {
            colorView.backgroundColor = currentColor
        }
    }
    private var app: App!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            self.app = delegate.app
        }
        
        colorView.layer.borderWidth = 1.0
        colorView.layer.cornerRadius = 4.0
    }

    
    @IBAction func colorViewTapped(_ sender: UIButton) {
        guard let chartVC = app.chartVC else { return }
        let colorPickerVC = chartVC.colorPickerVC!
        
        
        
        chartVC.addChild(colorPickerVC)
        
        let comps = currentColor.rgb()!
        chartVC.layersContainerView.addSubview(colorPickerVC.view)
        colorPickerVC.didMove(toParent: chartVC)
        
        
        colorPickerVC.currentColor = UIColor(red: comps.red, green: comps.green, blue: comps.blue, alpha: 1.0)
        colorPickerVC.currentAlpha = comps.alpha
        colorPickerVC.opacitySlider.value = Float(comps.alpha)
        colorPickerVC.opacityValueLabel.text = "\(Int(comps.alpha * 100))"
        colorPickerVC.colorChangedCompletion = colorChangedCompletion
    }

}
