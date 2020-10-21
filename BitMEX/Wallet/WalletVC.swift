//
//  WalletVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/27/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {
    @IBOutlet weak var mainBalanceLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var dailyProfitExpLabel: UILabel!
    @IBOutlet weak var dailyProfitLinLabel: UILabel!
    @IBOutlet weak var netDepositLabel: UILabel!
    
    //MARK: - Properties
    var app: App!
    
    
    //MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        app.tabBarVC = self.tabBarController
        
        mainBalanceLabel.layer.shadowColor = UIColor.lightGray.cgColor
        mainBalanceLabel.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        mainBalanceLabel.layer.shadowRadius = 5.0
        mainBalanceLabel.layer.shadowOpacity = 1.0
        mainBalanceLabel.layer.masksToBounds = false
        mainBalanceLabel.layer.shadowPath = UIBezierPath(roundedRect: mainBalanceLabel.bounds, cornerRadius: mainBalanceLabel.layer.cornerRadius).cgPath
        mainBalanceLabel.layer.backgroundColor = UIColor.clear.cgColor

        
        update()
        activateWebSocket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activateWebSocket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        app.removeLatestWebsocketCompletion(arg: "position")
        app.removeLatestWebsocketCompletion(arg: "margin")
        app.removeLatestWebsocketCompletion(arg: "order")
        app.removeLatestWebsocketCompletion(arg: "wallet")
    }
    
    
    func update() {
        //Wallet Cell
        if let wallet = app.wallet, let margin = app.margin {
            if let marginBalance = margin.marginBalance {
                let marginUSD = app.getInstrument(app.settings.chartSymbol)!.markPrice! * (Double(marginBalance) / 100000000)
                let mainBalanceLabelText = String(format: "%.4f", Double(marginBalance) / 100000000)
//                mainBalanceLabel.text = mainBalanceLabelText
                mainBalanceLabel.flashPrice(newText: mainBalanceLabelText)
                balanceLabel.text = String(format: "%.2f$", marginUSD)
            }
            
            if let walletBalance = margin.marginBalance, let deposited = wallet.deposited, let withdrawn = wallet.withdrawn {
                let netDeposit = deposited - withdrawn
                let profit = Double(walletBalance) - netDeposit
                let profitPercent = 100.0 * profit / deposited
                profitLabel.text = String(format: "%+.1f%%", profitPercent)
                if profit > 0 {
                    profitLabel.textColor = App.BullColor
                } else {
                    profitLabel.textColor = App.BearColor
                }
            }
            
            //Bitcoin Symbol: ฿, ₿
            
            
            // Set Equivalent Daily Profit:
            if let walletBalance = margin.marginBalance, let deposited = wallet.deposited, let withdrawn = wallet.withdrawn, let walletHistory = app.walletHistory {
                let netDeposit = deposited - withdrawn
                let profit = Double(walletBalance) - netDeposit
                let profitPercent = 100.0 * profit / deposited
                let profitRatio = profitPercent / 100.0 + 1.0

                var latestDepositTime: Date? = nil
                for i in 0..<walletHistory.count {
                    let record = walletHistory[i]
                    if record.transactType! == "Deposit" {
                        latestDepositTime = Date.fromBitMEXString(str: record.transactTime!)
                        break
                    }
                }
                if let time = latestDepositTime {
                    let N = Date().timeIntervalSince(time) / (24*3600)
                    let d = pow(profitRatio, 1/N) - 1
                    dailyProfitExpLabel.text =  String(format: "%+.2f%%", d * 100.0)
                    
                    let linearProfit = profitPercent / (100 * N)
                    dailyProfitLinLabel.text = String(format: "%+.2f%%", linearProfit * 100.0)
                }
            }
            
            if let deposited = wallet.deposited, let withdrawn = wallet.withdrawn {
                let netDeposit = deposited - withdrawn
                netDepositLabel.text = String(format: "%.4f", netDeposit / 100000000)
            }
                
        }
    }
    

    private func activateWebSocket() {
        app.websocketCompletions["position"]?.append({ (json) in
            if let data = json["data"] as? [[String: Any]] {
                var positions = [Position]()
                for item in data {
                    let p = Position(json: item)
                    positions.append(p)
                }
                self.app.position = positions
                DispatchQueue.main.async {
                    self.update()
                }
            }
        })
        app.websocketCompletions["wallet"]?.append({ (json) in
            if let data = json["data"] as? [String: Any] {
                let p = User.Wallet(item: data)
                self.app.wallet = p
            } else if let data = json["data"] as? [[String: Any]] {
                
                //This works
                let p = User.Wallet(item: data[0])
                self.app.wallet = p
                DispatchQueue.main.async {
                    self.update()
                }
            }
        })
        app.websocketCompletions["margin"]?.append({ (json) in
            if let data = json["data"] as? [[String: Any]] {
                //This Works
                
                self.app.margin = User.Margin(item: data[0])
                DispatchQueue.main.async {
                    self.update()
                }
            } else if let data = json["data"] as? [String: Any] {
                
                self.app.margin = User.Margin(item: data)
            }
        })
        app.websocketCompletions["order"]?.append({ (json) in
            if let data = json["data"] as? [[String: Any]] {
                
                var orders = [Order]()
                for item in data {
                    let p = Order(item: item)
                    orders.append(p)
                }
                self.app.orders = orders
                DispatchQueue.main.async {
                    self.update()
                }
            }
        })
        
        
        
    }
  
    @IBAction func accountButtonTapped(_ sender: Any) {
        if let loginVC = storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginVC {
            loginVC.dissmissCompletion = {
                self.activateWebSocket()
            }
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
}
