//
//  TradeVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/15/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class OrderVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var longButton: UIButton!
    @IBOutlet weak var shortButton: UIButton!
    @IBOutlet weak var orderBookCV: UICollectionView!
    @IBOutlet weak var tradeOptionsTV: UITableView!
    
    
    //MARK: Properties
    var app: App!
    var auth: Authentication! {
        return app.authentication
    }
    var orderBook: OrderBook?
    var orderBookTotalSize: Double = 0.0
    var orderBookRowCount = 5
    
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
        initWebsocket()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        app.websocketCompletions["orderBookL2_25:\(app.settings.chartSymbol)"]?.append({ (json) in
            if let data = json["data"] as? [[String: Any]] {
                var orderBookEntries = [OrderBookEntry]()
                for item in data {
                    let p = OrderBookEntry(item: item)
                    orderBookEntries.append(p)
                }
                let orderBook = OrderBook(entries: orderBookEntries)
                DispatchQueue.main.async {
                    self.orderBook = orderBook
                    self.orderBookCV.reloadData()
                }
            }
        })
        
        
        
        app.websocketCompletions["instrument:\(app.settings.chartSymbol)"]?.append({ (json) in
            DispatchQueue.main.async {
                self.setCostLabelText()
            }
        })
        
        initWebsocket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        app.removeLatestWebsocketCompletion(arg: "orderBookL2_25:\(app.settings.chartSymbol)")
        app.removeLatestWebsocketCompletion(arg: "instrument:\(app.settings.chartSymbol)")
        app.removeLatestWebsocketCompletion(arg: "margin")
    }
    
    
    
    func initWebsocket() {
        if app.authentication == nil {
            return
        }
        Order.GET(authentication: app.authentication!) { (optionalOrders, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let orders = optionalOrders {
                        for i in 0 ..< orders.count {
                            let order = orders[orders.count - 1 - i]
                            if let qty = order.orderQty {
                                DispatchQueue.main.async {
                                    self.orderQty = qty
                                    self.tradeOptionsTV.reloadData()
                                }
                                break
                            }
                        }
                    }
                } else {
                    print(response.description)
                    return
                }
            } else {
                print("Bad Response!")
                return
            }
        }
        
        app.websocketCompletions["margin"]?.append({ (json) in
            if let data = json["data"] as? [[String: Any]] {
                let margin = User.Margin(item: data[0])
                if let availableMargin = margin.availableMargin {
                    DispatchQueue.main.async {
                        self.availableBalanceLabel.text = String(format: "Av. Balance: %.4f", Double(availableMargin) / 100000000.0)
                    }
                }
            }
        })
    }
    
    
    
    
    
    
    
    //MARK: - CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.orderBook == nil {
            return 0
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let ob = self.orderBook else { return 0 }
        return ob.getLongEntries(gap: 1.0).count + ob.getShortEntries(gap: 1.0).count + 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderBookEntryCVCell", for: indexPath) as! OBEntryCVCell
        if indexPath.row == 0 {
            cell.amountLabel.text = "SIZE"
            cell.priceLabel.text = "PRICE"
            cell.contentView.backgroundColor = .magenta
            return cell
        } else if indexPath.row == orderBookRowCount + 1 {
            let simpleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleCVCell", for: indexPath) as! SimpleCVCell
            simpleCell.label.text = String(format: "%.1f", app.getInstrument(app.settings.chartSymbol)!.lastPrice!)
            return simpleCell
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        
        if indexPath.row < orderBookRowCount + 1 {
            let index = orderBookRowCount - indexPath.row
            
            if let size = orderBook?.getShortEntries(gap: 1.0)[index].size, let totalSize = orderBook?.totalSize(rows: orderBookRowCount) {
                cell.amountLabel.text = numberFormatter.string(from: NSNumber(value: size))
                let progress = sqrt(Double(size) / Double(totalSize))//sqrt for amplifying smoothing small volumes
                cell.progressView.progress = progress // >= 0.5 ? 1.0 : progress * 2
            } else {
                cell.amountLabel.text = "-"
                cell.progressView.progress = 0
            }
            if let price =  orderBook?.getShortEntries(gap: 1.0)[index].price {
                cell.priceLabel.text = String(format: "%d", Int(price))
            } else {
                cell.priceLabel.text = String(format: "-")
            }
            cell.progressView.isBullish = false
        } else {
            let index = indexPath.row - 2 - orderBookRowCount
            if let size = orderBook?.getLongEntries(gap: 1.0)[index].size, let totalSize = orderBook?.totalSize(rows: orderBookRowCount) {
                cell.amountLabel.text = numberFormatter.string(from: NSNumber(value: size))
                let progress = sqrt(Double(size) / Double(totalSize))
                cell.progressView.progress = progress // >= 0.5 ? 1.0 : progress * 2
            } else {
                cell.amountLabel.text = "-"
                cell.progressView.progress = 0
            }
            if let price = orderBook?.getLongEntries(gap: 1.0)[index].price {
                cell.priceLabel.text = String(format: "%d", Int(price))
            } else {
                cell.priceLabel.text = String(format: "-")
            }
            cell.progressView.isBullish = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! OBEntryCVCell
        if let priceStr = cell.priceLabel.text, let price = Double(priceStr) {
            self.orderPrice = price
            self.tradeOptionsTV.reloadData()
        }
    }
    
    private func setCostLabelText() {
        let instrument = app.getInstrument(app.settings.chartSymbol)!
        switch orderType {
        case "Market":
            let markPrice = instrument.lastPrice!
            let cost = 1.075 * orderQty / (markPrice * orderLeverage)
            costLabel.text = "Cost:\(String(format: "%.4f", cost))"
        case "Stop":
            fallthrough
        case "Limit":
            let cost = 1.025 * orderQty / (orderPrice * orderLeverage)
            costLabel.text = "Cost: \(String(format: "%.4f", cost))"
        default:
            break
        }
        
    }
    
    
    
    func getOrderBook(completion: @escaping ([OrderBookEntry]?) -> Void) {
        OrderBookEntry.GET(symbol: app.settings.chartSymbol, depth: 15) { (optionalOrderBook, optionalResponse, optionalError) in
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
                    completion(optionalOrderBook)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func postOrder(side: String) {
        let instrument = app.getInstrument(app.settings.chartSymbol)!
        
        switch orderType {
        case "Market":
            //MARKET
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                alert.dismiss(animated: true) {
                    
                    Order.POST(authentication: self.app.authentication!, symbol: instrument.symbol, side: side, orderQty: self.orderQty, price: nil, displayQty: nil, stopPx: nil, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Market, timeInForce: nil, execInst: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                        guard optionalError == nil else {
                            print(optionalError!.localizedDescription)
                            self.showAlert(message: "Order Execution Failed!")
                            return
                        }
                        guard optionalResponse != nil else {
                            print("No Response!")
                            self.showAlert(message: "Order Execution Failed!")
                            return
                        }
                        if let response = optionalResponse as? HTTPURLResponse {
                            if response.statusCode == 200 {
                                self.showAlert(message: "Success!!")
                                self.getPosition { (optionalPosition) in
                                    if let positions = optionalPosition {
                                        if !positions.isEmpty {
                                            let position = positions[0]
                                            if let l = position.leverage {
                                                if l != self.orderLeverage {
                                                    self.changePositionLeverage(leverage: self.orderLeverage)
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                self.showAlert(message: "Order Execution Failed!")
                                print(response.description)
                                return
                            }
                        } else {
                            self.showAlert(message: "Order Execution Failed!")
                            print("Bad Response!")
                            return
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
            
        case "Limit":
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                alert.dismiss(animated: true) {
                    Order.POST(authentication: self.app.authentication!, symbol: instrument.symbol, side: side, orderQty: self.orderQty, price: self.orderPrice, displayQty: nil, stopPx: nil, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Limit, timeInForce: nil, execInst: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                        guard optionalError == nil else {
                            print(optionalError!.localizedDescription)
                            self.showAlert(message: "Order Execution Failed!")
                            return
                        }
                        guard optionalResponse != nil else {
                            print("No Response!")
                            self.showAlert(message: "Order Execution Failed!")
                            return
                        }
                        if let response = optionalResponse as? HTTPURLResponse {
                            if response.statusCode == 200 {
                                self.showAlert(message: "Success!!")
                                self.getPosition { (optionalPosition) in
                                    if let positions = optionalPosition {
                                        if !positions.isEmpty {
                                            let position = positions[0]
                                            if let l = position.leverage {
                                                if l != self.orderLeverage {
                                                    self.changePositionLeverage(leverage: self.orderLeverage)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            } else {
                                self.showAlert(message: "Order Execution Failed!")
                                print(response.description)
                                return
                            }
                        } else {
                            self.showAlert(message: "Order Execution Failed!")
                            print("Bad Response!")
                            return
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
        case "Stop":
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                alert.dismiss(animated: true) {
                    Order.POST(authentication: self.app.authentication!, symbol: instrument.symbol, side: side, orderQty: self.orderQty, price: nil, displayQty: nil, stopPx: self.orderPrice, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Stop, timeInForce: nil, execInst: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
                        guard optionalError == nil else {
                            print(optionalError!.localizedDescription)
                            self.showAlert(message: "Order Execution Failed!")
                            return
                        }
                        guard optionalResponse != nil else {
                            print("No Response!")
                            self.showAlert(message: "Order Execution Failed!")
                            return
                        }
                        if let response = optionalResponse as? HTTPURLResponse {
                            if response.statusCode == 200 {
                                self.showAlert(message: "Success!!")
                                self.getPosition { (optionalPosition) in
                                    if let positions = optionalPosition {
                                        if !positions.isEmpty {
                                            let position = positions[0]
                                            if let l = position.leverage {
                                                if l != self.orderLeverage {
                                                    self.changePositionLeverage(leverage: self.orderLeverage)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                            } else {
                                self.showAlert(message: "Order Execution Failed!")
                                print(response.description)
                                return
                            }
                        } else {
                            self.showAlert(message: "Order Execution Failed!")
                            print("Bad Response!")
                            return
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
        default:
            break
        }
    }
    @IBAction func shortButtonTapped(_ sender: Any) {
        postOrder(side: "Sell")
    }
    @IBAction func longButtonTapped(_ sender: Any) {
        postOrder(side: "Buy")
    }
    
    private func changePositionLeverage(leverage: Double) {
        //Post Leverage
        Position.POST_LEVERAGE(authentication: self.app.authentication!, symbol: self.app.settings.chartSymbol, leverage: leverage) { (optionalPosition, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                self.showAlert(message: "Order Execution Failed!")
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                self.showAlert(message: "Order Execution Failed!")
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    
                } else {
                    self.showAlert(message: "Order Execution Failed!")
                    print(response.description)
                    return
                }
            } else {
                self.showAlert(message: "Order Execution Failed!")
                print("Bad Response!")
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
    
    
    
    
    private func getInstrumentBySymbol(symbol: String) -> Instrument? {
        for instrument in app.activeInstruments {
            if instrument.symbol.uppercased() == symbol.uppercased() {
                return instrument
            }
        }
        return nil
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
