//
//  ColorPicker.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/12/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ColorPicker: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rgbLabel: UILabel!
    @IBOutlet weak var rgbTextField: UITextField!
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet var contentView: UIView!
    
    
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
            colorChangedCompletion?(currentColor.withAlphaComponent(currentAlpha))
        }
    }
    
    var currentAlpha: CGFloat = 1.0 {
        didSet {
            colorChangedCompletion?(currentColor.withAlphaComponent(currentAlpha))
        }
    }
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        additionalInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        additionalInit()
    }
    
    
    private func additionalInit() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            self.app = delegate.app
        }
        
        Bundle.main.loadNibNamed("ColorPicker", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        rgbTextField.delegate = self
        
        
        collectionView.register(UINib(nibName: "ColorCVCell", bundle: nil), forCellWithReuseIdentifier: "ColorCVCell")
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        
        
        layer.shadowColor = currentColor.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        
    }
    
    
    
    
    //MARK: - Methods
    var isShowing = false
    
    func show(at anchorView: UIView, withCompletion: @escaping (UIColor) -> Void) {
        if let globalPoint = anchorView.tlLocationInWindow, let view = app.chart!.superview, let window = view.window  {
            
            let f: CGRect
            if globalPoint.y >= window.bounds.height / 2 {
                f = CGRect(x: UIScreen.main.bounds.width / 2 - 120.0, y: globalPoint.y - 240.0, width: 240.0, height: 240.0)
            } else {
                f = CGRect(x: UIScreen.main.bounds.width / 2 - 120.0, y: globalPoint.y + anchorView.bounds.height, width: 240.0, height: 240.0)
            }
            
            view.addSubview(self)
            self.frame = f
            self.isShowing = true
            app.chart?.settingsView.currentColorPicker = self
            app.chart?.settingsView.isUserInteractionEnabled = false
            self.colorChangedCompletion = { color in
                withCompletion(color)
            }
        }
    }
    
    func hide() {
        self.removeFromSuperview()
        self.isShowing = false
        app.chart?.settingsView.isUserInteractionEnabled = true
    }
    
    
    
    
    //MARK: - CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorPicker.ALL_COLORS.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCVCell", for: indexPath) as! ColorCVCell
        cell.colorView.backgroundColor = ColorPicker.ALL_COLORS[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentColor = ColorPicker.ALL_COLORS[indexPath.row]
    }
    
    
    
    //MARK: - Actions
    @IBAction func opacityChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            currentAlpha = CGFloat(slider.value)
        }
    }
    
    @IBAction func rgbTextFieldEditingDidEnd(_ sender: UITextField) {
        if let t = sender.text, let color = UIColor(hex: t) {
            currentColor = color
        } else {
            sender.text = currentColor.toHex()
        }
    }
    
    @IBAction func rgbTextFieldEditingDidBegin(_ sender: UITextField) {
    }
}


// MARK: - Collection View Flow Layout
extension ColorPicker : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30.0, height: 30.0)
    }
    
}
