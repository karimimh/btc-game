//
//  TextFieldTVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/13/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class TextFieldTVCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    static let identidier = "TextFieldTVCell"
    
    
    
    var textFieldValueChangedCompletion: ((String?) -> Void)?
    var stepUpCompletion: (() -> Void)?
    var stepDownCompletion: (() -> Void)?
    
    
    var app: App!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        app.chart?.settingsView.currentTextFieldCell = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldValueChangedCompletion?(textField.text)
        app.chart?.settingsView.currentTextFieldCell = nil
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        stepDownCompletion?()
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        stepUpCompletion?()
    }
}
