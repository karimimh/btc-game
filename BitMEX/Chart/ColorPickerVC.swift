//
//  ColorPickerVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/23/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ColorPickerVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var opacityValueLabel: UILabel!
    @IBOutlet weak var rgbTextField: UITextField!
    @IBOutlet weak var previewView: UIView!
    
    //MARK: - Properties
    var app: App!
    static let ALL_COLORS: [UIColor] = [
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1), #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1), #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1), #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1), #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1), #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1),
        #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1), #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1), #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1), #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1), #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1),
        #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1),
        #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1), #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1), #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1), #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1), #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
    ]
    
    var colorChangedCompletion: ((UIColor) -> Void)?
    var currentColor = UIColor.black {
        didSet {
            rgbTextField.text = currentColor.toHex()!
            previewView.backgroundColor = currentColor.withAlphaComponent(currentAlpha)
            colorChangedCompletion?(currentColor.withAlphaComponent(currentAlpha))
        }
    }
    var currentAlpha: CGFloat = 1.0 {
        didSet {
            previewView.backgroundColor = currentColor.withAlphaComponent(currentAlpha)
            colorChangedCompletion?(currentColor.withAlphaComponent(currentAlpha))
        }
    }
    
    var isShowing = false
    
    

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        navBar.addShadow(color: .lightGray, opacity: 0.4, shadowRadius: 0.5, offset: CGSize(width: 0.5, height: 0.5))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        rgbTextField.delegate = self
        
        previewView.layer.cornerRadius = 4.0
        previewView.layer.borderColor = UIColor.black.cgColor
        previewView.layer.borderWidth = 1.0
        
        
        opacitySlider.isContinuous = false
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard let chartVC = parent as? ChartVC else { return }
        
        isShowing = true
        collectionView.reloadData()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: chartVC.layersContainerView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: chartVC.layersContainerView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: chartVC.layersContainerView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: chartVC.layersContainerView.bottomAnchor).isActive = true
        
        var frameHeight = navBar.bounds.height + collectionView.contentSize.height + 105
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
    
    
    
    //MARK: - Opacity Slider
    @IBAction func opacitySliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            currentAlpha = CGFloat(slider.value)
            opacityValueLabel.text = "\(Int(currentAlpha * 100.0))"
        }
    }
    
    
    //MARK: - RGB TextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let t = textField.text, let color = UIColor(hex: t) {
            currentColor = color
        } else {
            textField.text = currentColor.toHex()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let t = textField.text, let color = UIColor(hex: t) {
            currentColor = color
        } else {
            textField.text = currentColor.toHex()
        }
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Actions
    @IBAction func backButtonTapped(_ sender: Any) {
        colorChangedCompletion = nil
        willMove(toParent: nil)
        if let v = self.view {
            v.removeFromSuperview()
        }
        app.chartVC!.layerSettingsVC.didMove(toParent: app.chartVC!)
    }
}

//MARK: - Colors CollectionView Delegate
extension ColorPickerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorPickerVC.ALL_COLORS.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCVCell", for: indexPath) as! ColorCVCell
        cell.colorView.backgroundColor = ColorPickerVC.ALL_COLORS[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentColor = ColorPickerVC.ALL_COLORS[indexPath.row]
    }
}

extension ColorPickerVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
}
