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
    @IBOutlet weak var settingsView: ChartSettings!
    
    @IBOutlet weak var valueBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!
    
    
    var app: App!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        app.chart = self.chart
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
        chart.settingsView = settingsView
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGR.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGR)
        
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
        if chart.isSettingsViewShowing {
            settingsView.hideKeyboard()
            if chart.isContextMenuShowing {
                if !chart.buttonContainer.frame.contains(location) {
                    chart.hideContextMenu()
                }
            } else if settingsView.currentColorPicker != nil, settingsView.currentColorPicker!.isShowing {
                let loc = sender.location(in: view)
                if !settingsView.currentColorPicker!.frame.contains(loc) {
                    settingsView.currentColorPicker!.hide()
                }
            } else if !settingsView.frame.contains(location) {
                settingsView.hide()
            }
            
        }
    }
    
    
}
