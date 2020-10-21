//
//  DropDownTVCell.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/12/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class DropDownTVCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let identidier = "DropDownTVCell2"
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    
    
    var menuTitles = [String]()
    var context: UIView?
        
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
        guard let context = self.context else {
            return
        }
        if isContextMenuShowing {
            return
        }
        let size = mainButton.title(for: .normal)!.asAttributedString(color: .black, font: .systemFont(ofSize: 15.0)).size()
        var w = size.width
        let h = size.height
        
        for tt in menuTitles {
            let ss = tt.asAttributedString(color: .black, font: .systemFont(ofSize: 15.0)).size()
            if ss.width > w { w = ss.width }
        }
        
        let BL = CGPoint(x: mainButton.frame.origin.x + mainButton.frame.width - w, y: frame.origin.y + bounds.height / 2 - h / 2)
    
        let bl = self.superview!.convert(BL, to: context)
        
        let comp = self.menuItemSelectedCompletion!
    
        showContextMenu(at: bl, withTitles: menuTitles, selectedTitle: selectedTitle) { str in
            self.mainButton.setTitle(str, for: .normal)
            self.selectedTitle = str
            comp(str)
        }
    }
    
    
    
    //MARK: - Manual Context Menu
    var buttonContainer: UIView!
    var innerButtonContainer: UIView!
    private var buttonHeight: CGFloat = 30.0
    private var buttonWidth: CGFloat = 10.0
    private var buttonCount: CGFloat {
        return menuTitles.count.cgFloat
    }
    private var animationDuration = 0.3
    
    func showContextMenu(at location: CGPoint, withTitles: [String], selectedTitle: String, andCompletion: @escaping (String) -> Void) {
        guard let context = self.context else { return }
        buttonHeight = 30.0
        buttonWidth = 10.0
        self.selectedTitle = selectedTitle
        menuTitles = withTitles
        menuItemSelectedCompletion = andCompletion
        
        for title in menuTitles {
            let str = title.asAttributedString(color: .black, font: UIFont.systemFont(ofSize: 15.0))
            if str.size().width > buttonWidth {
                buttonWidth = str.size().width
            }
            if str.size().height > buttonHeight {
                buttonHeight = str.size().height
            }
        }
        
        buttonWidth += 20.0
        buttonHeight += 15.0
        
        let menuHeight = buttonCount * buttonHeight
        var y = location.y
        let x = location.x
        
        
        
        if menuHeight + y > context.bounds.height {
            y = context.bounds.height - menuHeight
            if y < 0 {
                y = 0
            }
            buttonContainer = UIView(frame: CGRect(x: x, y: y, width: buttonWidth, height: 0))
        } else {
            buttonContainer = UIView(frame: CGRect(x: x, y: y, width: buttonWidth, height: 0))
        }
        
        innerButtonContainer = UITableView(frame: CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: 0)), style: .plain)
        (innerButtonContainer as! UITableView).delegate = self
        (innerButtonContainer as! UITableView).dataSource = self
        (innerButtonContainer as! UITableView).contentInset = .zero
        (innerButtonContainer as! UITableView).separatorInset = .zero
        (innerButtonContainer as! UITableView).register(UINib(nibName: "SimpleTVCell", bundle: nil), forCellReuseIdentifier: "SimpleTVCell")
        buttonContainer.addSubview(innerButtonContainer)
        
        
        innerButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        innerButtonContainer.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor).isActive = true
        innerButtonContainer.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor).isActive = true
        innerButtonContainer.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
        innerButtonContainer.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor).isActive = true
        
        
        innerButtonContainer.backgroundColor = .white
        
        
        context.addSubview(buttonContainer)
        buttonContainer.addShadow(color: .lightGray, opacity: 1.0, shadowRadius: 3.0, offset: CGSize(width: -3.0, height: 3.0))
        
        buttonContainer.alpha = 0.0
        
        toggleContextMenu()
        
    }
    
    func hideContextMenu(completion: @escaping () -> Void = {}) {
        if isContextMenuShowing {
            toggleContextMenu(completion: completion)
        }
    }
    
    
    var isContextMenuShowing = false
    private func toggleContextMenu(completion: @escaping (() -> Void) = {}) {
        guard let context = self.context else { return }
        
        if context == app.chart {
            if !isContextMenuShowing {
                app.chartVC?.activeDropDown = self
            } else {
                app.chartVC?.activeDropDown = nil
            }
        }
        
        if !isContextMenuShowing {
            isContextMenuShowing = !isContextMenuShowing
            UIView.animate(withDuration: animationDuration, animations: {
                let f = self.buttonContainer.frame
                var menuHeight = self.buttonCount * self.buttonHeight
                if menuHeight + f.origin.y > context.bounds.height {
                    menuHeight = context.bounds.height - f.origin.y
                }
                self.buttonContainer.frame = CGRect(x: f.origin.x, y: f.origin.y, width: self.buttonWidth, height: menuHeight)
                self.buttonContainer.alpha = 1.0
                self.layoutIfNeeded()
            }) { (_) in
                completion()
            }
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                let f = self.buttonContainer.frame
                self.buttonContainer.frame = CGRect(x: f.origin.x, y: f.origin.y, width: self.buttonWidth, height: 0)
                self.buttonContainer.alpha = 0.0
                self.layoutIfNeeded()
            }) { (_) in
                self.buttonContainer.removeFromSuperview()
                self.isContextMenuShowing = !self.isContextMenuShowing
                completion()
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTVCell", for: indexPath) as! SimpleTVCell
        cell.lbl.text = menuTitles[indexPath.row]
        if menuTitles[indexPath.row] == selectedTitle {
            cell.backgroundColor = .systemBlue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return buttonHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleContextMenu {
            self.menuItemSelectedCompletion?(self.menuTitles[indexPath.row])
        }
    }
    
}
