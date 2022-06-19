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
        app.openOrdersVC = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func update() {
        self.collectionView.reloadData()
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
            cell.rightLabel.text = String(format: "%d", Int(order.qty))
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderPriceCVCell", for: indexPath) as! LabelButtonCVCell
            cell.button.setTitle(String(format: "%.1f", order.price), for: .normal)
            
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
            let isBuy = order.side.lowercased() == "buy"
            let s = order.symbol.asMutableAttributedString(color: .black, font: .systemFont(ofSize: 22), textAlignment: .left)
            s.append(" \(order.side) \(order.type)".asAttributedString(color: isBuy ? App.BullColor : App.BearColor, font: .systemFont(ofSize: 22), textAlignment: .left))
            sectionHeader.label.attributedText = s
            sectionHeader.cancelCompletion = {
                let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                    alert.dismiss(animated: true) {
                        self.cancelOrder(order)
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
    
    
    
    private func editOrder(order: GameOrder, editButton: UIButton, priceTF: UITextField) {
        if let priceStr = priceTF.text {
            if let p = Double(priceStr) {
                if let prevPrice = Double(editButton.titleLabel!.text!) {
                    if p == prevPrice { return }
                    order.price = p
                }
            }
        }
    }
    
    
    func cancelOrder(_ order: GameOrder) {
        order.status = "Cancelled"
    }
    
    private func getOpenOrders() -> [GameOrder] {
        var result = [GameOrder]()
        for order in app.game.orders {
            if order.status.lowercased() == "open" {
                result.append(order)
            }
            
        }
        return result
    }
}

// MARK: - Collection View Flow Layout Delegate
extension OpenOrdersVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 10, height: 40)
    }
    
}
