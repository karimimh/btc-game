//
//  ToolsVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 8/29/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ToolsVC: UIViewController {
    //MARK: - Properties
    var app: App!
    var isShowing = false
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - View LifeCycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        view.backgroundColor = .clear
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        guard let chartVC = parent as? ChartVC else { return }
        
        isShowing = true
        
        UIView.animate(withDuration: app.viewAnimationDuration, animations: {
            chartVC.timeframesContainer.frame = CGRect(x: chartVC.timeframeBBI.xPositionInBar(), y: chartVC.chart.frame.origin.y, width: 200, height: 150)
            chartVC.timeframesContainer.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
}


//MARK: - Timeframe CollectionView Delegate
extension ToolsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeframeCVCell", for: indexPath) as! TimeframeCVCell
        let timeframe = TimeframeVC.ALL_TIMEFRAMES[indexPath.row]
        cell.lbl.text = timeframe.pretty()
        
        if timeframe == app.settings.chartTimeframe {
            cell.backgroundColor = App.BullColor
        } else {
            cell.backgroundColor = .clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevGameStatus = app.game.isPlaying
        self.app.game.pause()
        let r = TimeframeVC.ALL_TIMEFRAMES.firstIndex(of: app.settings.chartTimeframe)!
        let previousSelectedCell = collectionView.cellForItem(at: IndexPath(row: r, section: 0)) as! TimeframeCVCell
        previousSelectedCell.backgroundColor = .clear
        
        let t = TimeframeVC.ALL_TIMEFRAMES[indexPath.row]
        let currentCell = collectionView.cellForItem(at: indexPath) as! TimeframeCVCell
        currentCell.backgroundColor = App.BullColor
        
        
        app.settings.chartTimeframe = t
        app.chartVC?.timeframeBBI.title = t.pretty()
        app.chartVC?.toggleTimeframesSelector {
            self.app.chart?.setupChart()
            if prevGameStatus {
                self.app.game.resume()
            }
        }
    }
}


extension ToolsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
