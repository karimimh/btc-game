//
//  AddLayerVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/24/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class AddLayerVC: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var app: App!
    var isShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            self.app = delegate.app
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
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
    
    
    //MARK: - Actions
    
    @IBAction func backBBITapped(_ sender: Any) {
        willMove(toParent: nil)
        if let v = self.view {
            v.removeFromSuperview()
        }
        app.chartVC!.layersVC.didMove(toParent: app.chartVC!)
    }
    
    
}

// MARK: - TableView Delegate
extension AddLayerVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Indicator.SystemName.all().count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTVCell", for: indexPath) as! SimpleTVCell
        cell.lbl.text = Indicator.SystemName.all()[indexPath.row]
        if Indicator.SystemName.all()[indexPath.row] == Indicator.SystemName.volume.rawValue {
            let indicators = app.chart!.indicators
            if indicators.contains(where: { (ind) -> Bool in
                return ind.name == Indicator.SystemName.volume.rawValue
            }) {
                cell.isUserInteractionEnabled = false
                cell.lbl.textColor = .lightGray
            } else {
                cell.isUserInteractionEnabled = true
                cell.lbl.textColor = .black
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = Indicator.SystemName.all()[indexPath.row]
        var indicator: Indicator?
        if name == Indicator.SystemName.volume.rawValue {
            indicator = Indicator.fromSystem(name: Indicator.SystemName.volume, row: 0, height: 20.0)
        } else if name == Indicator.SystemName.ma.rawValue {
            indicator = Indicator.fromSystem(name: Indicator.SystemName.ma, row: 0, height: 100.0)
        } else if name == Indicator.SystemName.rsi.rawValue {
            var r = 1
            if !app.chart!.indicators.isEmpty {
                r = app.chart!.indicators.last!.getRow() + 1
            }
            indicator = Indicator.fromSystem(name: Indicator.SystemName.rsi, row: r, height: 20.0)
        }
        if let ind = indicator {
            app.chart?.indicators.append(ind)
            app.chart?.sortIndicators()
            app.chart?.setupSubViews()
            
            willMove(toParent: nil)
            if let v = self.view {
                v.removeFromSuperview()
            }
            app.chartVC!.layersVC.didMove(toParent: app.chartVC!)
        }
    }
    
}
