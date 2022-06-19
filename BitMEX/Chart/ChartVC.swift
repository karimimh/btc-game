//
//  ChartVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/1/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ChartVC: UIViewController {
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var priceView: PriceView!
    @IBOutlet weak var bottomViews: UIView!
    @IBOutlet weak var timeView: TimeView!
    @IBOutlet weak var valueBars: UIView!
    @IBOutlet weak var drawerBar: DrawerBar!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var priceTracker: PriceTracker!
    @IBOutlet weak var crosshair: Crosshair!
    @IBOutlet weak var guidelines: Guidlines!
    @IBOutlet weak var toolsView: ToolsView!
    
    @IBOutlet weak var valueBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var layersContainerView: UIView!
    @IBOutlet weak var layersButton: UIButton!
    var layersVC: LayersVC!
    var layerSettingsVC: LayerSettingsVC!
    var colorPickerVC: ColorPickerVC!
    var addLayerVC: AddLayerVC!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var trendlineBBI: UIBarButtonItem!
    @IBOutlet weak var horizontalLineBBI: UIBarButtonItem!
    @IBOutlet weak var fibBBI: UIBarButtonItem!
    
    @IBOutlet weak var timeframesContainer: UIView!
    @IBOutlet weak var timeframeBBI: UIBarButtonItem!
    @IBOutlet weak var symbolButton: UIBarButtonItem!
    @IBOutlet weak var currentTimeLabel: UILabel!
    var timeframeVC: TimeframeVC!
    var app: App!
    
    var viewDidLoadExecuted = false
    var activeDropDown: DropDownTVCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        app.chartVC = self
        chart.priceView = priceView
        chart.bottomViews = bottomViews
        chart.timeView = timeView
        chart.valueBarWidthConstraint = valueBarWidthConstraint
        chart.priceViewHeightConstraint = priceViewHeightConstraint
        chart.valueBars = valueBars
        chart.drawerBar = drawerBar
        chart.gridView = gridView
        chart.priceTracker = priceTracker
        chart.crosshair = crosshair
        chart.layersVC = layersVC
        chart.guidelines = guidelines
        chart.toolsView = toolsView
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGR.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGR)
        
        setupLayerView()
        setupTimeframesContainer()
        
        currentTimeLabel.text = app.game.currentTime.bitMEXStringWithSeconds()
        
        
        setToolButtonTint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if app.chartNeedsSetupOnViewAppeared {
            app.chartNeedsSetupOnViewAppeared = false
            chart.setupChart()
        }
    }
    
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        app.saveSettings()
    }
    
    
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: chart)
        if timeframeVC.isShowing {
            let f = CGRect(x: timeframesContainer.frame.origin.x, y: 0, width: timeframesContainer.bounds.width, height: timeframesContainer.bounds.height)
            if !f.contains(location) {
                toggleTimeframesSelector()
            }
        } else if !layersContainerView.isHidden && !layersButton.frame.contains(location) {
            layersContainerView.endEditing(true)
            if let dd = self.activeDropDown {
                if dd.isContextMenuShowing {
                    if !dd.buttonContainer.frame.contains(location) {
                        dd.hideContextMenu()
                    }
                }
            } else if !layersContainerView.frame.contains(location) {
                toggleLayersView()
            }

        }
    }
    
    @IBAction func showDrawerBar(_ sender: Any) {
        /*
        if drawerBar.isSubMenuShowing {
            drawerBar.toggleSubmenu {
                self.drawerBar.toggleMenu()
            }
        } else {
            drawerBar.toggleMenu()
        }
        */
    }
    
    
    //MARK: - Layers View
    private func setupLayerView() {
        layersContainerView.addShadow(color: .lightGray, opacity: 0.7, shadowRadius: 2.5, offset: .zero)
        
        layersVC = storyboard?.instantiateViewController(identifier: "LayersVC") as? LayersVC
        layerSettingsVC = storyboard?.instantiateViewController(identifier: "LayerSettingsVC") as? LayerSettingsVC
        colorPickerVC = storyboard?.instantiateViewController(identifier: "ColorPickerVC") as? ColorPickerVC
        addLayerVC = storyboard?.instantiateViewController(identifier: "AddLayerVC") as? AddLayerVC
        
        //Add as Child:
        addChild(layersVC)
        
        
        layersContainerView.addSubview(layersVC.view)
        layersVC.didMove(toParent: self)
    }
    
    
    
    
    
    @IBAction func layersButtonTapped(_ sender: Any) {
        toggleLayersView()
    }
    
    func toggleLayersView() {
        layersContainerView.isHidden = !layersContainerView.isHidden
        
        if !layersContainerView.isHidden {
            if colorPickerVC.isShowing {
                colorPickerVC.didMove(toParent: self)
            } else if layerSettingsVC.isShowing {
                layerSettingsVC.didMove(toParent: self)
            } else {
                layersVC.didMove(toParent: self)
            }
            let arr = chart.subviews
            for subview in arr {
                if subview != layersContainerView && subview != layersButton {
                    subview.isUserInteractionEnabled = false
                }
            }
            for gr in chart!.gestureRecognizers! {
                gr.isEnabled = false
            }
            
        } else {
            let arr = chart.subviews
            for subview in arr {
                if subview != layersContainerView && subview != layersButton {
                    subview.isUserInteractionEnabled = true
                }
            }
            for gr in chart!.gestureRecognizers! {
                gr.isEnabled = true
            }
        }
    }
    
    
    //MARK: - Timeframes
    private func setupTimeframesContainer() {
        timeframesContainer.addShadow(color: .lightGray, opacity: 0.7, shadowRadius: 2.5, offset: .zero)
        
        timeframeVC = storyboard?.instantiateViewController(identifier: "TimeframeVC") as? TimeframeVC
        
        //Add as Child:
        addChild(timeframeVC)
        
        
        timeframesContainer.addSubview(timeframeVC.view)
        timeframeVC.view.translatesAutoresizingMaskIntoConstraints = false
        timeframeVC.view.leadingAnchor.constraint(equalTo: timeframesContainer.leadingAnchor).isActive = true
        timeframeVC.view.trailingAnchor.constraint(equalTo: timeframesContainer.trailingAnchor).isActive = true
        timeframeVC.view.topAnchor.constraint(equalTo: timeframesContainer.topAnchor).isActive = true
        timeframeVC.view.bottomAnchor.constraint(equalTo: timeframesContainer.bottomAnchor).isActive = true

        timeframesContainer.frame = CGRect(x: timeframeBBI.xPositionInBar(), y: chart.frame.origin.y, width: 200, height: 0)
        timeframeVC.isShowing = false
        
        timeframeBBI.title = app.settings.chartTimeframe.pretty()
        
    }
    
    
    @IBAction func timeframeBBITapped(_ sender: Any) {
        toggleTimeframesSelector()
    }
    
    func toggleTimeframesSelector(_ hideCompletion: @escaping () -> Void = {}) {
        if !timeframeVC.isShowing {
            timeframeVC.didMove(toParent: self)
            chart.isUserInteractionEnabled = false
        } else {
            UIView.animate(withDuration: app.viewAnimationDuration, animations: {
                self.timeframesContainer.frame = CGRect(x: self.timeframeBBI.xPositionInBar(), y: self.chart.frame.origin.y, width: 200, height: 0)
                self.timeframesContainer.layoutIfNeeded()
            }) { (_) in
                self.timeframeVC.isShowing = false
                self.chart.isUserInteractionEnabled = true
                hideCompletion()
            }
            
        }
    }
    
    @IBAction func SymbolButtonTapped(_ sender: Any) {
        let listVC = storyboard?.instantiateViewController(identifier: "ListNavController") as? UINavigationController
        if let vc = listVC {
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func playBBITapped(_ sender: Any) {
        if !app.game.isPlaying {
            app.game.resume()
            playButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            app.game.pause()
            playButton.setImage(UIImage(systemName: "play"), for: .normal)
            app.saveSettings()
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        if !app.game.isPlaying {
            return
        }
        self.skipButton.isEnabled = false
        self.playButton.isEnabled = false
        app.game.pause()
        var nextOpenTime = app.game.currentTime.nextOpenTime(timeframe: chart.timeframe!)!
        if nextOpenTime.timeIntervalSince1970 - app.game.currentTime.timeIntervalSince1970 <= 2.0 {
            nextOpenTime = nextOpenTime.nextOpenTime(timeframe: chart.timeframe!)!
        }
        let newTime = Date(timeIntervalSince1970: nextOpenTime.timeIntervalSince1970 - 2.0)
        
        
        app.game.skipTime(from: app.game.currentTime, to: newTime) {
            self.app.game.currentTime = newTime
            self.app.game.tradeBuffer.removeAll()
            self.app.game.downloadNextTrades {
                DispatchQueue.main.async {
                    self.app.game.resume()
                }
            }
        }
    }
    @IBAction func trendlineBBITapped(_ sender: Any) {
        if chart.isDrawingHorizontalLine || chart.isDrawingFibRetracement {
            return
        }
        if !chart!.isDrawingHorizontalLine {
            chart!.crosshair?.isEnabled = false
        }
        chart!.isDrawingTrendline = !chart!.isDrawingTrendline
    }
    
    
    @IBAction func horizontalLineBBITapped(_ sender: Any) {
        if chart.isDrawingTrendline || chart.isDrawingFibRetracement {
            return
        }
        if !chart!.isDrawingHorizontalLine {
            chart!.crosshair?.isEnabled = false
        }
        
        chart!.isDrawingHorizontalLine = !chart!.isDrawingHorizontalLine
    }
    
    @IBAction func fibBBITapped(_ sender: Any) {
        if chart.isDrawingTrendline || chart.isDrawingHorizontalLine {
            return
        }
        if !chart!.isDrawingFibRetracement {
            chart!.crosshair?.isEnabled = false
        }
        chart!.isDrawingFibRetracement = !chart.isDrawingFibRetracement
    }
    
    
    //Tools Bar functions:
    func setToolButtonTint() {
        if chart.isDrawingHorizontalLine {
            horizontalLineBBI.tintColor = .black
        } else {
            horizontalLineBBI.tintColor = .gray
        }
        if chart.isDrawingTrendline {
            trendlineBBI.tintColor = .black
        } else {
            trendlineBBI.tintColor = .gray
        }
        if chart.isDrawingFibRetracement {
            fibBBI.tintColor = .black
        } else {
            fibBBI.tintColor = .gray
        }
    }
    
}
