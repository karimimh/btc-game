//
//  LayerSettingsVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/23/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class LayerSettingsVC: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var app: App!
    var chart: Chart? {
        return app.chart
    }
    var indicator: Indicator?
    var horizontalLine: HorizontalLine?
    var trendline: Trendline?
    var fib: FibRetracement?
    var chartVC: ChartVC? {
        return app.chartVC
    }
    
    var isShowing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            self.app = delegate.app
        }
        
        navBar.addShadow(color: .lightGray, opacity: 0.4, shadowRadius: 0.5, offset: CGSize(width: 0.5, height: 0.5))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        
        tableView.allowsSelection = false
    }
    
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        guard let chartVC = parent as? ChartVC else { return }
        
        isShowing = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: chartVC.layersContainerView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: chartVC.layersContainerView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: chartVC.layersContainerView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: chartVC.layersContainerView.bottomAnchor).isActive = true
        
        tableView.reloadData()
        
        var frameHeight = navBar.bounds.height + tableView.contentSize.height
        if frameHeight > chartVC.chart.bounds.height {
            frameHeight = chartVC.chart.bounds.height
        }
        
        
        UIView.animate(withDuration: app.viewAnimationDuration) {
            chartVC.layersContainerView.frame = CGRect(x: chartVC.chart.bounds.width - 250.0, y: chartVC.chart.bounds.height - frameHeight, width: 250.0, height: frameHeight)
        }

    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            isShowing = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.indicator = nil
        self.horizontalLine = nil
        self.trendline = nil
        self.fib = nil
        willMove(toParent: nil)
        if let v = self.view {
            v.removeFromSuperview()
        }
        self.chartVC!.layersVC.didMove(toParent: self.chartVC!)
    }
    
}

