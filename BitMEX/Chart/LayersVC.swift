//
//  LayersVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/23/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class LayersVC: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBBI: UIBarButtonItem!
    @IBOutlet weak var addBBI: UIBarButtonItem!
    @IBOutlet weak var showDrawingsBBI: UIBarButtonItem!
    
    @IBOutlet weak var fitButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    var app: App!
    
    var isShowingDrawings: Bool = false
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            self.app = delegate.app
        }
        
        navBar.addShadow(color: .lightGray, opacity: 0.4, shadowRadius: 0.5, offset: CGSize(width: 0.5, height: 0.5))
        
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        
        fitButton.addBorders(edges: .init(arrayLiteral: .top, .right, .bottom), color: App.BullColor, width: 1)
        fitButton.addBorders(edges: .left, color: App.BullColor, width: 0.5)
        
        logButton.addBorders(edges: .init(arrayLiteral: .top, .left, .bottom), color: App.BullColor, width: 1)
        logButton.addBorders(edges: .right, color: App.BullColor, width: 0.5)
        setToolButtonTint()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        guard let chartVC = parent as? ChartVC else { return }
        
        if app.settings.chartAutoScale {
            fitButton.backgroundColor = App.BullColor
            fitButton.setTitleColor(.white, for: .normal)
        } else {
            fitButton.backgroundColor = .white
            fitButton.setTitleColor(App.BullColor, for: .normal)
        }
        
        if app.settings.chartLogScale {
            logButton.backgroundColor = App.BullColor
            logButton.setTitleColor(.white, for: .normal)
        } else {
            logButton.backgroundColor = .white
            logButton.setTitleColor(App.BullColor, for: .normal)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: chartVC.layersContainerView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: chartVC.layersContainerView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: chartVC.layersContainerView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: chartVC.layersContainerView.bottomAnchor).isActive = true
        tableView.reloadData()
        
        var frameHeight = navBar.bounds.height + tableView.contentSize.height + chartVC.layersButton.bounds.height + 1
        if frameHeight > chartVC.chart.bounds.height {
            frameHeight = chartVC.chart.bounds.height
        }
        
        
        UIView.animate(withDuration: app.viewAnimationDuration) {
            chartVC.layersContainerView.frame = CGRect(x: chartVC.chart.bounds.width - 250.0, y: chartVC.chart.bounds.height - frameHeight, width: 250.0, height: frameHeight)
        }
        
    }
    
    
    
    
    //MARK: - Actions
    @IBAction func fitButtonTapped(_ sender: Any) {
        app.settings.chartAutoScale = !app.settings.chartAutoScale
        if app.settings.chartAutoScale {
            fitButton.backgroundColor = App.BullColor
            fitButton.setTitleColor(.white, for: .normal)
        } else {
            fitButton.backgroundColor = .white
            fitButton.setTitleColor(App.BullColor, for: .normal)
        }

        app.chart?.redraw()
    }
    
    @IBAction func logButtonTapped(_ sender: Any) {
        app.settings.chartLogScale = !app.settings.chartLogScale
        if app.settings.chartLogScale {
            logButton.backgroundColor = App.BullColor
            logButton.setTitleColor(.white, for: .normal)
        } else {
            logButton.backgroundColor = .white
            logButton.setTitleColor(App.BullColor, for: .normal)
        }
        
        app.chart?.redraw()
    }
    
    //MARK: - Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    
    @IBAction func editBBITapped(_ sender: Any) {
        if !isEditing {
            setEditing(true, animated: true)
            addBBI.isEnabled = false
            editBBI.title = "Done"
        } else {
            setEditing(false, animated: true)
            app.chart?.sortIndicators()
            app.chart?.setupSubViews()
            addBBI.isEnabled = true
            editBBI.title = "Edit"
            didMove(toParent: app.chartVC)
        }
    }
    
    @IBAction func addBBITapped(_ sender: Any) {
        guard let chartVC = app.chartVC else { return }
        let addLayerVC = chartVC.addLayerVC!
        let containerView = chartVC.layersContainerView!
        
        chartVC.addChild(addLayerVC)
        containerView.addSubview(addLayerVC.view)
        addLayerVC.didMove(toParent: chartVC)
    }
    
    @IBAction func showDrawingsBBI(_ sender: Any) {
        self.isShowingDrawings = !self.isShowingDrawings
        self.tableView.reloadData()
        self.didMove(toParent: app.chartVC!)
    }
    
    //Tools Bar functions:
    func setToolButtonTint() {
        if isShowingDrawings {
            showDrawingsBBI.tintColor = .black
        } else {
            showDrawingsBBI.tintColor = .gray
        }
    }
}

