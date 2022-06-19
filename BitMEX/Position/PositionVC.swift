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
        app.positionVC = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func update() {
        self.collectionView.reloadData()
    }
}


//MARK: - Position UICollectionViewDelegate

extension PositionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionProfitCVCell", for: indexPath) as! DoubleLabelCVCell
            if let upnl = app.game.position?.getUpnl(lastPrice: app.chart!.instrument!.lastPrice!),
               let upnlROE = app.game.position?.getUpnlPcnt(lastPrice: app.chart!.instrument!.lastPrice!) {
                cell.rightLabel.text = String(format: "%+.4f (%+.2f%%)", upnl, upnlROE)
                if Double(upnl) >= 0 {
                    cell.rightLabel.textColor = App.BullColor
                } else {
                    cell.rightLabel.textColor = App.BearColor
                }
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionSizeCVCell", for: indexPath) as! DoubleLabelCVCell
            
            if let openingQty = app.game.position?.qty {
                cell.rightLabel.text = String(format: "%+d $", Int(openingQty))
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionEntryCVCell", for: indexPath) as! DoubleLabelCVCell
            if let entryPrice = app.game.position?.entry {
                cell.rightLabel.text = String(format: "%.1f", entryPrice)
            }
            
            return cell
        } else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionMarkCVCell", for: indexPath) as! DoubleLabelCVCell
            
            if let markPrice = app.getInstrument(app.settings.chartSymbol)?.lastPrice {
                cell.rightLabel.text = String(format: "%.1f", markPrice)
            }
            return cell
        } else if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionCloseCVCell", for: indexPath) as! LabelButtonCVCell
            if let close = app.game.position?.closePrice {
                cell.button.setTitle(String(format: "%.1f", close), for: .normal)
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
                            if let prevPrice = self.app.game.position?.closePrice {
                                if prevPrice == p {
                                    return
                                }
                                let position = self.app.game.position!
                                if let prevOrder = self.app.game.getOpenOrder(symbol: position.symbol, price: prevPrice) {
                                    prevOrder.status = "Cancelled"
                                    position.closePrice = nil
                                    if let _ = self.app.game.limitOrder(symbol: position.symbol, side: prevOrder.side, qty: prevOrder.qty, price: p, leverage: position.leverage) {
                                        position.closePrice = p
                                    }
                                }
                            } else {
                                let position = self.app.game.position!
                                let side: String = position.side.lowercased() == "long" ? "Sell" : "Buy"
                                if let _ = self.app.game.limitOrder(symbol: position.symbol, side: side, qty: position.qty, price: p, leverage: position.leverage) {
                                    position.closePrice = p
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
            
            if let stop = app.game.position?.stopPrice {
                cell.button.setTitle(String(format: "%.1f", stop), for: .normal)
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
                            if let prevPrice = self.app.game.position?.stopPrice {
                                if prevPrice == p {
                                    return
                                }
                                
                                let position = self.app.game.position!
                                if let prevOrder = self.app.game.getOpenOrder(symbol: position.symbol, price: prevPrice) {
                                    prevOrder.status = "Cancelled"
                                    position.stopPrice = nil
                                    if let _ = self.app.game.stopOrder(symbol: position.symbol, side: prevOrder.side, qty: prevOrder.qty, price: p, leverage: position.leverage) {
                                        position.stopPrice = p
                                    }
                                }
                            } else {
                                let position = self.app.game.position!
                                let side: String = position.side.lowercased() == "long" ? "Sell" : "Buy"
                                if let _ = self.app.game.stopOrder(symbol: position.symbol, side: side, qty: position.qty, price: p, leverage: position.leverage) {
                                    position.stopPrice = p
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
            
            if let liqPrice = app.game.position?.liquidationPrice {
                cell.rightLabel.text = String(format: "%.1f", liqPrice)
            }
            return cell
        } else if indexPath.row == 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionLeverageCVCell", for: indexPath) as! DoubleLabelCVCell
            
            if let leverage = app.game.position?.leverage {
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
            if let position = app.game.position {
                if position.side.lowercased() == "long" {
                    sectionHeader.backgroundColor = App.BullColor
                    sectionHeader.symbolLabel.text = "\(position.symbol) Long"
                } else {
                    sectionHeader.backgroundColor = App.BearColor
                    sectionHeader.symbolLabel.text = "\(position.symbol) Short"
                }
                sectionHeader.closeButtonCompletion = {
                    let alert = UIAlertController(title: "Close Position", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        let s: String = position.side.lowercased() == "long" ? "Sell" : "Buy"
                        let _ = self.app.game.marketOrder(symbol: position.symbol, side: s, qty: position.qty, leverage: position.leverage)
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
    
    
    private func getPositionsCount() -> Int {
        if app.game.position == nil {
            return 0
        }
        return 1
    }
    
    
}
