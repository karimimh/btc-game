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
    
    @IBOutlet weak var valueBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var layersContainerView: UIView!
    @IBOutlet weak var layersButton: UIButton!
    var layersVC: LayersVC!
    var layerSettingsVC: LayerSettingsVC!
    var colorPickerVC: ColorPickerVC!
    var addLayerVC: AddLayerVC!
    
    @IBOutlet weak var timeframesContainer: UIView!
    @IBOutlet weak var timeframeBBI: UIBarButtonItem!
    @IBOutlet weak var symbolButton: UIBarButtonItem!
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
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGR.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGR)
        
        setupLayerView()
        setupTimeframesContainer()
        
        
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
    
    
}
