//
//  DrawerBar.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/6/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class DrawerBar: UIView {
    
    
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
        Bundle.main.loadNibNamed("DrawerBar", owner: self, options: nil)
        addSubview(contentView)
        
        
        let f = CGRect(x: 0, y: bounds.height - CGFloat(N) * h, width: h, height: CGFloat(N) * h)
        contentView.frame = f
        
        
        contentView.addBorders(edges: .init(arrayLiteral: .left, .top), color: .black, width: 1.0)
        autoButton.addBorders(edges: .top, color: .black, width: 1.0)
        logButton.addBorders(edges: .top, color: .black, width: 1.0)
        timeframeButton.addBorders(edges: .top, color: .black, width: 1.0)
        indicatorsButton.addBorders(edges: .top, color: .black, width: 1.0)
        minimizeButton.addBorders(edges: .top, color: .black, width: 1.0)
        
        setButtonStyle(autoButton)
        setButtonStyle(logButton)
        let t = app.settings.chartTimeframe
        if t == .daily || t == .weekly {
            timeframeButton.setTitle(t.rawValue.uppercased(), for: .normal)
        } else {
            timeframeButton.setTitle(t.rawValue, for: .normal)
        }
    }
    
    
    
    
    
    //MARK: - Methods
    func toggleMenu(completion: @escaping () -> Void = {}) {
        // what happens when valuBarWidth changes? 🤔
        // well, contentView doesn't grow !
        // Maybe fix this later
        
        
        if !isMainMenuShowing {
            UIView.animate(withDuration: animationDuration, animations: {
                let f = self.contentView.frame
                self.contentView.frame = CGRect(x: 0, y: self.bounds.height - CGFloat(self.N) * self.h, width: f.width, height: CGFloat(self.N) * self.h)
                self.layoutIfNeeded()
            }) { (_) in
                self.minimizeButton.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)
                
                completion()
            }
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                let f = self.contentView.frame
                self.contentView.frame = CGRect(x: 0, y: self.bounds.height - self.h, width: f.width, height: self.h)
                self.layoutIfNeeded()
            }) { (_) in
                self.minimizeButton.setImage(UIImage.init(systemName: "chevron.up"), for: .normal)
                completion()
            }
        }
        
        isMainMenuShowing = !isMainMenuShowing
    }
    
    func setButtonStyle(_ button: UIButton, selected: Bool? = nil) {
        
        switch button {
        case autoButton:
            if app.settings.chartAutoScale {
                button.setTitleColor(UIColor.systemYellow, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            } else {
                button.setTitleColor(UIColor.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
            }
            
        case logButton:
            if app.settings.chartLogScale {
                button.setTitleColor(UIColor.systemYellow, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            } else {
                button.setTitleColor(UIColor.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
            }
            
        case timeframeButton:
            break
        default:
            if let s = selected {
                if s {
                    button.setTitleColor(UIColor.systemYellow, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
                } else {
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
                }
            }
        }
    }
    
    
    //MARK: AutomatedDrawerSubMenuGeneration
    // what happens when valuBarWidth changes? well, contentView doesn't grow 🤔
    // Maybe fix this later
    
    private var submenuItemSelectedCompletion: (UIButton) -> Void = { _ in }
    var submenuButtonContainer: UIView!
    private var submenuN = 0
    
    func showSubmenu(menuButtons: [UIButton], submenuItemSelectedCompletion: @escaping (UIButton) -> Void) {
        self.submenuItemSelectedCompletion = submenuItemSelectedCompletion
        submenuN = menuButtons.count
        if isMainMenuShowing {
            toggleMenu {
                self._showSubmenu(menuButtons: menuButtons, submenuItemSelectedCompletion: submenuItemSelectedCompletion)
            }
        } else {
            self._showSubmenu(menuButtons: menuButtons, submenuItemSelectedCompletion: submenuItemSelectedCompletion)
        }
    }
    
    private func _showSubmenu(menuButtons: [UIButton], submenuItemSelectedCompletion: @escaping (UIButton) -> Void) {
        submenuButtonContainer = UIView(frame: CGRect(x: 0, y: bounds.height - h, width: bounds.width, height: 0))
        submenuButtonContainer.isOpaque = true
        submenuButtonContainer.backgroundColor = .fromHex(hex: "#589BFF")
        submenuButtonContainer.clipsToBounds = true
        addSubview(submenuButtonContainer)
        submenuButtonContainer.addBorders(edges: .init(arrayLiteral: .left), color: .black, width: 1.0)
        submenuButtonContainer.alpha = 0.0
        
        for i in 0..<menuButtons.count {
            let b = menuButtons[i]
            b.isOpaque = true
            submenuButtonContainer.addSubview(b)
            b.translatesAutoresizingMaskIntoConstraints = false
            b.leadingAnchor.constraint(equalTo: submenuButtonContainer.leadingAnchor).isActive = true
            b.trailingAnchor.constraint(equalTo: submenuButtonContainer.trailingAnchor).isActive = true
            if i > 0 {
                b.bottomAnchor.constraint(equalTo: menuButtons[i-1].topAnchor).isActive = true
                b.heightAnchor.constraint(equalTo: menuButtons[i-1].heightAnchor).isActive = true
            } else {
                b.bottomAnchor.constraint(equalTo: submenuButtonContainer.bottomAnchor, constant: 0).isActive = true
            }
            if i == menuButtons.count - 1 {
                b.topAnchor.constraint(equalTo: submenuButtonContainer.topAnchor).isActive = true
            }
            b.addBorders(edges: .top, color: .black, width: 1.0)
            b.addTarget(self, action: #selector(submenuButtonTapped(_:)), for: .touchUpInside)
            setNeedsLayout()
            layoutIfNeeded()
            layoutSubviews()
        }
        toggleSubmenu()
    }
    
    
    @IBAction func submenuButtonTapped(_ sender: UIButton) {
        submenuItemSelectedCompletion(sender)
    }
    
    
    func toggleSubmenu(completion: @escaping () -> Void = {}) {
        let f = self.frame
        
        if !isSubMenuShowing {
            UIView.animate(withDuration: animationDuration, animations: {
                self.submenuButtonContainer.frame = CGRect(x: 0, y: self.bounds.height - self.h * (self.submenuN + 1).cgFloat, width: f.width, height: CGFloat(self.submenuN) * self.h)
                self.submenuButtonContainer.alpha = 1.0
                self.layoutIfNeeded()
            }) { (_) in
                self.minimizeButton.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)

                completion()
            }
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.submenuButtonContainer.frame = CGRect(x: 0, y: self.bounds.height - self.h, width: f.width, height: 0)
                self.submenuButtonContainer.alpha = 0.0
                self.layoutIfNeeded()
            }) { (_) in
                self.minimizeButton.setImage(UIImage.init(systemName: "chevron.up"), for: .normal)
                self.submenuButtonContainer.removeFromSuperview()
                completion()
            }
        }
        
        isSubMenuShowing = !isSubMenuShowing
    }

    
    //MARK: - Minimize Button
    @IBAction func minimizeButtonTapped(_ sender: Any) {
        if isSubMenuShowing {
            toggleSubmenu {
                self.minimizeButton.setImage(UIImage.init(systemName: "chevron.up"), for: .normal)
            }
        } else {
            toggleMenu {
                if self.isMainMenuShowing {
                    self.minimizeButton.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)
                } else {
                    self.minimizeButton.setImage(UIImage.init(systemName: "chevron.up"), for: .normal)
                }
            }
        }
        
    }
    
    //MARK: - Auto Button
    @IBAction func autoButtonTapped(_ sender: Any) {
        app.settings.chartAutoScale = !app.settings.chartAutoScale
        setButtonStyle(autoButton)
        chart?.redraw()
    }
    
    //MARK: - Log Button
    @IBAction func logButtonTapped(_ sender: Any) {
        chart!.logScale = !chart!.logScale
        setButtonStyle(logButton)
        chart?.redraw()
    }
    
    //MARK: - Timeframe Button
    @IBAction func timeframeButtonTapped(_ sender: Any) {
        var menuButtons = [UIButton]()
        
        for timeframe in Timeframe.allValues().reversed() {
            let b = UIButton()
            if timeframe == "1d" || timeframe == "1w" {
                b.setTitle(timeframe.uppercased(), for: .normal)
            } else {
                b.setTitle(timeframe, for: .normal)
            }
            if timeframe == app.settings.chartTimeframe.rawValue {
                b.setTitleColor(.systemYellow, for: .normal)
            } else {
                b.setTitleColor(.white, for: .normal)
            }
            b.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 17.0)
            menuButtons.append(b)
        }
        
        showSubmenu(menuButtons: menuButtons) { (selectedButton) in
            guard let timeframe = selectedButton.title(for: .normal) else { return }
            let t: Timeframe
            if timeframe == "1D" || timeframe == "1W" {
                t = Timeframe(rawValue: timeframe.lowercased())!
            } else {
                t = Timeframe(rawValue: timeframe)!
            }
            
            self.app.settings.chartTimeframe = t
            self.timeframeButton.setTitle(timeframe, for: .normal)
            self.chart?.setupChart()
        }
    }
    
    
    
    //MARK: - Indicators Button
    @IBAction func indicatorsButtonTapped(_ sender: Any) {
        
        var menuButtons = [UIButton]()
        
        for indicatorName in Indicator.SystemName.all() {
            let indicator = Indicator.SystemName(rawValue: indicatorName)!
            let b = UIButton()
            b.setTitle(indicator.getAbbriviation().uppercased(), for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.setTitleColor(.lightGray, for: .disabled)
            b.titleLabel?.font = UIFont(name: "Arial Rounded MT", size: 16.0)
            menuButtons.append(b)
            if indicator == .volume {
                var chartHasVolume = false
                for ind in chart!.indicators {
                    if ind.name == Indicator.SystemName.volume.rawValue {
                        chartHasVolume = true
                        break
                    }
                }
                if chartHasVolume {
                    b.isEnabled = false
                }
            }
        }
        
        showSubmenu(menuButtons: menuButtons) { (selectedButton) in
            guard let buttonTitle = selectedButton.title(for: .normal) else { return }
            
            switch buttonTitle {
            case Indicator.SystemName.volume.getAbbriviation():
                self.chart?.indicators.append(Indicator.fromSystem(name: .volume, row: 0, height: 20.0))
            case Indicator.SystemName.ma.getAbbriviation():
                self.chart?.indicators.append(Indicator.fromSystem(name: .ma, row: 0, height: 100.0))
            case Indicator.SystemName.volume.getAbbriviation():
                self.chart?.indicators.append(Indicator.fromSystem(name: .rsi, row: self.chart?.indicators.last?.getRow() ?? 1, height: 20.0))
            default:
                break
            }
            self.chart?.setupChart()
            self.toggleMenu {
                self.chart?.settingsView.tabIndex = 1
                self.chart?.settingsView.show()
            }
        }

        
        
    }
    
    
    //MARK: - Tools Button
    @IBAction func toolsButtonTapped(_ sender: Any) {
        if let chart = self.chart {
            self.toggleMenu {
                 chart.settingsView.show()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var minimizeButton: UIButton!
    @IBOutlet weak var viewOfStackView: UIView!

    @IBOutlet weak var toolsButton: UIButton!
    @IBOutlet weak var indicatorsButton: UIButton!
    @IBOutlet weak var timeframeButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var autoButton: UIButton!
    
    
    //MARK: - Properties
    var N = 6//Number of Buttons in MainMenu
    let h: CGFloat = 40 //Height of Each Button
    
    var animationDuration: Double = 0.15
    var app: App!
    var chart: Chart? {
        return (UIApplication.shared.delegate as? AppDelegate)?.app.chart
    }
    var isMainMenuShowing = true
    var isSubMenuShowing = false
    
    private var isIndicatorButtonSelected = false
    private var isToolsButtonSelected = false
    
}


