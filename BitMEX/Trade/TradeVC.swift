//
//  TradeVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/15/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class TradeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate  {
    @IBOutlet weak var tradeTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var leverageTextField: UITextField!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var longButton: UIButton!
    @IBOutlet weak var shortButton: UIButton!
    @IBOutlet weak var orderBookCV: UICollectionView!
    
    @IBOutlet weak var limitLabel: UILabel!
    
    //MARK: Properties
    var app: App!
    var auth: Authentication! {
        return app.authentication
    }
    var orderBook: OrderBook?
    var orderBookTotalSize: Double = 0.0
    
    
    var orderBookRowCount = 17
    
    var viewDidLoadExecuted = false
    
    var priceTextFieldsSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        
//        let api_id = "aKWQfFXJqFM0sZ7Zts14_1u6"
//        let api_secret = "ILi7K_G1fYdRn79QcJFRlZ3jOGvchX5PnWrkd4Q37E8SSdv9"
        
        
        qtyTextField.delegate = self
        priceTextField.delegate = self
        leverageTextField.delegate = self

        orderBookCV.layer.borderWidth = 3.0
        orderBookCV.layer.borderColor = UIColor.black.cgColor

        
        app.addRealtimeSubscription(arg: "orderBookL2_25:\(app.settings.chartSymbol)", tableName: "orderBookL2_25") { (json) in
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
        }
        
        
        
        
        app.addRealtimeSubscription(arg: "instrument:\(app.settings.chartSymbol)", tableName: "instrument") { (_) in
            DispatchQueue.main.async {
                self.setCostLabelText()
                if !self.priceTextFieldsSet {
                    let instrument = self.app.getInstrument(self.app.settings.chartSymbol)!
                    self.priceTextField.text = String(format: "%.1f", instrument.markPrice!)
                    self.priceTextFieldsSet = true
                }
                
            }
        }
        
        
        
        
        hideKeyboardWhenTappedAround()
        
        
        _tradeTypeChanged()
        
        initWebsocket()
        
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
                                    self.qtyTextField.text = String(format: "%.1f", qty)
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
        
        app.addRealtimeSubscription(arg: "margin", tableName: "margin") { (json) in
            if let data = json["data"] as? [[String: Any]] {
                let margin = User.Margin(item: data[0])
                if let availableMargin = margin.excessMargin {
                    DispatchQueue.main.async {
                        self.availableBalanceLabel.text = String(format: "Av. Balance: %.4f XBT", availableMargin / 100000000.0)
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    //MARK: - CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.orderBook == nil {
            return 0
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderBookRowCount * 2 + 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderBookLongEntryCVCell", for: indexPath) as! OBLongEntryCVCell
            cell.amountLabel.text = "SIZE"
            cell.priceLabel.text = "PRICE"
            cell.contentView.backgroundColor = .white
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderBookShortEntryCVCell", for: indexPath) as! OBShortEntryCVCell
            cell.amountLabel.text = "SIZE"
            cell.priceLabel.text = "PRICE"
            cell.contentView.backgroundColor = .white
            return cell
        }
        
        let i = indexPath.row - 2
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        if i % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderBookLongEntryCVCell", for: indexPath) as! OBLongEntryCVCell
            if let size = orderBook?.longEntries[i / 2].size, let totalSize = orderBook?.totalSize(rows: orderBookRowCount) {
                cell.amountLabel.text = numberFormatter.string(from: NSNumber(value: size))
                let progress = sqrt(Double(size) / Double(totalSize))//sqrt for amplifying smoothing small volumes
                cell.progressView.progress = progress // >= 0.5 ? 1.0 : progress * 2
            } else {
                cell.amountLabel.text = "-"
                cell.progressView.progress = 0
            }
            if let price =  orderBook?.longEntries[i / 2].price {
                cell.priceLabel.text = String(format: "%.1f", price)
            } else {
                cell.priceLabel.text = String(format: "-")
            }
            cell.progressView.isBullish = true
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderBookShortEntryCVCell", for: indexPath) as! OBShortEntryCVCell
            if let size = orderBook?.shortEntries[(i - 1) / 2].size, let totalSize = orderBook?.totalSize(rows: orderBookRowCount) {
                cell.amountLabel.text = numberFormatter.string(from: NSNumber(value: size))
                let progress = sqrt(Double(size) / Double(totalSize))
                cell.progressView.progress = progress // >= 0.5 ? 1.0 : progress * 2
            } else {
                cell.amountLabel.text = "-"
                cell.progressView.progress = 0
            }
            if let price = orderBook?.shortEntries[(i - 1) / 2].price {
                cell.priceLabel.text = String(format: "%.1f", price)
            } else {
                cell.priceLabel.text = String(format: "-")
            }
            cell.progressView.isBullish = false
            return cell
        }
    }
    
    
    //MARK: - Text Fields
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case qtyTextField:
            fallthrough
        case priceTextField:
            fallthrough
        case leverageTextField:
            setCostLabelText()
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case leverageTextField:
            if let t = textField.text {
                if let d = Double(t) {
                    if d >= 0.0 && d <= 100.0 {
                        textField.resignFirstResponder()
                        return true
                    }
                } else {
                    textField.text = "10.0"
                }
            }
        default:
            break
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    private func setCostLabelText() {
        let instrument = app.getInstrument(app.settings.chartSymbol)!
        if let qtyStr = qtyTextField.text, let limitStr = priceTextField.text, let leverageStr = leverageTextField.text {
            if let qty = Double(qtyStr), let limit = Double(limitStr), let leverage = Double(leverageStr) {
                
                switch tradeTypeSegmentedControl.selectedSegmentIndex {
                case 0:
                    //MARKET
                    let markPrice = instrument.markPrice!
                    let cost = 1.00075 * qty / (markPrice * leverage)
                    costLabel.text = "Cost:\(String(format: "%.4f", cost))"
                case 1:
                    fallthrough
                case 2:
                    //LIMIT, STOP
                    let cost = 1.00025 * qty / (limit * leverage)
                    costLabel.text = "Cost: \(String(format: "%.4f", cost))"
                default:
                    break
                }
            }
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
    @IBAction func tradeTypeChanged(_ sender: Any) {
        _tradeTypeChanged()
    }
    
    func postOrder(side: String) {
        let instrument = app.getInstrument(app.settings.chartSymbol)!
        if let qtyStr = qtyTextField.text, let priceStr = priceTextField.text, let leverageStr = leverageTextField.text {
            if let qty = Double(qtyStr), let price = Double(priceStr), let leverage = Double(leverageStr) {
                if leverage < 0 || leverage > 100 {
                    return
                }
                
                switch tradeTypeSegmentedControl.selectedSegmentIndex {
                case 0:
                    //MARKET
                    let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                        alert.dismiss(animated: true) {
                            
                            Order.POST(authentication: self.app.authentication!, symbol: instrument.symbol, side: side, orderQty: qty, price: nil, displayQty: nil, stopPx: nil, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Market, timeInForce: nil, execInst: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
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
                                                        if l != leverage {
                                                            self.changePositionLeverage(leverage: leverage)
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
                    
                case 1:
                    //LIMIT
                    let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                        alert.dismiss(animated: true) {
                            Order.POST(authentication: self.app.authentication!, symbol: instrument.symbol, side: side, orderQty: qty, price: price, displayQty: nil, stopPx: nil, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Limit, timeInForce: nil, execInst: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
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
                                                        if l != leverage {
                                                            self.changePositionLeverage(leverage: leverage)
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
                case 2:
                    //Stop
                    let alert = UIAlertController(title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                        alert.dismiss(animated: true) {
                            Order.POST(authentication: self.app.authentication!, symbol: instrument.symbol, side: side, orderQty: qty, price: nil, displayQty: nil, stopPx: price, clOrdID: nil, pegOffsetValue: nil, pegPriceType: nil, ordType: Order.OrderType.Stop, timeInForce: nil, execInst: nil, text: nil) { (optionalOrder, optionalResponse, optionalError) in
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
                                                        if l != leverage {
                                                            self.changePositionLeverage(leverage: leverage)
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
    
    private func _tradeTypeChanged() {
        switch tradeTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            //MARKET
            priceTextField.isEnabled = false
            priceTextField.alpha = 0.2
        case 1:
            //LIMIT
            priceTextField.isEnabled = true
            priceTextField.alpha = 1.0
        case 2:
            //STOP_LIMIT
            priceTextField.isEnabled = true
            priceTextField.alpha = 1.0
            break
        default:
            break
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
extension TradeVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 20)
    }
    
}
