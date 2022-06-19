//
//  WalletVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/27/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class Wallet {
    var balance: Double = 20.0
}

class WalletVC: UIViewController {
    @IBOutlet weak var mainBalanceLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
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
        app.walletVC = self
        
        mainBalanceLabel.layer.shadowColor = UIColor.lightGray.cgColor
        mainBalanceLabel.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        mainBalanceLabel.layer.shadowRadius = 5.0
        mainBalanceLabel.layer.shadowOpacity = 1.0
        mainBalanceLabel.layer.masksToBounds = false
        mainBalanceLabel.layer.shadowPath = UIBezierPath(roundedRect: mainBalanceLabel.bounds, cornerRadius: mainBalanceLabel.layer.cornerRadius).cgPath
        mainBalanceLabel.layer.backgroundColor = UIColor.clear.cgColor

        
        update()
    }
    
    func update() {
        let marginUSD = app.getInstrument(app.settings.chartSymbol)!.lastPrice! * app.game.balance
        let mainBalanceLabelText = String(format: "%.4f", app.game.balance)
        mainBalanceLabel.text = mainBalanceLabelText
        balanceLabel.text = String(format: "%.2f$", marginUSD)
    
        let netDeposit = app.game.deposited - app.game.withdrawn
        let profit = app.game.balance - netDeposit
        let profitPercent = 100.0 * profit / app.game.deposited
        profitLabel.text = String(format: "%+.1f%%", profitPercent)
        if profit > 0 {
            profitLabel.textColor = App.BullColor
        } else {
            profitLabel.textColor = App.BearColor
        }
        
        //Bitcoin Symbol: ฿, ₿
        
        netDepositLabel.text = String(format: "%.4f", netDeposit)
                
    }
    

    
  
    @IBAction func accountButtonTapped(_ sender: Any) {
    }
    
}