// MARK: - TableView Delegate
extension LayersVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingDrawings {
            return 1 + app.chart!.horizontalLines.count + app.chart!.trendlines.count + app.chart!.fibs.count
        }
        return 1 + app.chart!.indicators.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LayerTVCell", for: indexPath) as! LayerTVCell
        
        let section = indexPath.section, row = indexPath.row
        if (section, row) == (0, 0) {
            cell.label.text = app.chart!.instrument!.symbol.uppercased()
//            cell.previewIV.image = app.chart?.priceView?.getPreviewImage()
            return cell
        }
        
        if isShowingDrawings {
            let horizontalLines = getHorizontalLines()
            let trendlines = getTrendlines()
            let fibs = getFibs()
            if row - 1 < horizontalLines.count {
                let line = horizontalLines[row - 1]
                cell.label.text = "HorizontalLine(\(app.chart!.instrument!.priceFormatted(line.price)))"
            } else if row - 1 < horizontalLines.count + trendlines.count {
                let line = trendlines[row - horizontalLines.count - 1]
                cell.label.text = "Trendline(\(app.chart!.instrument!.priceFormatted(line.start.1)), \(app.chart!.instrument!.priceFormatted(line.end.1)))"
            } else {
                let line = fibs[row - horizontalLines.count - trendlines.count - 1]
                cell.label.text = "Fib(\(app.chart!.instrument!.priceFormatted(line.start.1)), \(app.chart!.instrument!.priceFormatted(line.end.1)))"
            }
        } else {
            let indicator = app.chart!.indicators[row - 1]
            cell.label.text = indicator.getNameInFunctionForm()
//            if app.chart!.indicatorViews.count > row - 1 {
//                DispatchQueue.main.async {
//                    let image = self.generatePreviewImage(of: self.app.chart!.indicatorViews[row - 1])
//                    cell.previewIV.image = image
//                   tableView.reloadData()
//                }
//
//            }
                
            
        }
        
        
        return cell
    }
    
    private func getHorizontalLines() -> [HorizontalLine] {
        var result = [HorizontalLine]()
        for line in app.settings.horizontalLines {
            if line.timeframe == app.settings.chartTimeframe {
                result.append(line)
            }
        }
        return result
    }
    private func getTrendlines() -> [Trendline] {
        var result = [Trendline]()
        for line in app.settings.trendlines {
            if line.timeframe == app.settings.chartTimeframe {
                result.append(line)
            }
        }
        return result
    }
    private func getFibs() -> [FibRetracement] {
        var result = [FibRetracement]()
        for line in app.settings.fibs {
            if line.timeframe == app.settings.chartTimeframe {
                result.append(line)
            }
        }
        return result
    }
    
    //MARK: Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chartVC = app.chartVC else { return }
        chartVC.addChild(chartVC.layerSettingsVC)
        let section = indexPath.section, row = indexPath.row
        
        
        if isShowingDrawings {
            let horizontalLines = getHorizontalLines()
            let trendlines = getTrendlines()
            let fibs = getFibs()
            if row - 1 < horizontalLines.count {
                let line = horizontalLines[row - 1]
                chartVC.layerSettingsVC.horizontalLine = line
                chartVC.layersContainerView.addSubview(chartVC.layerSettingsVC.view)
                chartVC.layerSettingsVC.didMove(toParent: chartVC)
            } else if row - 1 < horizontalLines.count + trendlines.count {
                let line = trendlines[row - horizontalLines.count - 1]
                chartVC.layerSettingsVC.trendline = line
                chartVC.layersContainerView.addSubview(chartVC.layerSettingsVC.view)
                chartVC.layerSettingsVC.didMove(toParent: chartVC)

            } else {
                let line = fibs[row - horizontalLines.count - trendlines.count - 1]
                chartVC.layerSettingsVC.fib = line
                chartVC.layersContainerView.addSubview(chartVC.layerSettingsVC.view)
                chartVC.layerSettingsVC.didMove(toParent: chartVC)

            }
        } else {
            var indicator: Indicator?
            if (section, row) != (0, 0) {
                indicator = app.chart!.indicators[row - 1]
            }
            chartVC.layerSettingsVC.indicator = indicator
            chartVC.layersContainerView.addSubview(chartVC.layerSettingsVC.view)
            chartVC.layerSettingsVC.didMove(toParent: chartVC)
        }
    }
    
    //MARK: Editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section, row = indexPath.row
        return  (section, row) != (0, 0)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if editingStyle == .delete {
            if isShowingDrawings {
                let horizontalLines = getHorizontalLines()
                let trendlines = getTrendlines()
                if row - 1 < horizontalLines.count {
                    app.chart!.horizontalLines.remove(at: row - 1)
                } else if row - 1 < horizontalLines.count + trendlines.count {
                    app.chart!.trendlines.remove(at: row - 1 - horizontalLines.count)
                } else {
                    app.chart!.fibs.remove(at: row - 1 - horizontalLines.count - trendlines.count)
                }
                tableView.reloadData()
                didMove(toParent: app.chartVC)
                app.chart?.setupSubViews()
            } else {
                
                let indicator: Indicator = app.chart!.indicators[row - 1]
                let indicatorRow = indicator.getRow()
                app.chart?.indicators.remove(at: row - 1)
                if app.chart!.getIndicatorsIn(row: indicatorRow).isEmpty {
                    for ind in app.chart!.indicators {
                        if ind.getRow() > indicatorRow {
                            let newRow = ind.getRow() - 1
                            ind.style[Indicator.StyleKey.row] = newRow
                        }
                    }
                }
                app.chart?.sortIndicators()
                tableView.reloadData()
                didMove(toParent: app.chartVC)
                app.chart?.setupSubViews()
            }
        }
    }
    
    
    //MARK: Rearranging
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath != .init(row: 0, section: 0) && !isShowingDrawings
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return sourceIndexPath
        }
        let srcIndicator = app.chart!.indicators[sourceIndexPath.row - 1]
        let dstIndicator = app.chart!.indicators[proposedDestinationIndexPath.row - 1]
        
        let srcRow = srcIndicator.getRow()
        let dstRow = dstIndicator.getRow()
        
        if srcRow != dstRow && (srcRow == 0 || dstRow == 0) {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let srcIndicator = app.chart!.indicators[sourceIndexPath.row - 1]
        let dstIndicator = app.chart!.indicators[destinationIndexPath.row - 1]
        
        let srcRow = srcIndicator.getRow()
        let dstRow = dstIndicator.getRow()
        
        let srcZ = srcIndicator.style[Indicator.StyleKey.zIndex] as! Double
        let dstZ = dstIndicator.style[Indicator.StyleKey.zIndex] as! Double
        
        if sourceIndexPath.section == destinationIndexPath.section {
            srcIndicator.style[Indicator.StyleKey.zIndex] = dstZ
            dstIndicator.style[Indicator.StyleKey.zIndex] = srcZ
        } else {
            srcIndicator.style[Indicator.StyleKey.row] = dstRow
            dstIndicator.style[Indicator.StyleKey.row] = srcRow
        }
        
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        
    }
    
    
//    //MARK: Layer Preview Generation
//
//    func generatePreviewImage(of indicatorView: IndicatorView) -> UIImage {
//        let wFactor = app.chart!.bounds.width / indicatorView.bounds.width
//        let hFactor = app.chart!.bounds.height / indicatorView.bounds.height
//        let yFactor: CGFloat = (indicatorView.frame.origin.y > 0) ? app.chart!.bounds.height / indicatorView.frame.origin.y : 0.0
//
//        let width: CGFloat = 150.0
//        let height: CGFloat = 50.0
//
//        let chartSize = CGSize(width: width * wFactor, height: height * hFactor)
//        let chartRect = CGRect(origin: .zero, size: chartSize)
//
//        let chart = Chart(frame: chartRect)
//
//
//
//        UIGraphicsBeginImageContext(chartSize)
//        app.chart!.draw(chartRect)
//        let image =  UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        let cropRect = CGRect(x: 0, y: height * yFactor, width: width, height: height)
//        let im = image.cgImage!.cropping(to: cropRect)!
//        return UIImage(cgImage: im)
//    }
//
//
}
