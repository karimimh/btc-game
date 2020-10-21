//
//  PositionVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/27/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class PositionVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var app: App!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        app.websocketCompletions["position"]?.append({ (json) in
            self.collectionView.reloadData()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        app.removeLatestWebsocketCompletion(arg: "position")
    }
    
    
}

extension PositionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let position = app.position?[indexPath.section] else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionProfitCVCell", for: indexPath) as! DoubleLabelCVCell
            if let upnl = position.unrealisedPnl,
               let upnlROE = position.unrealisedRoePcnt {
                
                cell.rightLabel.text = String(format: "%+.4f (%+.2f%%)", Double(upnl) / 100000000.0, upnlROE * 100.0)
                if Double(upnl) >= 0 {
                    cell.rightLabel.textColor = App.BullColor
                } else {
                    cell.rightLabel.textColor = App.BearColor
                }
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionSizeCVCell", for: indexPath) as! DoubleLabelCVCell
            if let openingQty = position.foreignNotional {
                cell.rightLabel.text = String(format: "%+d $", Int(openingQty))
            } else if let openingQty = position.openingQty {
                cell.rightLabel.text = String(format: "%+d $", Int(openingQty))
            } else if let openingQty = position.openOrderBuyQty {
                cell.rightLabel.text = String(format: "%+d $", Int(openingQty))
            } else if let openingQty = position.openOrderSellQty {
                cell.rightLabel.text = String(format: "%+d $", Int(openingQty))
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionEntryCVCell", for: indexPath) as! DoubleLabelCVCell
            if let entryPrice = position.avgEntryPrice {
                cell.rightLabel.text = String(format: "%.1f", entryPrice)
            }
            
            return cell
        } else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionMarkCVCell", for: indexPath) as! DoubleLabelCVCell
            
            if let markPrice = position.markPrice {
                cell.rightLabel.text = String(format: "%.1f", markPrice)
            }
            return cell
        } else if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionCloseCVCell", for: indexPath) as! LabelButtonCVCell
            if let closeOrder = self.getCloseOrder(of: position) {
                cell.button.setTitle(String(format: "%.1f", closeOrder.price!), for: .normal)
            } else {
                cell.button.setTitle("SET", for: .normal)
            }
            cell.buttonTappedCompletion = {
                let alert = UIAlertController(title: "Set Close Price", message: "", preferredStyle: .alert)
                alert.addTextField { (tf) in
                    if let t = cell.button.titleLabel?.text {
                        if let previousPrice = Double(t) {
                            tf.text = String(format: "%.1f", previousPrice)
                        } else {
                            tf.placeholder = "Close Position at ..."
                        }
                    }
                }
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    let priceTF = alert.textFields![0] as UITextField
                    if let t = priceTF.text {
                        if let p = Double(t) {
                            if let order = self.getCloseOrder(of: position), let prevPrice = order.price {
                                if prevPrice == p {
                                    return
                                }
                                
                                Order.PUT(authentication: self.app.authentication!, orderID: order.orderID, origClOrdID: nil, clOrdID: nil, orderQty: order.orderQty, leavesQty: nil, price: p, stopPx: order.stopPx, pegOffsetValue: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                                    guard optionalError == nil else {
                                        print(optionalError!.localizedDescription)
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Amend Failed!")
                                        }
                                        return
                                    }
                                    guard optionalResponse != nil else {
                                        print("No Response!")
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Amend Failed!")
                                        }
                                        return
                                    }
                                    if let response = optionalResponse as? HTTPURLResponse {
                                        if response.statusCode == 200 {
                                            //Success
                                        } else {
                                            print(response.description)
                                            DispatchQueue.main.async {
                                                self.alertDialog(message: "Order Amend Failed!")
                                            }
                                            return
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Amend Failed!")
                                        }
                                        print("Bad Response!")
                                        return
                                    }
                                }
                            } else {
                                var side: String
                                if position.openingQty! > 0 {
                                    side = "Sell"
                                } else {
                                    side = "Buy"
                                }
                                Order.POST(authentication: self.app.authentication!, symbol: position.symbol, side: side, orderQty:  abs(position.openingQty!), price: p, displayQty: nil, stopPx: nil, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Limit, timeInForce: nil, execInst: Order.ExecutionInstruction.Close, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                                    guard optionalError == nil else {
                                        print(optionalError!.localizedDescription)
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Creation Failed!")
                                        }
                                        return
                                    }
                                    guard optionalResponse != nil else {
                                        print("No Response!")
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Creation Failed!")
                                        }
                                        return
                                    }
                                    if let response = optionalResponse as? HTTPURLResponse {
                                        if response.statusCode == 200 {
                                            //Success
                                        } else {
                                            print(response.description)
                                            DispatchQueue.main.async {
                                                self.alertDialog(message: "Order Creation Failed!")
                                            }
                                            return
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Creation Failed!")
                                        }
                                        print("Bad Response!")
                                        return
                                    }
                                }
                            }
                            
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            return cell
        } else if indexPath.row == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionStopCVCell", for: indexPath) as! LabelButtonCVCell
            
            if let stopOrder = self.getStopOrder(of: position) {
                cell.button.setTitle(String(format: "%.1f", stopOrder.stopPx!), for: .normal)
            } else {
                cell.button.setTitle("SET", for: .normal)
            }
            
            cell.buttonTappedCompletion = {
                let alert = UIAlertController(title: "Set Stop Price", message: "", preferredStyle: .alert)
                alert.addTextField { (tf) in
                    if let t = cell.button.titleLabel?.text {
                        if let previousPrice = Double(t) {
                            tf.text = String(format: "%.1f", previousPrice)
                        } else {
                            tf.placeholder = "Stop Price"
                        }
                    }
                }
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    let priceTF = alert.textFields![0] as UITextField
                    if let t = priceTF.text {
                        if let p = Double(t) {
                            if let order = self.getStopOrder(of: position), let prevPrice = order.stopPx {
                                if prevPrice == p {
                                    return
                                }
                                
                                Order.PUT(authentication: self.app.authentication!, orderID: order.orderID, origClOrdID: nil, clOrdID: nil, orderQty: order.orderQty, leavesQty: nil, price: nil, stopPx: p, pegOffsetValue: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                                    guard optionalError == nil else {
                                        print(optionalError!.localizedDescription)
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Amend Failed!")
                                        }
                                        return
                                    }
                                    guard optionalResponse != nil else {
                                        print("No Response!")
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Amend Failed!")
                                        }
                                        return
                                    }
                                    if let response = optionalResponse as? HTTPURLResponse {
                                        if response.statusCode == 200 {
                                            //Success
                                        } else {
                                            print(response.description)
                                            DispatchQueue.main.async {
                                                self.alertDialog(message: "Order Amend Failed!")
                                            }
                                            return
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Amend Failed!")
                                        }
                                        print("Bad Response!")
                                        return
                                    }
                                }
                            } else {
                                var side: String
                                if position.openingQty! > 0 {
                                    side = "Sell"
                                } else {
                                    side = "Buy"
                                }
                                Order.POST(authentication: self.app.authentication!, symbol: position.symbol, side: side, orderQty:  abs(position.openingQty!), price: nil, displayQty: nil, stopPx: p, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Stop, timeInForce: nil, execInst: Order.ExecutionInstruction.MarkPrice, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                                    guard optionalError == nil else {
                                        print(optionalError!.localizedDescription)
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Creation Failed!")
                                        }
                                        return
                                    }
                                    guard optionalResponse != nil else {
                                        print("No Response!")
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Creation Failed!")
                                        }
                                        return
                                    }
                                    if let response = optionalResponse as? HTTPURLResponse {
                                        if response.statusCode == 200 {
                                            //Success
                                        } else {
                                            print(response.description)
                                            DispatchQueue.main.async {
                                                self.alertDialog(message: "Order Creation Failed!")
                                            }
                                            return
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.alertDialog(message: "Order Creation Failed!")
                                        }
                                        print("Bad Response!")
                                        return
                                    }
                                }
                            }
                            
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            return cell
        } else if indexPath.row == 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionLiquidationCVCell", for: indexPath) as! DoubleLabelCVCell
            
            if let liqPrice = position.liquidationPrice {
                cell.rightLabel.text = String(format: "%.1f", liqPrice)
            }
            return cell
        } else if indexPath.row == 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionLeverageCVCell", for: indexPath) as! DoubleLabelCVCell
            
            if let leverage = position.leverage {
                cell.rightLabel.text = String(format: "%.1f", leverage)
            }
            return cell
        }
        
        
        
       return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.getPositionsCount()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PositionCVRView", for: indexPath) as? PositionCVReusable {
            if let position = app.position?[indexPath.section] {
                let openingQty = position.openingCost!
                if openingQty >= 0 {
                    sectionHeader.backgroundColor = App.BullColor
                    sectionHeader.symbolLabel.text = "\(position.symbol) Long"
                } else {
                    sectionHeader.backgroundColor = App.BearColor
                    sectionHeader.symbolLabel.text = "\(position.symbol) Short"
                }
                sectionHeader.closeButtonCompletion = {
                    let alert = UIAlertController(title: "Close Position", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.closePosition(position)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
            }
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    private func closePosition(_ position: Position) {
        let orderCloseSide: String = (position.openingQty! >= 0) ? "Sell" : "Buy"
        Order.POST(authentication: app.authentication!, symbol: position.symbol, side: orderCloseSide, orderQty: position.openingQty!, price: nil, displayQty: nil, stopPx: nil, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Market, timeInForce: nil, execInst: Order.ExecutionInstruction.Close, text: nil) { (optionalOrder, optionalResponse, optionalError) in
            
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                DispatchQueue.main.async {
                    self.alertDialog(message: "Market Close Failed!")
                }
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                DispatchQueue.main.async {
                    self.alertDialog(message: "Market Close Failed!")
                }
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } else {
                    print(response.description)
                    DispatchQueue.main.async {
                        self.alertDialog(message: "Market Close Failed!")
                    }
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.alertDialog(message: "Market Close Failed!")
                }
                print("Bad Response!")
                return
            }
        }
    }
    
    
    private func getPositionsCount() -> Int {
        var openPositionCount = 0
        if let positions = app.position {
            for position in positions {
                if let isOpen = position.isOpen {
                    if isOpen {
                        openPositionCount += 1
                    }
                }
            }
        }
        return openPositionCount
    }
    
    private func getCloseOrder(of position: Position) -> Order? {
        let orders = self.getOpenOrders()
        for order in orders {
            if let execInst = order.execInst, let symbol = order.symbol, let type = order.ordType {
                if execInst == Order.ExecutionInstruction.Close && type == Order.OrderType.Limit  && symbol.uppercased() == position.symbol {
                    return order
                }
            }
        }
        return nil
    }
    
    private func getStopOrder(of position: Position) -> Order? {
        let orders = self.getOpenOrders()
        for order in orders {
            if let symbol = order.symbol, let type = order.ordType {
                if type == Order.OrderType.Stop  && symbol.uppercased() == position.symbol {
                    return order
                }
            }
        }
        return nil
    }
    
    private func getOpenOrders() -> [Order] {
        if let orders = app.orders {
            var result = [Order]()
            for order in orders {
                if order.ordStatus == "New" {
                    result.append(order)
                }
                
            }
            return result
        }
        return []
    }
}
