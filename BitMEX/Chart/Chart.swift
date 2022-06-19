//
//  Chart.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/1/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class Chart: UIView {
    
    
    //MARK: - Properties
    var candles = [Candle]()
    var valueBarWidth: CGFloat {
        get {
            return valueBarWidthConstraint.constant
        }
        set {
            valueBarWidthConstraint.constant = ((newValue >= 60 ) ? newValue : 60.0)
        }
    }
    var visibleCandles = [Candle]()
    
    
    var priceView: PriceView?
    var bottomViews: UIView?
    var timeView: TimeView?
    var valueBars: UIView?
    var gridView: GridView?
    var indicatorViews = [IndicatorView]()
    var drawerBar: DrawerBar!
    var toolsView: ToolsView?
    weak var valueBarWidthConstraint: NSLayoutConstraint!
    weak var priceViewHeightConstraint: NSLayoutConstraint!
    weak var drawerBarHeightConstraint: NSLayoutConstraint!
    weak var priceTracker: PriceTracker?
    weak var crosshair: Crosshair?
    weak var guidelines: Guidlines!
    var layersVC: LayersVC!
    var app: App!
    
    
    var liveModeOn: Bool = false
    var lastExecTime: Date = Date()
    var websocketTimer: Timer?
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        backgroundColor = app.settings.chartBackgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        backgroundColor = app.settings.chartBackgroundColor
    }
    
    @objc func websocketCheck() {
        let now = Date()
        
        let timeInterval = now.timeIntervalSince1970 - lastExecTime.timeIntervalSince1970
        
        if timeInterval >= 6.0 {
            websocketTimer?.invalidate()
            setupChart()
        }
    }
    
    //MARK: - Public Methods
    func setupChart() {
//        app.resetWebSocket()
//        websocketTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(websocketCheck), userInfo: self, repeats: true)
        priceTracker?.isEnabled = false
        newestCandleX = bounds.width * 0.75
        if drawerBar.isMainMenuShowing {
            let saved = drawerBar.animationDuration
            drawerBar.animationDuration = 0.01
            drawerBar.toggleMenu()
            drawerBar.animationDuration = saved
        } else if drawerBar.isSubMenuShowing {
            let saved = drawerBar.animationDuration
            drawerBar.animationDuration = 0.01
            drawerBar.toggleSubmenu()
            drawerBar.animationDuration = saved
        }
        
        self.isUserInteractionEnabled = false
        self.alpha = 0.2
        
        
        if let instrument = instrument {
            app.chartVC?.symbolButton.title = instrument.symbol.uppercased()
            
            Candle.download(timeframe: timeframe!, instrument: instrument, partialCandle: true, reverse: true, count: 750, startTime: nil, endTime: app.game.currentTime.bitMEXStringWithSeconds()) { (opCandles, opResponse, opError) in
                guard opError == nil && opResponse != nil else {return}
                if let response = opResponse as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let c = opCandles {
                            self.candles = c
                            
                            if self.timeframe! == .fifteenMinutes {
                                self.downloadOlderCandles {
                                    self.downloadOlderCandles {
                                        DispatchQueue.main.async {
                                            self.setupSubViews()
                                            self.redraw()
                                        }
                                        
                                    }
                                }
                            } else if self.timeframe! == .thirtyMinutes {
                                self.downloadOlderCandles {
                                    self.downloadOlderCandles {
                                        self.downloadOlderCandles {
                                            DispatchQueue.main.async {
                                                self.setupSubViews()
                                                self.redraw()
                                            }
                                        }
                                        
                                    }
                                }
                            } else if self.timeframe! == .twoHourly {
                                self.downloadOlderCandles {
                                    DispatchQueue.main.async {
                                        self.setupSubViews()
                                        self.redraw()
                                    }
                                }
                            } else if self.timeframe! == .fourHourly {
                                self.downloadOlderCandles {
                                    self.downloadOlderCandles {
                                        self.downloadOlderCandles {
                                            DispatchQueue.main.async {
                                                self.setupSubViews()
                                                self.redraw()
                                            }
                                        }
                                    }
                                }
                            } else if self.timeframe! == .twelveHourly {
                                self.downloadOlderCandles {
                                    self.downloadOlderCandles {
                                        self.downloadOlderCandles {
                                            self.downloadOlderCandles {
                                                self.downloadOlderCandles {
                                                    self.downloadOlderCandles {
                                                        self.downloadOlderCandles {
                                                            self.downloadOlderCandles {
                                                                self.downloadOlderCandles {
                                                                    self.downloadOlderCandles {
                                                                        self.downloadOlderCandles {
                                                                            DispatchQueue.main.async {
                                                                                self.setupSubViews()
                                                                                self.redraw()
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.setupSubViews()
                                    self.redraw()
                                }
                                
                            }
                            
                        } else {
                            return
                        }
                    } else {
                        print(response.statusCode)
                        print(response.description)
                        return
                    }
                } else {
                    return
                }
                
            }
        }
        
    }
    
    
    func setupSubViews() {
        //MARK: CleanUp:
        priceTracker?.isEnabled = false
        isDownloadingOlderCandles = false
        CHARTSHOULDNOTBEREDRAWN = false
        for iv in indicatorViews {
            if iv.indicator.getRow() > 0 {
                iv.valueBar.removeFromSuperview()
            }
            iv.removeFromSuperview()
        }
        priceView?.valueBar?.removeFromSuperview()
        indicatorViews.removeAll()
        
        sortIndicators()
        for indicator in indicators {
            indicator.computeValue(candles: candles.reversed())
        }
        valueBarWidth = 40
        priceViewHeightConstraint.constant = self.bounds.height - timeView!.bounds.height
        self.alpha = 1.0
        
        priceView?.valueBar = ValueBar(chart: self, highestValue: Decimal(candles[0].high), lowestValue: Decimal(candles[0].low), tickSize: Decimal(instrument!.tickSize!), topMargin: self.topMargin, bottomMargin: self.bottomMargin, logScale: logScale)
        
        
        
        var frameHeights = [CGFloat]()
        var percentSum = 0.0
        for indicator in indicators {
            if indicator.getRow() > 0 {
                if percentSum + indicator.getHeight() > 80.0 {
                    indicator.style[Indicator.StyleKey.height] = (80.0 - percentSum) / 2.0
                }
                percentSum += indicator.getHeight()
                frameHeights.append(CGFloat(indicator.getHeight()) * (self.bounds.height - timeView!.bounds.height) / 100.0)
            } else {
                frameHeights.append(0.0)
            }
        }
        var sum: CGFloat = 0
        for h in frameHeights {
            sum += h
        }
        let priceViewHeight = (self.bounds.height - timeView!.bounds.height) - sum
        priceViewHeightConstraint.constant = priceViewHeight
        
        valueBars!.addSubview(self.priceView!.valueBar!)
        priceView!.valueBar!.translatesAutoresizingMaskIntoConstraints = false
        priceView!.valueBar!.topAnchor.constraint(equalTo: valueBars!.topAnchor).isActive = true
        priceView!.valueBar!.leadingAnchor.constraint(equalTo: valueBars!.leadingAnchor).isActive = true
        priceView!.valueBar!.trailingAnchor.constraint(equalTo: valueBars!.trailingAnchor).isActive = true
        priceView!.valueBar!.heightAnchor.constraint(equalToConstant: priceViewHeight).isActive = true
        
        
        
        for i in 0 ..< indicators.count {
            let indicator = indicators[i]
            let indicatorView = IndicatorView(chart: self, indicator: indicator)
            
            
            if indicator.getRow() == 0 {
                insertSubview(indicatorView, at: 0)
                indicatorView.translatesAutoresizingMaskIntoConstraints = false
                indicatorView.trailingAnchor.constraint(equalTo: priceView!.trailingAnchor).isActive = true
                indicatorView.leadingAnchor.constraint(equalTo: priceView!.leadingAnchor).isActive = true
                if indicator.isSystemIndicator() && indicator.name.lowercased() == Indicator.SystemName.volume.rawValue.lowercased() {
                    indicatorView.heightAnchor.constraint(equalTo: priceView!.heightAnchor, multiplier: 0.2).isActive = true
                } else {
                    indicatorView.topAnchor.constraint(equalTo: priceView!.topAnchor).isActive = true
                }
                indicatorView.bottomAnchor.constraint(equalTo: priceView!.bottomAnchor).isActive = true
            } else {
                bottomViews!.addSubview(indicatorView)
                
                indicatorView.translatesAutoresizingMaskIntoConstraints = false
                indicatorView.trailingAnchor.constraint(equalTo: bottomViews!.trailingAnchor).isActive = true
                indicatorView.leadingAnchor.constraint(equalTo: bottomViews!.leadingAnchor).isActive = true
                if indicator.getRow() == 1 {
                    indicatorView.topAnchor.constraint(equalTo: bottomViews!.topAnchor).isActive = true
                } else {
                    indicatorView.topAnchor.constraint(equalTo: indicatorViews.last!.bottomAnchor).isActive = true
                }
                indicatorView.heightAnchor.constraint(equalToConstant: frameHeights[i]).isActive = true
                
                valueBars!.addSubview(indicatorView.valueBar)

                indicatorView.valueBar.translatesAutoresizingMaskIntoConstraints = false
                if indicator.getRow() == 1 {
                    indicatorView.valueBar.topAnchor.constraint(equalTo: priceView!.valueBar!.bottomAnchor).isActive = true
                } else {
                    indicatorView.valueBar.topAnchor.constraint(equalTo: indicatorViews.last!.valueBar.bottomAnchor).isActive = true
                }
                indicatorView.valueBar.leadingAnchor.constraint(equalTo: valueBars!.leadingAnchor).isActive = true
                indicatorView.valueBar.trailingAnchor.constraint(equalTo: valueBars!.trailingAnchor).isActive = true
                indicatorView.valueBar.heightAnchor.constraint(equalToConstant: frameHeights[i]).isActive = true

            }
            indicatorViews.append(indicatorView)
            
        }
        
        
        drawerBar.isHidden = false
        self.isUserInteractionEnabled = true
        
        priceTracker?.isEnabled = true
//        activateWebsocket()
        redraw()
    }
    
    
    
    func redraw() {
        if CHARTSHOULDNOTBEREDRAWN { return }
        
        self.priceView?.processVisibleCandles()
        self.priceView?.redraw()
        self.timeView?.redraw()
        self.priceView?.valueBar?.redraw(newhighestValue: Decimal(self.highestPrice), newLowestValue: Decimal(self.lowestPrice), logScale: self.logScale)
        self.indicatorViews.forEach { (iv) in
            iv.redraw()
        }
        self.gridView?.redraw()
        self.guidelines.redraw()
        self.crosshair?.redraw()
        self.priceTracker?.redraw()
        self.app.chartVC?.layersButton.isHidden = false
        self.toolsView?.redraw()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
    
    //MARK: Download Older Candles
    var isDownloadingOlderCandles = false
    var CHARTSHOULDNOTBEREDRAWN = false
    
    func downloadOlderCandles(completion: (() -> Void)?) {
        if isDownloadingOlderCandles {
            return
        }
        isDownloadingOlderCandles = true
        
        if let instrument = instrument {
            Candle.download(timeframe: timeframe!, instrument: instrument, partialCandle: true, reverse: true, count: 750, endTime: candles.last!.openTime.bitMEXStringWithSeconds()) { (opCandles, opResponse, opError) in
                guard opError == nil && opResponse != nil else { return }
                if let response = opResponse as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if var c = opCandles {
                            DispatchQueue.main.async {
                                if c.isEmpty { return }
                                self.CHARTSHOULDNOTBEREDRAWN = true
                                
                                var can = c.first
                                while can != nil && can!.closeTime.timeIntervalSince1970 > self.candles.last!.closeTime.timeIntervalSince1970 {
                                    c.remove(at: 0)
                                    can = c.first
                                }
                                if c.isEmpty { return }
                                
                                if can!.closeTime.timeIntervalSince1970 == self.candles.last!.closeTime.timeIntervalSince1970 {
                                    let cc = self.candles.removeLast()
                                    let ccc = Candle(open: can!.open, close: cc.close, high: max(cc.high, can!.high), low: max(cc.low, can!.low), volume: can!.volume, timeframe: self.timeframe!, closeTime: can!.closeTime)
                                    self.candles.append(ccc)
                                    c.remove(at: 0)
                                }
                                
                                
                                self.candles.append(contentsOf: c)
                                for indicator in self.indicators {
                                    indicator.computeValue(candles: self.candles.reversed())
                                }
                                self.isDownloadingOlderCandles = false
                                self.CHARTSHOULDNOTBEREDRAWN = false
                                completion?()
                            }
                        } else {
                            return
                        }
                    } else {
                        print(response.statusCode)
                        print(response.description)
                        return
                    }
                } else {
                    return
                }
                
            }
        }
    }
    
    
    //MARK: Methods
    func getIndicatorsIn(row: Int) -> [Indicator] {
        var result = [Indicator]()
        for indicator in indicators {
            if indicator.getRow() == row {
                result.append(indicator)
            }
        }
        return result
    }
    
    func getNumberOfRows() -> Int {
        return indicators.isEmpty ? 1 : indicators.last!.getRow() + 1
    }
    
    
    //MARK: - Handle Touches
    
    //MARK: Tap
    @IBAction func handleTap(_ recognizer: UITapGestureRecognizer) {
        if isDrawingHorizontalLine {
            let location = recognizer.location(in: priceView!)
            if priceView!.frame.contains(location) {
                horizontalLines.append(HorizontalLine(price: 0, timeframe: timeframe!))
                if let candle = getCandleAt(x: location.x) {
                    self.horizontalLines.last!.price = candle.close
                } else {
                    let p = self.price(y: location.y, highestPrice: highestPrice, lowestPrice: lowestPrice, topMargin: topMargin, bottomMargin: bottomMargin, logScale: logScale)
                    self.horizontalLines.last!.price = p
                }
                isDrawingHorizontalLine = false
                redraw()
            }
        } else if crosshair!.isEnabled {
            let location = recognizer.location(in: crosshair!)
            if priceView!.frame.contains(location) || bottomViews!.frame.contains(location) {
                crosshair!.isEnabled = false
                redraw()
            }
        }
    }
    
    
    //MARK: Pan
    
    private var panBeganNewestX: CGFloat = 0
    private var panBeganHighestPrice: Double = 0
    private var panBeganLowestPrice: Double = 0
    private var pinchBeganBlockWidth: CGFloat = 4
    private var panBeganLocation: CGPoint = .zero
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if isDrawingHorizontalLine {
            return
        }
        
        let tr = recognizer.translation(in: self)
        let dx = tr.x
        let dy = tr.y
        
        
        switch recognizer.state {
        case .began:
            panBeganLocation = recognizer.location(in: self)
            panBeganNewestX = newestCandleX
            panBeganLowestPrice = lowestPrice
            panBeganHighestPrice = highestPrice
            pinchBeganBlockWidth = blockWidth
            
            if isDrawingTrendline {
                let location = panBeganLocation
                if priceView!.frame.contains(location) {
                    trendlines.append(Trendline(start: (candles[0].openTime, 1.0), end: (candles[0].openTime, 2.0), timeframe: timeframe!))
                    if let candle = getCandleAt(x: location.x) {
                        self.trendlines.last!.start = (candle.openTime, candle.close)
                    } else {
                        let p = self.price(y: location.y, highestPrice: highestPrice, lowestPrice: lowestPrice, topMargin: topMargin, bottomMargin: bottomMargin, logScale: logScale)
                        var time = visibleCandles.last!.openTime
                        var xx: CGFloat = visibleCandles.last!.x
                        while xx < location.x {
                            time = time.dateBy(adding: timeframe!)
                            xx += blockWidth
                        }
                        self.trendlines.last!.start = (time, p)
                    }
                    redraw()
                }
            } else if isDrawingFibRetracement {
                let location = panBeganLocation
                if priceView!.frame.contains(location) {
                    fibs.append(FibRetracement(start: (candles[0].openTime, 1.0), end: (candles[0].openTime, 2.0), timeframe: timeframe!))
                    if let candle = getCandleAt(x: location.x) {
                        self.fibs.last!.start = (candle.openTime, candle.close)
                    } else {
                        let p = self.price(y: location.y, highestPrice: highestPrice, lowestPrice: lowestPrice, topMargin: topMargin, bottomMargin: bottomMargin, logScale: logScale)
                        var time = visibleCandles.last!.openTime
                        var xx: CGFloat = visibleCandles.last!.x
                        while xx < location.x {
                            time = time.dateBy(adding: timeframe!)
                            xx += blockWidth
                        }
                        self.fibs.last!.start = (time, p)
                    }
                    redraw()
                }
            } else {
                let loc = panBeganLocation.applying(CGAffineTransform(translationX: -valueBars!.frame.origin.x, y: -valueBars!.frame.origin.y))
                if priceView!.valueBar!.frame.contains(loc) {
                    autoScale = false
                    redraw()
                }
            }
            
        case .changed:
            if isDrawingTrendline {
                let location: CGPoint = CGPoint(x: panBeganLocation.x + dx, y: panBeganLocation.y + dy)
                if let candle = getCandleAt(x: location.x) {
                    self.trendlines.last!.end = (candle.openTime, candle.close)
                } else {
                    let p = self.price(y: location.y, highestPrice: highestPrice, lowestPrice: lowestPrice, topMargin: topMargin, bottomMargin: bottomMargin, logScale: logScale)
                    var time = visibleCandles.last!.openTime
                    var xx: CGFloat = visibleCandles.last!.x
                    while xx < location.x {
                        time = time.dateBy(adding: timeframe!)
                        xx += blockWidth
                    }
                    self.trendlines.last!.end = (time, p)
                }
                
                redraw()
            } else if isDrawingFibRetracement {
                let location: CGPoint = CGPoint(x: panBeganLocation.x + dx, y: panBeganLocation.y + dy)
                if let candle = getCandleAt(x: location.x) {
                    self.fibs.last!.end = (candle.openTime, candle.close)
                } else {
                    let p = self.price(y: location.y, highestPrice: highestPrice, lowestPrice: lowestPrice, topMargin: topMargin, bottomMargin: bottomMargin, logScale: logScale)
                    var time = visibleCandles.last!.openTime
                    var xx: CGFloat = visibleCandles.last!.x
                    while xx < location.x {
                        time = time.dateBy(adding: timeframe!)
                        xx += blockWidth
                    }
                    self.fibs.last!.end = (time, p)
                }
                
                redraw()
            } else if priceView!.frame.contains(panBeganLocation) || bottomViews!.frame.contains(panBeganLocation) {
                
                //Panning PriceView or IndicatorViews:
                
                if !crosshair!.isEnabled {
                    let newNewestCandleX = panBeganNewestX + dx
                    if !(newNewestCandleX > 0) {
                        return
                    }
                    let newOldestCandleX = newNewestCandleX - blockWidth * CGFloat(candles.count)
                    if newOldestCandleX >= priceView!.bounds.width {
                        return
                    }
                    
                    newestCandleX = newNewestCandleX
                    if !autoScale {
                        let d = Double(dy / bounds.height)
                        let priceDy = (panBeganHighestPrice - panBeganLowestPrice) * d
                        highestPrice = panBeganHighestPrice + priceDy
                        lowestPrice = panBeganLowestPrice + priceDy
                    }
                    redraw()
                } else {
                    var newY = crosshair!.initialPosition.y + dy
                    let n = Int(dx / blockWidth)
                    var newX = crosshair!.initialPosition.x + CGFloat(n) * blockWidth
                    if !(newX <= priceView!.bounds.width && newX >= 0) {
                        newX = crosshair!.position.x
                    }
                    if !(newY >= 0 && newY < timeView!.frame.origin.y) {
                        newY = crosshair!.position.y
                    }
                    crosshair!.position = CGPoint(x: newX, y: newY)
                    redraw()
                }
            } else if timeView!.frame.contains(panBeganLocation) {
                
                //Panning TimeView
                
                let scale = 1 - 2 * dx / timeView!.bounds.width
                if pinchBeganBlockWidth * scale < 0.5 { blockWidth = 0.5; return }
                blockWidth = pinchBeganBlockWidth * scale
                
                redraw()
            } else if valueBars!.frame.contains(panBeganLocation) {
                
                
                //Panning ValueBars
                
                let locationInDrawerBar = panBeganLocation.applying(CGAffineTransform(translationX: -drawerBar.frame.origin.x, y: -drawerBar!.frame.origin.y))
                
                if drawerBar.contentView.frame.contains(locationInDrawerBar) || (drawerBar.isSubMenuShowing && drawerBar.submenuButtonContainer.frame.contains(locationInDrawerBar)) {
                    return
                }
                
                
                let loc = panBeganLocation.applying(CGAffineTransform(translationX: -valueBars!.frame.origin.x, y: -valueBars!.frame.origin.y))
                if priceView!.valueBar!.frame.contains(loc) {

                    let d = Double(dy / UIScreen.main.bounds.height)
                    
                    let delta = panBeganHighestPrice - panBeganLowestPrice
                    
                    
                    
                    let newHighestPrice = panBeganHighestPrice + delta * d
                    let newLowestPrice = panBeganLowestPrice - delta * d
                    
                    guard newHighestPrice - newLowestPrice < 8 * (Util.highestPriceOf(visibleCandles) - Util.lowestPriceOf(visibleCandles)) else { return }
                    
                    guard newHighestPrice - newLowestPrice > 0.125 * (Util.highestPriceOf(visibleCandles) - Util.lowestPriceOf(visibleCandles)) else { return }
                    
                    
                    highestPrice = newHighestPrice
                    lowestPrice = newLowestPrice
                    
                    
                    redraw()
                }
            }
        case .ended:
            if isDrawingTrendline {
                isDrawingTrendline = false
            } else if isDrawingFibRetracement {
                isDrawingFibRetracement = false
            } else if crosshair!.isEnabled {
                crosshair!.initialPosition = crosshair!.position
            }
            break
        case .failed, .cancelled:
            if isDrawingTrendline {
                isDrawingTrendline = false
            } else if crosshair!.isEnabled {
                crosshair!.isEnabled = false
            }
        default:
            break
        }
    }
    
    
    //MARK: Pinch
    @IBAction func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if isDrawingHorizontalLine || isDrawingFibRetracement || isDrawingTrendline {
            return
        }
        
        
        let scale = recognizer.scale
        
        
        switch recognizer.state {
        case .began:
            pinchBeganBlockWidth = blockWidth
            panBeganNewestX = newestCandleX
        case .changed:
            if pinchBeganBlockWidth * scale < 0.5 { blockWidth = 0.5; return }
            blockWidth = pinchBeganBlockWidth * scale
            let newLatestCandleX = panBeganNewestX * (1 + scale) / 2
            if !(newLatestCandleX > 0) {
                return
            }
            newestCandleX = newLatestCandleX
            redraw()
        case .ended, .failed, .cancelled:
            break
        default:
            break
        }
    }
    
    //MARK: Long Press
    @IBAction func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        if isDrawingHorizontalLine || isDrawingTrendline || isDrawingFibRetracement {
            return
        }
        guard let crosshair = self.crosshair else { return }
        switch recognizer.state {
        case .began:
            let l = recognizer.location(in: crosshair)
            if priceView!.frame.contains(l) || bottomViews!.frame.contains(l) {
                if let candle = getCandleAt(x: l.x) {
                    crosshair.initialPosition = CGPoint(x: candle.x, y: l.y)
                } else {
                    let N = Int((l.x - self.newestCandleX) / blockWidth)
                    crosshair.initialPosition = CGPoint(x: CGFloat(newestCandleX + CGFloat(N) * blockWidth), y: l.y)
                }
                crosshair.isEnabled = true
                redraw()
            }
            
        case .changed:
            break
        case .ended, .cancelled, .failed:
            break
        default:
            break
        }
    }
    
    
    
    
    
    
    
    //MARK: - Methods
    func getCandleAt(x: CGFloat) -> Candle? {
        let _candleIndex = Int((x - oldestCandleX) / blockWidth)
        let currentCandleIndex = _candleIndex - (candles.count - priceView!.oldestVisibleCandleIndex - 1)
        if currentCandleIndex >= 0 && currentCandleIndex < visibleCandles.count {
            return visibleCandles.reversed()[currentCandleIndex]
        }
        return nil
    }
    
    
    func sortIndicators() {
        indicators = sort(indicators: indicators)
    }
    private func sort(indicators: [Indicator]) -> [Indicator] {
        var result = [Indicator]()
        if indicators.isEmpty { return result }
        var frameRow = 0
        while result.count < indicators.count {
            let indicatorsInThisFrameRow = indicators.filter { (ind) -> Bool in
                return ind.getRow() == frameRow
            }
            //Find SmallestLayerIndex
            var smallestLayerIndex: Double = indicators.first!.style[Indicator.StyleKey.zIndex] as! Double
            indicatorsInThisFrameRow.forEach { (indicator) in
                if let index = indicator.style[Indicator.StyleKey.zIndex] as? Double {
                    if index < smallestLayerIndex {
                        smallestLayerIndex = index
                    }
                }
            }
            indicatorsInThisFrameRow.forEach { (indicator) in
                if indicator.style[Indicator.StyleKey.zIndex] == nil {
                    smallestLayerIndex -= 1.0
                    indicator.style[Indicator.StyleKey.zIndex] = smallestLayerIndex
                }
            }
            
            result.append(contentsOf: indicatorsInThisFrameRow.sorted(by: { (ind1, ind2) -> Bool in
                return (ind1.style[Indicator.StyleKey.zIndex] as! Double) >
                    (ind2.style[Indicator.StyleKey.zIndex] as! Double)
            }))
            
            frameRow += 1
        }
        var percentSum = 0.0
        var n = 0.0
        for indicator in indicators {
            if indicator.getRow() > 0 {
                percentSum += indicator.getHeight()
                n += 1.0
            }
        }
        if percentSum > 80.0 {
            let diff = percentSum - 80.0
            let delta = diff / n
            
            indicators.forEach { (indicator) in
                if indicator.getRow() > 0 {
                    indicator.style[Indicator.StyleKey.height] = indicator.getHeight() - delta
                }
            }
        }
        
        
        return result
    }
    
    //MARK: - Convenience Properties
    var instrument: Instrument? {
        get {
            return app.getInstrument(app.settings.chartSymbol)
        }
        set {
            if let inst = newValue {
                app.settings.chartSymbol = inst.symbol
            } else {
                app.settings.chartSymbol = "XBTUSD"
            }
        }
    }
    var timeframe: Timeframe? {
        get {
            return app.settings.chartTimeframe
        }
        set {
            app.settings.chartTimeframe = newValue!
        }
    }
    var highestPrice: Double {
        get {
            return app.settings.chartHighestPrice
        }
        set {
            app.settings.chartHighestPrice = newValue
        }
    }
    var lowestPrice: Double {
        get {
            return app.settings.chartLowestPrice
        }
        set {
            app.settings.chartLowestPrice = newValue
        }
    }
    
    var spacing: CGFloat {
        return blockWidth * 0.4
    }
    var candleWidth: CGFloat {
        return blockWidth - spacing
    }
    var wickWidth: CGFloat {
//        return blockWidth >= 2.0 ? blockWidth * 0.25 : blockWidth * 0.5
        return blockWidth >= 1.5 ? 1.5 : blockWidth
    }
    var blockWidth: CGFloat {
        get {
            return app.settings.chartBlockWidth
        }
        set {
            app.settings.chartBlockWidth = newValue
        }
    }
    
    var indicators: [Indicator] {
        get {
            return app.settings.chartIndicators
        }
        set {
            app.settings.chartIndicators = newValue
        }
    }
    
    var newestCandleX: CGFloat {
        get {
            return app.settings.chartLatestX
        }
        set {
            app.settings.chartLatestX = newValue
        }
    }
    
    var oldestCandleX: CGFloat {
        return newestCandleX - blockWidth * (candles.count - 1).cgFloat
    }
    
    var autoScale: Bool {
        get {
            return app.settings.chartAutoScale
        }
        set {
            app.settings.chartAutoScale = newValue
        }
    }
    var topMargin: Double {
        get {
            return app.settings.chartTopMargin
        }
        set {
            app.settings.chartTopMargin = newValue
            priceView?.valueBar?.topMargin = newValue
        }
    }
    var bottomMargin: Double {
        get {
            return app.settings.chartBottomMargin
        }
        set {
            app.settings.chartBottomMargin = newValue
            priceView?.valueBar?.bottomMargin = newValue
        }
    }
    
    var logScale: Bool {
        get {
            return app.settings.chartLogScale
        }
        set {
            app.settings.chartLogScale = newValue
            priceView?.valueBar?.logScale = newValue
        }
    }
    
    
    var chartBackgroundColor: UIColor {
        get {
            return app.settings.chartBackgroundColor
        }
        set {
            app.settings.chartBackgroundColor = newValue
//            self.backgroundColor = newValue
        }
    }
    
    
    var isDrawingHorizontalLine: Bool = false {
        didSet {
            self.app.chartVC?.setToolButtonTint()
        }
    }
    var isDrawingTrendline: Bool = false {
        didSet {
            self.app.chartVC?.setToolButtonTint()
        }
    }
    var isDrawingFibRetracement: Bool = false {
        didSet {
            self.app.chartVC?.setToolButtonTint()
        }
    }
    
    var horizontalLines: [HorizontalLine] {
        get {
            return app.settings.horizontalLines
        }
        set {
            app.settings.horizontalLines = newValue
        }
    }
    var trendlines: [Trendline] {
        get {
            return app.settings.trendlines
        }
        set {
            app.settings.trendlines = newValue
        }
    }
    var fibs: [FibRetracement] {
        get {
            return app.settings.fibs
        }
        set {
            app.settings.fibs = newValue
        }
    }
    
    
}
