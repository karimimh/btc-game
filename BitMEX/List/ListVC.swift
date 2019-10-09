//
//  ListVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/23/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var accountBBI: UIBarButtonItem!
    @IBOutlet weak var sortBBI: UIBarButtonItem!
    
    //MARK: Properties
    var app: App!
    
    
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
    }
    

    //MARK: - CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app.activeInstruments.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCVCell", for: indexPath) as! ListCVCell
        let instrument = app.getSortedActiveInstruments()[indexPath.row]
        let symbol = instrument.symbol
        cell.symbolLabel.text = symbol
        if let lastPrice = instrument.lastPrice {
            cell.priceLabel.text = instrument.priceFormatted(lastPrice)
            
            if let openPrice = instrument.prevClosePrice {
                if openPrice > 0 {
                    let change = 100.0 * (lastPrice - openPrice) / openPrice
                    cell.changeLabel.text = String(format: "%.2f%%", change)
                    cell.changeLabel.textColor = UIColor.white
                    if change >= 0 {
                        cell.priceLabel.textColor = App.BullColor
                        cell.changeLabel.backgroundColor = App.BullColor
                    } else {
                        cell.priceLabel.textColor = App.BearColor
                        cell.changeLabel.backgroundColor = App.BearColor
                    }
                    cell.changeLabel.layer.masksToBounds = true
                    cell.changeLabel.layer.cornerRadius = 7.5
                    cell.changeLabel.isHidden = false
                }
            }
        } else {
            cell.priceLabel.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let instrument = app.getSortedActiveInstruments()[indexPath.row]
        app.settings.chartSymbol = instrument.symbol
        app.chartNeedsSetupOnViewAppeared = true
        app.settings.chartLatestX = UIScreen.main.bounds.width * 0.75
        app.saveSettings()
        tabBarController?.selectedIndex = 1
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let nc as UINavigationController:
            if let sortVC = nc.viewControllers.first! as? SortVC {
                sortVC.listVC = self
            }
        default:
            break
        }
    }
    
}


// MARK: - Collection View Flow Layout Delegate
extension ListVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: collectionView.bounds.width / 2, height: 90)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 90)
        }
    }
    
}