extension LayerSettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let indicator = self.indicator {
            return indicator.getSettings().count
        } else if let _ = horizontalLine {
            return 3
        } else if let _ = trendline {
            return 4
        } else if let _ = fib {
            return 4 + FibRetracement.Levels.all().count
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let horizontalLine = self.horizontalLine {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Price"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val += 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    horizontalLine.price = val
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val -= 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    horizontalLine.price = val
                    self.app.chart?.redraw()
                }
                let value = horizontalLine.price
                cell.textField.text = String.init(format: "%.1f", value)
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard val > 0 else { cell.textField.text = String.init(format: "%.1f", value); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    horizontalLine.price = val
                    self.app.chart?.redraw()
                }
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Linewidth"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val <= 10.0 && val > 0 else { return }
                    val += 0.5
                    guard val <= 10.0 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    horizontalLine.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val <= 10.0 && val > 0 else { return }
                    val -= 0.5
                    guard val <= 10.0 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    horizontalLine.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                let value = horizontalLine.lineWidth
                cell.textField.text = String.init(format: "%.1f", Double(value))
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    guard val <= 10.0 && val > 0 else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    horizontalLine.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = "Color"
                cell.currentColor = horizontalLine.color
                cell.colorChangedCompletion = { color in
                    horizontalLine.color = color
                    self.app.chart?.redraw()
                }
                return cell
            }
            
        } else if let trendline = self.trendline {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Price_1"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val += 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.start.1 = val
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val -= 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.start.1 = val
                    self.app.chart?.redraw()
                }
                let value = trendline.start.1
                cell.textField.text = String.init(format: "%.1f", value)
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard val > 0 else { cell.textField.text = String.init(format: "%.1f", value); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.start.1 = val
                    self.app.chart?.redraw()
                }
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Price_2"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val += 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.end.1 = val
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val -= 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.end.1 = val
                    self.app.chart?.redraw()
                }
                let value = trendline.end.1
                cell.textField.text = String.init(format: "%.1f", value)
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard val > 0 else { cell.textField.text = String.init(format: "%.1f", value); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.end.1 = val
                    self.app.chart?.redraw()
                }
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Linewidth"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val <= 10.0 && val > 0 else { return }
                    val += 0.5
                    guard val <= 10.0 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val <= 10.0 && val > 0 else { return }
                    val -= 0.5
                    guard val <= 10.0 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                let value = trendline.lineWidth
                cell.textField.text = String.init(format: "%.1f", Double(value))
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    guard val <= 10.0 && val > 0 else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    trendline.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = "Color"
                cell.currentColor = trendline.color
                cell.colorChangedCompletion = { color in
                    trendline.color = color
                    self.app.chart?.redraw()
                }
                return cell
            }
        } else if let fib = self.fib {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Price_1"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val += 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.start.1 = val
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val -= 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.start.1 = val
                    self.app.chart?.redraw()
                }
                let value = fib.start.1
                cell.textField.text = String.init(format: "%.1f", value)
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard val > 0 else { cell.textField.text = String.init(format: "%.1f", value); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.start.1 = val
                    self.app.chart?.redraw()
                }
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Price_2"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val += 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.end.1 = val
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val > 0 else { return }
                    val -= 0.5
                    guard val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.end.1 = val
                    self.app.chart?.redraw()
                }
                let value = fib.end.1
                cell.textField.text = String.init(format: "%.1f", value)
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", value); return }
                    guard val > 0 else { cell.textField.text = String.init(format: "%.1f", value); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.end.1 = val
                    self.app.chart?.redraw()
                }
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Linewidth"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val <= 10.0 && val > 0 else { return }
                    val += 0.5
                    guard val <= 10.0 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val <= 10.0 && val > 0 else { return }
                    val -= 0.5
                    guard val <= 10.0 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                let value = fib.lineWidth
                cell.textField.text = String.init(format: "%.1f", Double(value))
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    guard val <= 10.0 && val > 0 else { cell.textField.text = String.init(format: "%.1f", Double(value)); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    fib.lineWidth = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = "Color"
                cell.currentColor = fib.color
                cell.colorChangedCompletion = { color in
                    fib.color = color
                    self.app.chart?.redraw()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckMarkTVCell.identidier, for: indexPath) as! CheckMarkTVCell
                let level: Double = FibRetracement.Levels.all()[indexPath.row - 4]
                cell.label.text = "Level \(level)"
                cell.switchValueChanged = { isOn in
                    if fib.levels.contains(level) && !isOn {
                        let index = fib.levels.firstIndex(of: level)
                        if let i = index {
                            fib.levels.remove(at: i)
                        }
                    } else if !fib.levels.contains(level) && isOn {
                        fib.levels.append(level)
                    }
                    self.app.chart?.redraw()
                }
                if fib.levels.contains(level) {
                    cell.switch.isOn = true
                } else {
                    cell.switch.isOn = false
                }
                
                return cell
            }
        } else if let indicator = self.indicator {
            let (key, value): (String, Any) = indicator.getSettings()[indexPath.row]
            
            if key.contains(Indicator.InputKey.length) {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = key.capitalized
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Int(text) else { return }
                    guard val <= 1000 && val > 0 else { return }
                    val += 1
                    guard val <= 1000 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%d", val)
                    indicator.inputs[key] = val
                    indicator.computeValue(candles: self.app.chart!.candles.reversed())
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Int(text) else { return }
                    guard val <= 1000 && val > 0 else { return }
                    val -= 1
                    guard val <= 1000 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%d", val)
                    indicator.inputs[key] = val
                    indicator.computeValue(candles: self.app.chart!.candles.reversed())
                    self.app.chart?.redraw()
                }
                cell.textField.text = String.init(format: "%d", value as! Int)
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%d", value as! Int); return }
                    guard let val = Int(text) else { cell.textField.text = String.init(format: "%d", value as! Int); return }
                    guard val <= 1000 && val > 0 else { cell.textField.text = String.init(format: "%d", value as! Int); return }
                    cell.textField.text = String.init(format: "%d", val)
                    indicator.inputs[key] = val
                    indicator.computeValue(candles: self.app.chart!.candles.reversed())
                    self.app.chart?.redraw()
                }
                return cell
            } else if key.contains(Indicator.InputKey.method) {
                let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTVCell.identidier, for: indexPath) as! DropDownTVCell
                cell.context = app.chart
                cell.label.text = key.capitalized
                cell.menuTitles = Indicator.Method.all()
                cell.mainButton.setTitle(value as? String, for: .normal)
                cell.selectedTitle = value as! String
                cell.menuItemSelectedCompletion = { str in
                    indicator.inputs[key] = str
                    indicator.computeValue(candles: self.app.chart!.candles.reversed())
                    self.app.chart?.redraw()
                }
                return cell
            } else if key.contains(Indicator.InputKey.bullish) {
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckMarkTVCell.identidier, for: indexPath) as! CheckMarkTVCell
                cell.label.text = key.capitalized
                cell.switchValueChanged = { isOn in
                    indicator.inputs[key] = isOn
                    indicator.computeValue(candles: self.app.chart!.candles.reversed())
                    self.app.chart?.redraw()
                }
                return cell
            } else if key.contains(Indicator.InputKey.source) {
                let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTVCell.identidier, for: indexPath) as! DropDownTVCell
                cell.context = app.chart
                cell.label.text = key.capitalized
                cell.menuTitles = Indicator.Source.all()
                cell.mainButton.setTitle(value as? String, for: .normal)
                cell.selectedTitle = value as! String
                cell.menuItemSelectedCompletion = { str in
                    indicator.inputs[key] = str
                    indicator.computeValue(candles: self.app.chart!.candles.reversed())
                    self.app.chart?.redraw()
                }
                return cell
            } else if key.contains(Indicator.StyleKey.color) {
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = key.capitalized
                cell.currentColor = value as! UIColor
                cell.colorChangedCompletion = { color in
                    indicator.style[key] = color
                    self.app.chart?.redraw()
                }
                return cell
            } else if key.contains(Indicator.StyleKey.lineWidth) {
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = key.capitalized
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val <= 10.0 && val > 0 else { return }
                    val += 0.5
                    guard val <= 10.0 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    indicator.style[key] = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var val = Double(text) else { return }
                    guard val <= 10.0 && val > 0 else { return }
                    val -= 0.5
                    guard val <= 10.0 && val > 0 else { return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    indicator.style[key] = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                cell.textField.text = String.init(format: "%.1f", Double(value as! CGFloat))
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.1f", Double(value as! CGFloat)); return }
                    guard let val = Double(text) else { cell.textField.text = String.init(format: "%.1f", Double(value as! CGFloat)); return }
                    guard val <= 10.0 && val > 0 else { cell.textField.text = String.init(format: "%.1f", Double(value as! CGFloat)); return }
                    cell.textField.text = String.init(format: "%.1f", val)
                    indicator.style[key] = val.toCGFLoat()
                    self.app.chart?.redraw()
                }
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = "Bull Candle"
                cell.currentColor = app.settings.bullCandleColor
                cell.colorChangedCompletion = { color in
                    self.app.settings.bullCandleColor = color
                    self.app.chart?.redraw()
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = "Bear Candle"
                cell.currentColor = app.settings.bearCandleColor
                cell.colorChangedCompletion = { color in
                    self.app.settings.bearCandleColor = color
                    self.app.chart?.redraw()
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = "Background"
                cell.currentColor = app.settings.chartBackgroundColor
                
                cell.colorChangedCompletion = { color in
                    self.app.chart?.chartBackgroundColor = color
                    self.app.chart?.redraw()
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = "Grid Line"
                cell.currentColor = app.settings.gridLinesColor
                
                cell.colorChangedCompletion = { color in
                    self.app.settings.gridLinesColor = color
                    self.app.chart?.redraw()
                }
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTVCell.identidier, for: indexPath) as! ColorTVCell
                cell.label.text = "Price Line"
                cell.currentColor = app.settings.priceLineColor
                
                cell.colorChangedCompletion = { color in
                    self.app.settings.priceLineColor = color
                    self.app.chart?.redraw()
                }
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Top Margin"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var value = Double(text.split(separator: " ")[0]) else { return }
                    guard value <= 35.0 && value >= 0 else { return }
                    value += 0.5
                    guard value <= 35.0 && value >= 0 else { return }
                    cell.textField.text = String.init(format: "%.2f %%", value)
                    self.app.chart?.topMargin = value
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var value = Double(text.split(separator: " ")[0]) else { return }
                    guard value <= 35.0 && value >= 0 else { return }
                    value -= 0.5
                    guard value <= 35.0 && value >= 0 else { return }
                    cell.textField.text = String.init(format: "%.2f %%", value)
                    self.app.chart?.topMargin = value
                    self.app.chart?.redraw()
                }
                cell.textField.text = String.init(format: "%.2f %%", app.settings.chartTopMargin)
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.2f %%", self.app.settings.chartTopMargin); return }
                    
                    guard let value = Double(text) else { cell.textField.text = String.init(format: "%.2f %%", self.app.settings.chartTopMargin); return }
                    guard value <= 35.0 && value >= 0 else { cell.textField.text = String.init(format: "%.2f %%", self.app.settings.chartTopMargin); return }
                    cell.textField.text = String.init(format: "%.2f %%", value)
                    self.app.chart?.topMargin = value
                    self.app.chart?.redraw()
                }
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTVCell.identidier, for: indexPath) as! TextFieldTVCell
                cell.label.text = "Bottom Margin"
                cell.stepUpCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var value = Double(text.split(separator: " ")[0]) else { return }
                    guard value <= 35.0 && value >= 0 else { return }
                    value += 0.5
                    guard value <= 35.0 && value >= 0 else { return }
                    cell.textField.text = String.init(format: "%.2f %%", value)
                    self.app.chart?.bottomMargin = value
                    self.app.chart?.redraw()
                }
                cell.stepDownCompletion = {
                    guard let text = cell.textField.text else { return }
                    guard var value = Double(text.split(separator: " ")[0]) else { return }
                    guard value <= 35.0 && value >= 0 else { return }
                    value -= 0.5
                    guard value <= 35.0 && value >= 0 else { return }
                    cell.textField.text = String.init(format: "%.2f %%", value)
                    self.app.chart?.bottomMargin = value
                    self.app.chart?.redraw()
                }
                cell.textField.text = String.init(format: "%.2f %%", app.settings.chartBottomMargin)
                cell.textFieldValueChangedCompletion = { opText in
                    guard let text = opText else { cell.textField.text = String.init(format: "%.2f %%", self.app.settings.chartBottomMargin); return }
                    guard let value = Double(text) else { cell.textField.text = String.init(format: "%.2f %%", self.app.settings.chartBottomMargin); return }
                    guard value <= 35.0 && value >= 0 else { cell.textField.text = String.init(format: "%.2f %%", self.app.settings.chartBottomMargin); return }
                    cell.textField.text = String.init(format: "%.2f %%", value)
                    self.app.chart?.bottomMargin = value
                    self.app.chart?.redraw()
                }
                return cell
            case 7:
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckMarkTVCell.identidier, for: indexPath) as! CheckMarkTVCell
                cell.label.text = "Show Titles"
                cell.switchValueChanged = { isOn in
                    self.app.settings.showTitles = isOn
                    self.app.chart?.redraw()
                }
                cell.switch.isOn = self.app.settings.showTitles
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    //MARK: Cell Swipe Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let resetAction = UIContextualAction(style: .normal, title: "Reset") { (action, view, completion) in
            if let indicator = self.indicator {
                print(indicator.name)
            } else {
                switch indexPath.row {
                case 0:
                    let cell = tableView.cellForRow(at: indexPath) as! ColorTVCell
                    cell.colorView.backgroundColor = self.app.defaultSettings.bullCandleColor
                    self.app.settings.bullCandleColor = self.app.defaultSettings.bullCandleColor
                    completion(true)
                case 1:
                    let cell = tableView.cellForRow(at: indexPath) as! ColorTVCell
                    cell.colorView.backgroundColor = self.app.defaultSettings.bearCandleColor
                    self.app.settings.bearCandleColor = self.app.defaultSettings.bearCandleColor
                    completion(true)
                case 2:
                    let cell = tableView.cellForRow(at: indexPath) as! ColorTVCell
                    cell.colorView.backgroundColor = self.app.defaultSettings.chartBackgroundColor
                    self.app.settings.chartBackgroundColor = self.app.defaultSettings.chartBackgroundColor
                    completion(true)
                    
                case 3:
                    let cell = tableView.cellForRow(at: indexPath) as! ColorTVCell
                    cell.colorView.backgroundColor = self.app.defaultSettings.gridLinesColor
                    self.app.settings.gridLinesColor = self.app.defaultSettings.gridLinesColor
                    completion(true)
                case 4:
                    let cell = tableView.cellForRow(at: indexPath) as! ColorTVCell
                    cell.colorView.backgroundColor = self.app.defaultSettings.priceLineColor
                    self.app.settings.priceLineColor = self.app.defaultSettings.priceLineColor
                    completion(true)
                case 5:
                    let cell = tableView.cellForRow(at: indexPath) as! TextFieldTVCell
                    cell.textField.text = String.init(format: "%.2f %%", self.app.defaultSettings.chartTopMargin)
                    self.app.chart?.topMargin = self.app.defaultSettings.chartTopMargin
                    completion(true)
                case 6:
                    let cell = tableView.cellForRow(at: indexPath) as! TextFieldTVCell
                    cell.textField.text = String.init(format: "%.2f %%", self.app.defaultSettings.chartBottomMargin)
                    self.app.chart?.bottomMargin = self.app.defaultSettings.chartBottomMargin
                    completion(true)
                case 7:
                    let cell = tableView.cellForRow(at: indexPath) as! CheckMarkTVCell
                    cell.switch.isOn = self.app.defaultSettings.showTitles
                    self.app.settings.showTitles = self.app.defaultSettings.showTitles
                    completion(true)
                default:
                    break
                }
            }
        }
        resetAction.image = UIImage(systemName: "arrow.counterclockwise")
        resetAction.backgroundColor = .lightGray
        return UISwipeActionsConfiguration(actions: [resetAction])
    }
    
    
    //MARK: Scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //            hideKeyboard()
    }
    
    
    
    
}
