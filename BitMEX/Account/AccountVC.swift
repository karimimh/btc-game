//
//  AccountVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/12/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class AccountVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var usernameBBI: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: Properties
    var app: App!
    var auth: Authentication! {
        return app.authentication
    }
    
    var user: User?
    var walletHistory: [User.WalletHistory]?
    var wallet: User.Wallet?
    var margin: User.Margin?
    var position: [Position]?
    var orders: [Order]?
    
    var reloadTimer: Timer?
    
    var viewDidLoadExecuted = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }

        
        //let api_id = "aKWQfFXJqFM0sZ7Zts14_1u6"
        //let api_secret = "ILi7K_G1fYdRn79QcJFRlZ3jOGvchX5PnWrkd4Q37E8SSdv9"
        
        initWebSocket()
        
        app.accountVC = self
        
        
    }
    
    @objc
    private func timerJob() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func initWebSocket() {
        if app.authentication == nil {
            usernameBBI.title = "Login"
            return
        }
        
        getUser { (u) in
            if u != nil {
                self.user = u
                DispatchQueue.main.async {
                    self.usernameBBI.title = u?.email
                }
                self.getWalletHistory { (wh) in
                    self.walletHistory = wh
                    self.getWallet { (w) in
                        self.wallet = w
                        self.getMargin { (m) in
                            self.margin = m
                            self.getPosition { (p) in
                                self.position = p
                                self.getOrders { (o) in
                                    self.orders = o
                                    self.activateWebSocket()
                                    
                                    
                                    DispatchQueue.main.async {
                                        self.collectionView.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        self.reloadTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(timerJob), userInfo: nil, repeats: true)
        
    }

    
    
    
    //MARK: - CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.margin == nil {
            return 0
        }
        var N = 1
        if getOpenPositionsCount() > 0 {
            N += 1
        }
        if getOpenOrdersCount() > 0 {
            N += 1
        }
        return N
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if getOpenPositionsCount() > 0 {
                return getOpenPositionsCount()
            } else {
                return getOpenOrdersCount()
            }
        } else {
            return getOpenOrdersCount()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            //Wallet Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCVCell", for: indexPath) as! WalletCVCell
            cell.marginBalanceLabel.addBorders(edges: UIRectEdge(arrayLiteral: .bottom), color: .gray, width: 1.5)
            cell.netDepositLabel.addBorders(edges: UIRectEdge(arrayLiteral: .top), color: .gray, width: 1.5)

            if let wallet = self.wallet, let margin = self.margin {
                if let walletBalance = margin.walletBalance {
                    cell.walletBalanceLabel.text = String(format: "%.4f", walletBalance / 100000000)
                }
                
                if let walletBalance = margin.walletBalance, let deposited = wallet.deposited, let withdrawn = wallet.withdrawn {
                    let netDeposit = deposited - withdrawn
                    let profit = walletBalance - netDeposit
                    let profitPercent = 100.0 * profit / deposited
                    let profitUSD = app.getInstrument(app.settings.chartSymbol)!.markPrice! * (profit / 100000000)
                    cell.profitLabel.text = String(format: "%+7.4f₿ %(%+5.1f%%) %[%+5.1f$]", profit / 100000000, profitPercent, profitUSD)
                    cell.profitLabel.layer.cornerRadius = 10.0
                    cell.profitLabel.layer.borderWidth = 1.0
                    cell.profitLabel.layer.borderColor = UIColor.clear.cgColor
                    cell.profitLabel.layer.masksToBounds = true
                    if profit > 0 {
                        cell.profitLabel.backgroundColor = App.BullColor
                    } else {
                        cell.profitLabel.backgroundColor = App.BearColor
                    }
                    
                }
                
                if let marginBalance = margin.marginBalance {
                    let marginUSD = app.getInstrument(app.settings.chartSymbol)!.markPrice! * (marginBalance / 100000000)
                    cell.marginBalanceLabel.text = String(format: "Margin Balance:\t\t\t\t%.4f   [%.1f$]\t", marginBalance / 100000000, marginUSD)
                }
                
                
                
                
                //Bitcoin Symbol: ฿, ₿
                
                
                // Set Equivalent Daily Profit:
                if let walletBalance = margin.walletBalance, let deposited = wallet.deposited, let withdrawn = wallet.withdrawn, let walletHistory = self.walletHistory {
                    let netDeposit = deposited - withdrawn
                    let profit = walletBalance - netDeposit
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
                        cell.expDailyProfitLabel.text =  String(format: "Daily Profit(Exponential):\t\t%+.2f%%", d * 100.0)
                        
                        let linearProfit = profitPercent / (100 * N)
                        cell.linDailyProfitLabel.text = String(format: "Daily Profit(Linear):\t\t\t%+.2f%%", linearProfit * 100.0)
                    }
                }
                
                if let deposited = wallet.deposited, let withdrawn = wallet.withdrawn {
                    let netDeposit = deposited - withdrawn
                    cell.netDepositLabel.text = String(format: "Net Deposit:\t\t\t\t\t%.4f\t\t\t", netDeposit / 100000000)
                }
                    
            }
            makeCellsRoundedShadowed(cell: cell)//Shadow + Round Corners
            return cell
        } else if indexPath.section == 1 && getOpenPositionsCount() > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionCVCell", for: indexPath) as! PositionCVCell
            
            if let positions = self.position {
                let position = positions[indexPath.row]
                if let openingQty = position.openingQty {
                    if openingQty >= 0 {
                        let s = position.symbol.uppercased().asMutableAttributedString(color: UIColor.black, font: .boldSystemFont(ofSize: 25), textAlignment: nil)
                        s.append(" Long".asAttributedString(color: App.BullColor, font: .boldSystemFont(ofSize: 22), textAlignment: nil))
                        cell.symbolLabel.attributedText = s
                    } else {
                        let s = position.symbol.uppercased().asMutableAttributedString(color: UIColor.black, font: .boldSystemFont(ofSize: 25), textAlignment: nil)
                        s.append(" Short".asAttributedString(color: App.BearColor, font: .boldSystemFont(ofSize: 22), textAlignment: nil))
                        cell.symbolLabel.attributedText = s
                    }
                }
                if let openingQty = position.openingQty{
                    cell.amountLabel.text = String(format: "Size: %d $", Int(openingQty))
                }
                if let openingQty = position.openingQty,
                   let upnl = position.unrealisedPnl,
                   let entryPrice = position.avgEntryPrice,
                   let markPrice = position.markPrice,
                   let upnlROE = position.unrealisedRoePcnt {
                    
                    cell.profitLabel.text = String(format: "%+.4f (%+.2f%%)", upnl / 100000000, upnlROE * 100.0)
                    if (openingQty >= 0 && markPrice > entryPrice) || (openingQty < 0 && markPrice < entryPrice) {
                        cell.profitLabel.textColor = App.BullColor
                    } else {
                        cell.profitLabel.textColor = App.BearColor
                    }
                }
                if let entryPrice = position.avgEntryPrice {
                    cell.entryPriceLabel.text = String(format: "Entry Price: %.1f", entryPrice)
                }
                if let liqPrice = position.liquidationPrice {
                    cell.liquidationPriceLabel.text = String(format: "Liquidation Price: %.1f", liqPrice)
                }
                if let markPrice = position.markPrice {
                    cell.markPriceLabel.text = String(format: "Mark Price: %.1f", markPrice)
                }
                if let maintMargin = position.maintMargin {
                    cell.currentMarginLabel.text = String(format: "Current Margin: %.4f", maintMargin / 100000000)
                }
                
                if let order = self.getPositionCloseOrder() {
                    if let p = order.price {
                        cell.editButton.setTitle(String(format: "%.1f", p), for: .normal)
                    }
                } else {
                    cell.editButton.setTitle("SET", for: .normal)
                }
                cell.closePositionCompletion = {
                    let alert = UIAlertController(title: "Close Postion?", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        self.closePosition(position)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
                cell.editPriceCompletion = {
                    let alert = UIAlertController(title: "Set Close Price", message: "", preferredStyle: .alert)
                    alert.addTextField { (tf) in
                        if let t = cell.editButton.titleLabel?.text {
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
                                if let order = self.getPositionCloseOrder(), let prevPrice = order.price {
                                    if prevPrice == p {
                                        return
                                    }
                                    
                                    Order.PUT(authentication: self.app.authentication!, orderID: order.orderID, origClOrdID: nil, clOrdID: nil, orderQty: order.orderQty, leavesQty: nil, price: p, stopPx: order.stopPx, pegOffsetValue: order.pegOffsetValue, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                                        guard optionalError == nil else {
                                            print(optionalError!.localizedDescription)
                                            DispatchQueue.main.async {
                                                self.showAlert(message: "Order Amend Failed!")
                                            }
                                            return
                                        }
                                        guard optionalResponse != nil else {
                                            print("No Response!")
                                            DispatchQueue.main.async {
                                                self.showAlert(message: "Order Amend Failed!")
                                            }
                                            return
                                        }
                                        if let response = optionalResponse as? HTTPURLResponse {
                                            if response.statusCode == 200 {
                                                //Success
                                            } else {
                                                print(response.description)
                                                DispatchQueue.main.async {
                                                    self.showAlert(message: "Order Amend Failed!")
                                                }
                                                return
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.showAlert(message: "Order Amend Failed!")
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
                                                self.showAlert(message: "Order Creation Failed!")
                                            }
                                            return
                                        }
                                        guard optionalResponse != nil else {
                                            print("No Response!")
                                            DispatchQueue.main.async {
                                                self.showAlert(message: "Order Creation Failed!")
                                            }
                                            return
                                        }
                                        if let response = optionalResponse as? HTTPURLResponse {
                                            if response.statusCode == 200 {
                                                //Success
                                            } else {
                                                print(response.description)
                                                DispatchQueue.main.async {
                                                    self.showAlert(message: "Order Creation Failed!")
                                                }
                                                return
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.showAlert(message: "Order Creation Failed!")
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
            }
            makeCellsRoundedShadowed(cell: cell)
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenOrderCVCell", for: indexPath) as! OpenOrderCVCell
            if let _ = self.orders {
                let order = getOpenOrders()[indexPath.row]
                
                if let orderType = order.ordType?.uppercased(),
                   let side = order.side,
                   let symbol = order.symbol?.uppercased(),
                   let orderQty = order.orderQty,
                   let price = order.price {
                    
                    if side == "Buy" {
                        cell.typeLabel.textColor = App.BullColor
                        cell.qtyPriceLabel.textColor = App.BullColor
                    } else {
                        cell.typeLabel.textColor = App.BearColor
                        cell.qtyPriceLabel.textColor = App.BearColor
                    }
                    
                    cell.qtyPriceLabel.text = String(format: "Qty: %+d", Int(orderQty))
                    
                    if let orderPrice = order.price {
                        cell.editButton.titleLabel?.text = String(format: "%.1f", orderPrice)
                    } else if let stopPrice = order.stopPx {
                        cell.editButton.titleLabel?.text = String(format: "%.1f", stopPrice)
                    }
                    cell.typeLabel.text = side + " " + orderType
                    cell.symbolLabel.text = symbol
                    cell.editButton.setTitle(String(format: "%.1f", price), for: .normal)
                    
                    cell.onEditButtonTapped = {
                        let alert = UIAlertController(title: "Set Close Price", message: "Close Position at:", preferredStyle: .alert)
                        alert.addTextField { (tf) in
                            if let t = cell.editButton.titleLabel?.text {
                                if let previousPrice = Double(t) {
                                    tf.text = String(format: "%.1f", previousPrice)
                                }
                            }
                        }
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            let priceTF = alert.textFields![0] as UITextField
                            self.editOrder(order: order, editButton: cell.editButton, priceTF: priceTF)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    cell.onCancelButtonTapped = {
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
                }
            }
            makeCellsRoundedShadowed(cell: cell)
            return cell

        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BasicCVSectionHeader", for: indexPath) as? BasicCVSectionHeader {
            if indexPath.section == 0 {
                sectionHeader.view.backgroundColor = .fromHex(hex: "FFD700")
                sectionHeader.label.text = "Wallet"
                sectionHeader.imageView.image = UIImage(systemName: "dollarsign.square")
            } else if indexPath.section == 1 && getOpenPositionsCount() > 0 {
                sectionHeader.view.backgroundColor = .fromHex(hex: "00FA92")
                sectionHeader.label.text = "Position"
                sectionHeader.imageView.image = UIImage(systemName: "smallcircle.fill.circle")
            } else {
                sectionHeader.view.backgroundColor = .fromHex(hex: "EBEBEB")
                sectionHeader.label.text = "Open Order"
                sectionHeader.imageView.image = UIImage(systemName: "checkmark.seal")
            }
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    //MARK: - Network Functions
    private func activateWebSocket() {
        app.addRealtimeSubscription(arg: "position", tableName: "position") { (json) in
            if let data = json["data"] as? [[String: Any]] {
                var positions = [Position]()
                for item in data {
                    let p = Position(json: item)
                    positions.append(p)
                }
                self.position = positions
            }
        }
        app.addRealtimeSubscription(arg: "wallet", tableName: "wallet") { (json) in
            if let data = json["data"] as? [String: Any] {
                let p = User.Wallet(item: data)
                self.wallet = p
            } else if let data = json["data"] as? [[String: Any]] {
                
                //This works
                let p = User.Wallet(item: data[0])
                self.wallet = p
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        app.addRealtimeSubscription(arg: "margin", tableName: "margin") { (json) in
            if let data = json["data"] as? [[String: Any]] {
                //This Works
                
                self.margin = User.Margin(item: data[0])
                
            } else if let data = json["data"] as? [String: Any] {
                
                self.margin = User.Margin(item: data)
            }
        }
        app.addRealtimeSubscription(arg: "order", tableName: "order") { (json) in
            if let data = json["data"] as? [[String: Any]] {
                
                var orders = [Order]()
                for item in data {
                    let p = Order(item: item)
                    orders.append(p)
                }
                self.orders = orders
            }
        }
        
        
        
    }
    
    func getUser(completion: @escaping (User?) -> Void) {
        User.GET(authentication: self.auth) { (optionalUser, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                completion(nil)
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                completion(nil)
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completion(optionalUser)
                } else {
                    print(response.description)
                    completion(nil)
                    return
                }
            } else {
                print("Bad Response!")
                completion(nil)
                return
            }
        }
        
    }//۰۱۵۶۰۰۵۰۰۲۵۶۱۲۶
    
    
    func getWallet(completion: @escaping (User.Wallet?) -> Void) {
        User.GET_Wallet(authentication: auth) { (optionalWallet, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                completion(nil)
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                completion(nil)
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completion(optionalWallet)
                } else {
                    print(response.description)
                    completion(nil)
                    return
                }
            } else {
                print("Bad Response!")
                completion(nil)
                return
            }
        }
    }
    
    
    func getWalletHistory(completion: @escaping ([User.WalletHistory]?) -> Void) {
        User.GET_WalletHistory(authentication: auth) { (optionalWalletHistory, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                completion(nil)
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                completion(nil)
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completion(optionalWalletHistory)
                } else {
                    print(response.description)
                    completion(nil)
                    return
                }
            } else {
                print("Bad Response!")
                completion(nil)
                return
            }
        }
    }
    
    
    func getMargin(completion: @escaping (User.Margin?) -> Void) {
        User.GET_Margin(authentication: auth, currency: "XBT") { (optionalMargin, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                completion(nil)
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                completion(nil)
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completion(optionalMargin)
                } else {
                    print(response.description)
                    completion(nil)
                    return
                }
            } else {
                print("Bad Response!")
                completion(nil)
                return
            }
        }
    }
    
    func getPosition(completion: @escaping ([Position]?) -> Void) {
        Position.GET(authentication: auth) { (optionalPosition, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                completion(nil)
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                completion(nil)
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completion(optionalPosition)
                } else {
                    print(response.description)
                    completion(nil)
                    return
                }
            } else {
                print("Bad Response!")
                completion(nil)
                return
            }
        }
    }

    func getOrders(completion: @escaping ([Order]?) -> Void) {
        Order.GET(authentication: auth) { (optionalOrder, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                completion(nil)
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                completion(nil)
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completion(optionalOrder)
                } else {
                    print(response.description)
                    completion(nil)
                    return
                }
            } else {
                print("Bad Response!")
                completion(nil)
                return
            }
            
        }
        
    }
    
    func getOpenPositionsCount() -> Int {
        var openPositionCount = 0
        if let positions = self.position {
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

    func getOpenOrdersCount() -> Int {
        if let orders = self.orders {
            var N = 0
            for order in orders {
                if order.ordStatus == "New" {
                    N += 1
                }
                
            }
            return N
        }
        return 0
    }
    
    func getOpenOrders() -> [Order] {
        if let orders = self.orders {
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

    private func getPositionCloseOrder() -> Order? {
        let orders = self.getOpenOrders()
        for order in orders {
            if let execInst = order.execInst, let symbol = order.symbol {
                if execInst == Order.ExecutionInstruction.Close && symbol.uppercased() == app.settings.chartSymbol {
                    return order
                }
            }
        }
        return nil
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteOrder(_ order: Order) {
        Order.DELETE(authentication: self.auth, orderID: order.orderID, clOrdID: nil, text: nil) { (optionalOrders, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(message: "Order Cancellation Failed!")
                }
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                DispatchQueue.main.async {
                    self.showAlert(message: "Order Cancellation Failed!")
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
                        self.showAlert(message: "Order Cancellation Failed!")
                    }
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Order Cancellation Failed!")
                }
                print("Bad Response!")
                return
            }
        }
    }
    
    func closePosition(_ position: Position) {
        let orderCloseSide: String = (position.openingQty! >= 0) ? "Sell" : "Buy"
        Order.POST(authentication: self.auth, symbol: position.symbol, side: orderCloseSide, orderQty: position.openingQty!, price: nil, displayQty: nil, stopPx: nil, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Market, timeInForce: nil, execInst: Order.ExecutionInstruction.Close, text: nil) { (optionalOrder, optionalResponse, optionalError) in
            
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(message: "Market Close Failed!")
                }
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                DispatchQueue.main.async {
                    self.showAlert(message: "Market Close Failed!")
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
                        self.showAlert(message: "Market Close Failed!")
                    }
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Market Close Failed!")
                }
                print("Bad Response!")
                return
            }
        }
    }
    
    private func editOrder(order: Order, editButton: UIButton, priceTF: UITextField) {
        if let priceStr = priceTF.text {
            if let p = Double(priceStr) {
                if let prevPrice = Double(editButton.titleLabel!.text!) {
                    if p == prevPrice { return }
                    let isStop = order.ordType == Order.OrderType.Stop
                    
                    Order.PUT(authentication: self.app.authentication!, orderID: order.orderID, origClOrdID: nil, clOrdID: nil, orderQty: order.orderQty, leavesQty: nil, price: isStop ? nil : p, stopPx: isStop ? order.stopPx : nil, pegOffsetValue: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                        guard optionalError == nil else {
                            print(optionalError!.localizedDescription)
                            DispatchQueue.main.async {
                                self.showAlert(message: "Order Amend Failed!")
                            }
                            return
                        }
                        guard optionalResponse != nil else {
                            print("No Response!")
                            DispatchQueue.main.async {
                                self.showAlert(message: "Order Amend Failed!")
                            }
                            return
                        }
                        if let response = optionalResponse as? HTTPURLResponse {
                            if response.statusCode == 200 {
                                //Success
                            } else {
                                print(response.description)
                                DispatchQueue.main.async {
                                    self.showAlert(message: "Order Amend Failed!")
                                }
                                return
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: "Order Amend Failed!")
                            }
                            print("Bad Response!")
                            return
                        }
                    }
                }
                
            }
        }
    }
    
    
    private func makeCellsRoundedShadowed(cell: UICollectionViewCell) {
//        cell.contentView.layer.cornerRadius = 10.0
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true

//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        cell.layer.shadowRadius = 5.0
//        cell.layer.shadowOpacity = 1.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
//        cell.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    
}


// MARK: - Collection View Flow Layout Delegate
extension AccountVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 260)
        } else if indexPath.section == 1 && self.getOpenPositionsCount() > 0  {
            return CGSize(width: collectionView.bounds.width, height: 135)
        }
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
    
}
