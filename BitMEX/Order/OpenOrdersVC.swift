//
//  OpenOrdersVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/27/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class OpenOrdersVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var app: App!
    var websocketTimer: Timer!
    
    
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
        app.websocketCompletions["order"]?.append({ (json) in
            if let data = json["data"] as? [[String: Any]] {
                
                var orders = [Order]()
                for item in data {
                    let p = Order(item: item)
                    orders.append(p)
                }
                self.app.orders = orders
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        app.removeLatestWebsocketCompletion(arg: "order")
    }
   
}


extension OpenOrdersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let order = getOpenOrders()[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderQtyCVCell", for: indexPath) as! DoubleLabelCVCell
            cell.rightLabel.text = String(format: "%d", Int(order.orderQty!))
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderPriceCVCell", for: indexPath) as! LabelButtonCVCell
            let isStop = order.ordType == Order.OrderType.Stop
            cell.button.setTitle(String(format: "%.1f", isStop ? order.stopPx! : order.price!), for: .normal)
            
            cell.buttonTappedCompletion = {
                let alert = UIAlertController(title: "Edit Price", message: "", preferredStyle: .alert)
                alert.addTextField { (tf) in
                    if let t = cell.button.titleLabel?.text {
                        if let previousPrice = Double(t) {
                            tf.text = String(format: "%.1f", previousPrice)
                        }
                    }
                }
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    let priceTF = alert.textFields![0] as UITextField
                    self.editOrder(order: order, editButton: cell.button, priceTF: priceTF)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            return cell
        }
        
        
       return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.getOpenOrders().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OrderCVRView", for: indexPath) as? OpenOrderReusableView {
            let order = getOpenOrders()[indexPath.section]
            let isBuy = order.side! == "Buy"
            let s = order.symbol!.asMutableAttributedString(color: .black, font: .systemFont(ofSize: 22), textAlignment: .left)
            s.append(" \(order.side!) \(order.ordType!)".asAttributedString(color: isBuy ? App.BullColor : App.BearColor, font: .systemFont(ofSize: 22), textAlignment: .left))
            sectionHeader.label.attributedText = s
            sectionHeader.cancelCompletion = {
                let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                    alert.dismiss(animated: true) {
                        self.deleteOrder(order)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    
    
    private func editOrder(order: Order, editButton: UIButton, priceTF: UITextField) {
        if let priceStr = priceTF.text {
            if let p = Double(priceStr) {
                if let prevPrice = Double(editButton.titleLabel!.text!) {
                    if p == prevPrice { return }
                    let isStop = order.ordType == Order.OrderType.Stop
                    
                    Order.PUT(authentication: self.app.authentication!, orderID: order.orderID, origClOrdID: nil, clOrdID: nil, orderQty: order.orderQty, leavesQty: nil, price: isStop ? nil : p, stopPx: isStop ? p : nil, pegOffsetValue: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
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
                }
                
            }
        }
    }
    
    
    func deleteOrder(_ order: Order) {
        Order.DELETE(authentication: self.app.authentication!, orderID: order.orderID, clOrdID: nil, text: nil) { (optionalOrders, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                DispatchQueue.main.async {
                    self.alertDialog(message: "Order Cancellation Failed!")
                }
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                DispatchQueue.main.async {
                    self.alertDialog(message: "Order Cancellation Failed!")
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
                        self.alertDialog(message: "Order Cancellation Failed!")
                    }
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.alertDialog(message: "Order Cancellation Failed!")
                }
                print("Bad Response!")
                return
            }
        }
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

// MARK: - Collection View Flow Layout Delegate
extension OpenOrdersVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 10, height: 40)
    }
    
}
