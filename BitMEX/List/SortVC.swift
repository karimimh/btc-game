//
//  SortVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/5/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class SortVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Properties
    var app: App!
    var listVC: ListVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
    }
    

    
    //MARK: - CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? SortBy.all().count : SortDirection.all().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortCVCell", for: indexPath) as! SortCVCell
            cell.label.text = SortBy.all()[indexPath.row]
            if indexPath.row == app.settings.sortBy.rawValue {
                cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            } else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortCVCell", for: indexPath) as! SortCVCell
            cell.label.text = SortDirection.all()[indexPath.row]
            if indexPath.row == app.settings.sortDirection.rawValue {
                cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            } else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SortCVHeader", for: indexPath) as! SortCVHeader
            header.label.text = "Sort By"
            return header
        default:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SortCVHeader", for: indexPath) as! SortCVHeader
            header.label.text = "Sort Direction"
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let previousSortBy = app.settings.sortBy.rawValue
            let sortBy: SortBy = SortBy(rawValue: indexPath.row)!
            app.settings.sortBy = sortBy
            
            let prevCell: SortCVCell = collectionView.cellForItem(at: IndexPath(row: previousSortBy, section: 0)) as! SortCVCell
            prevCell.backgroundColor = .white
            let newCell: SortCVCell = collectionView.cellForItem(at: indexPath) as! SortCVCell
            newCell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        } else {
            let previousSortDirection = app.settings.sortDirection.rawValue
            let sortDirection: SortDirection = SortDirection(rawValue: indexPath.row)!
            app.settings.sortDirection = sortDirection
            
            let prevCell: SortCVCell = collectionView.cellForItem(at: IndexPath(row: previousSortDirection, section: 1)) as! SortCVCell
            prevCell.backgroundColor = .white
            let newCell: SortCVCell = collectionView.cellForItem(at: indexPath) as! SortCVCell
            newCell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        
    }
    
    

    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.listVC!.collectionView.reloadData()
        }
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension SortVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: collectionView.bounds.width / 2, height: 50)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 50)
        }
    }
    
    
}
