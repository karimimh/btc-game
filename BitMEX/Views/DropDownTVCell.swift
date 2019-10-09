//
//  DropDownTVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/12/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class DropDownTVCell: UITableViewCell {
    
    static let identidier = "DropDownTVCell"
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    
    
    var menuTitles = [String]()
        
    var selectedTitle = ""
    var menuItemSelectedCompletion: ((String) -> Void)?
    
    var app: App!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        
    }

    
    @IBAction func mainButtonTapped(_ sender: Any) {
        let size = mainButton.title(for: .normal)!.asAttributedString(color: .black, font: .systemFont(ofSize: 15.0)).size()
        let w = size.width
        let h = size.height
        let BL = CGPoint(x: mainButton.frame.origin.x + mainButton.frame.width - w, y: frame.origin.y + bounds.height / 2 - h / 2)
    
        let bl = self.superview!.convert(BL, to: app.chart!)
    
        app.chart?.showContextMenu(at: bl, withTitles: menuTitles, selectedTitle: selectedTitle) { str in
            self.mainButton.setTitle(str, for: .normal)
            self.selectedTitle = str
            self.menuItemSelectedCompletion?(str)
        }
    }
    
    
    
}
