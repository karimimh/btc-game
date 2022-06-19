//
//  TradeVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/15/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class OrderVC: UIViewController {
    
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var longButton: UIButton!
    @IBOutlet weak var shortButton: UIButton!
    @IBOutlet weak var tradeOptionsTV: UITableView!
    
    
    //MARK: Properties
    var app: App!
    
    var priceTextFieldsSet = false
    
    
    var orderPrice: Double = 0.0 {
        didSet {
            self.setCostLabelText()
        }
    }
    var orderType: String = "Limit" {
        didSet {
            self.setCostLabelText()
        }
    }
    var orderQty: Double = 0.0 {
        didSet {
            self.setCostLabelText()
        }
    }
    var orderLeverage: Double = 20.0 {
        didSet {
            self.setCostLabelText()
        }
    }
    
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        
        app.orderVC = self
        tradeOptionsTV.delegate = self
        tradeOptionsTV.dataSource = self
        tradeOptionsTV.tableFooterView = UIView()
        
        
        self.orderPrice = app.getInstrument(app.settings.chartSymbol)!.markPrice!
        
        longButton.layer.cornerRadius = 4.0
        shortButton.layer.cornerRadius = 4.0
        
        
        hideKeyboardWhenTappedAround()
        update()
    }
    
    func update() {
        self.setCostLabelText()
        self.setAvailableBalanceLabel()
    }
    

    private func setAvailableBalanceLabel() {
        availableBalanceLabel.text = "Free Balance: " + String(format: "%.4f", app.game.freeBalance)
    }
        
    private func setCostLabelText() {
        let instrument = app.getInstrument(app.settings.chartSymbol)!
        switch orderType {
        case "Market":
            let markPrice = instrument.lastPrice!
            let cost = 1 * orderQty / (markPrice * orderLeverage)
            costLabel.text = "Cost:\(String(format: "%.4f", cost))"
        case "Stop":
            fallthrough
        case "Limit":
            let cost = orderQty / (orderPrice * orderLeverage)
            costLabel.text = "Cost: \(String(format: "%.4f", cost))"
        default:
            break
        }
        
    }
    
    
    
    func postOrder(side: String) {
        let instrument = app.getInstrument(app.settings.chartSymbol)!
        
        switch orderType {
        case "Market":
            //MARKET
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                alert.dismiss(animated: true) {
                    if let _ = self.app.game.marketOrder(symbol: instrument.symbol, side: side, qty: self.orderQty, leverage: self.orderLeverage) {
                        self.showAlert(message: "Success!!")
                    } else {
                        self.showAlert(message: "Order Execution Failed!")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        case "Limit":
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                alert.dismiss(animated: true) {
                    if let _ = self.app.game.limitOrder(symbol: instrument.symbol, side: side, qty: self.orderQty, price: self.orderPrice, leverage: self.orderLeverage) {
                        self.showAlert(message: "Success!!")
                    } else {
                        self.showAlert(message: "Order Execution Failed!")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        case "Stop":
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                alert.dismiss(animated: true) {
                    if let _ = self.app.game.stopOrder(symbol: instrument.symbol, side: side, qty: self.orderQty, price: self.orderPrice, leverage: self.orderLeverage) {
                        self.showAlert(message: "Success!!")
                    } else {
                        self.showAlert(message: "Order Execution Failed!")
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    @IBAction func shortButtonTapped(_ sender: Any) {
        if !app.game.isPlaying {
            showAlert(message: "Game is Paused!")
        } else {
            postOrder(side: "Sell")
        }
    }
    @IBAction func longButtonTapped(_ sender: Any) {
        if !app.game.isPlaying {
            showAlert(message: "Game is Paused!")
        } else {
            postOrder(side: "Buy")
        }
    }
    
    
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}


// MARK: - Collection View Flow Layout Delegate
extension OrderVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
}


//MARK: - TradeOptions TableView Delegate
extension OrderVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTVCell.identidier, for: indexPath) as! DropDownTVCell
            cell.context = self.view
            cell.label.text = "Trade Type:"
            cell.menuTitles = ["Limit", "Stop", "Market"]
            cell.selectedTitle = self.orderType
            cell.mainButton.setTitle(cell.selectedTitle, for: .normal)
            cell.menuItemSelectedCompletion = { (item) in
                self.orderType = item
                self.tradeOptionsTV.reloadData()
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
            cell.label.text = "Qty:"
            cell.textField.text = String(format: "%d", Int(self.orderQty))
            cell.textFieldValueChangedCompletion = { (valueOptional) in
                if let value = valueOptional {
                    if let qty = Double(value) {
                        self.orderQty = qty
                    } else {
                        cell.textField.text = String(format: "%d", Int(self.orderQty))
                    }
                } else {
                    cell.textField.text = String(format: "%d", Int(self.orderQty))
                }
            }
            cell.stepUpCompletion = {
                self.orderQty += 1
                cell.textField.text = String(format: "%d", self.orderQty)
            }
            cell.stepDownCompletion = {
                self.orderQty -= 1
                cell.textField.text = String(format: "%d", self.orderQty)
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
            cell.label.text = "Price:"
            cell.textField.text = String(format: "%.1f", self.orderPrice)
            if self.orderType == "Market" {
                cell.label.alpha = 0.2
                cell.textField.alpha = 0.2
                cell.plusButton.alpha = 0.2
                cell.minusButton.alpha = 0.2
                cell.textField.isEnabled = false
            } else {
                cell.label.alpha = 1.0
                cell.textField.alpha = 1.0
                cell.plusButton.alpha = 1.0
                cell.minusButton.alpha = 1.0
                cell.textField.isEnabled = true
            }
            cell.textFieldValueChangedCompletion = { (valueOptional) in
                if self.orderType == "Market" { return }
                if let value = valueOptional {
                    if let price = Double(value) {
                        self.orderPrice = price
                    } else {
                        cell.textField.text = String(format: "%.1f", self.orderPrice)
                    }
                } else {
                    cell.textField.text = String(format: "%.1f", self.orderPrice)
                }
            }
            cell.stepUpCompletion = {
                if self.orderType == "Market" { return }
                self.orderPrice += 0.5
                cell.textField.text = String(format: "%.1f", self.orderPrice)
            }
            cell.stepDownCompletion = {
                if self.orderType == "Market" { return }
                self.orderPrice -= 0.5
                cell.textField.text = String(format: "%.1f", self.orderPrice)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
            cell.label.text = "Leverage:"
            cell.textField.text = String(format: "%.1f", self.orderLeverage)
            cell.textFieldValueChangedCompletion = { (valueOptional) in
                if let value = valueOptional {
                    if let leverage = Double(value) {
                        self.orderLeverage = leverage
                    } else {
                        cell.textField.text = String(format: "%.1f", self.orderLeverage)
                    }
                } else {
                    cell.textField.text = String(format: "%.1f", self.orderLeverage)
                }
            }
            cell.stepUpCompletion = {
                if self.orderLeverage <= 99.9 {
                    self.orderLeverage += 0.1
                    cell.textField.text = String(format: "%.1f", self.orderLeverage)
                }
            }
            cell.stepDownCompletion = {
                if self.orderLeverage >= 0.1 {
                    self.orderLeverage -= 0.1
                    cell.textField.text = String(format: "%.1f", self.orderLeverage)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    
    
}
