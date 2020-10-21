//
//  Util.swift
//  Binance+
//
//  Created by Behnam Karimi on 12/22/1397 AP.
//  Copyright © 1397 AP Behnam Karimi. All rights reserved.
//

import UIKit
import Darwin
import CommonCrypto

class Util {
    
    static func createGradientImage(color1: UIColor, color2: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let ctx = UIGraphicsGetCurrentContext()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.render(in: ctx!)
        
        
        let image =  UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    static func createGradientLayer(color1: UIColor, color2: UIColor, width: CGFloat, height: CGFloat) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        
        return gradientLayer
    }
    
    
    
    static func greatestPowerOfTenLess(than x: Decimal) -> Int {
        var i = 0
        var y = x
        while y > 10 {
            y /= 10
            i += 1
        }
        return i
    }
    
    static func y(price: Decimal, frameHeight: CGFloat, highestPrice: Decimal, lowestPrice: Decimal) -> CGFloat {
        let ratio = ((highestPrice - price) / (highestPrice - lowestPrice)).cgFloatValue
        return frameHeight * ratio
    }
    
    
    static func getAttributedString(text: String, font: UIFont) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let string = NSAttributedString(string: text, attributes: attributes)
        return string
    }
    
    
    static func highestPriceOf(_ candles: [Candle]) -> Double {
        var highestPrice: Double = -1
        for i in 0..<candles.count {
            let candle = candles[i]
            if candle.high > highestPrice {
                highestPrice = candle.high
            }
        }
        return highestPrice
    }
    
    static func lowestPriceOf(_ candles: [Candle]) -> Double {
        var lowestPrice = highestPriceOf(candles)
        for i in 0..<candles.count {
            let candle = candles[i]
            if candle.low < lowestPrice {
                lowestPrice = candle.low
            }
        }
        return lowestPrice
    }
    
}
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

extension Date {
    func bitMEXString() -> String {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return RFC3339DateFormatter.string(from: self)
    }
    func bitMEXStringWithSeconds() -> String {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return RFC3339DateFormatter.string(from: self)
    }
        
    static func fromBitMEXString(str: String) -> Date? {
        let s: String = String(str.split(separator: ".")[0])
        
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        
        return RFC3339DateFormatter.date(from: s)!
    }
    
    func localToUTC() -> Date {
        var seconds = TimeInterval(TimeZone.current.secondsFromGMT())
        if TimeZone.current.isDaylightSavingTime(for: self) {
            seconds += TimeZone.current.daylightSavingTimeOffset(for: self)
        }
        let i = self.timeIntervalSince1970 - TimeInterval(exactly: seconds)!
        return Date(timeIntervalSince1970: i)
    
    }
    
    func utcToLocal() -> Date {
        var seconds = TimeInterval(TimeZone.current.secondsFromGMT())
        if TimeZone.current.isDaylightSavingTime(for: self) {
            seconds += TimeZone.current.daylightSavingTimeOffset(for: self)
        }
        let i = self.timeIntervalSince1970 + TimeInterval(exactly: seconds)!
        return Date(timeIntervalSince1970: i)
    }
    
    func toMillis() -> Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func dateBy(adding: Timeframe) -> Date {
        let calendar = Calendar.current
        let time = self
        switch adding {
        case .oneMinute:
            return calendar.date(byAdding: .minute, value: 1, to: time)!
        case .fiveMinutes:
            return calendar.date(byAdding: .minute, value: 5, to: time)!
        case .fifteenMinutes:
            return calendar.date(byAdding: .minute, value: 15, to: time)!
        case .thirtyMinutes:
            return calendar.date(byAdding: .minute, value: 30, to: time)!
        case .hourly:
            return calendar.date(byAdding: .hour, value: 1, to: time)!
        case .twoHourly:
            return calendar.date(byAdding: .hour, value: 2, to: time)!
        case .fourHourly:
            return calendar.date(byAdding: .hour, value: 4, to: time)!
        case .twelveHourly:
            return calendar.date(byAdding: .hour, value: 12, to: time)!
        case .daily:
            return calendar.date(byAdding: .day, value: 1, to: time)!
        case .weekly:
            return calendar.date(byAdding: .day, value: 7, to: time)!
        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: time)!
        }
    }
    
    func dateBy(subtracting: Timeframe) -> Date {
        let calendar = Calendar.current
        let time = self
        switch subtracting {
        case .oneMinute:
            return calendar.date(byAdding: .minute, value: -1, to: time)!
        case .fiveMinutes:
            return calendar.date(byAdding: .minute, value: -5, to: time)!
        case .fifteenMinutes:
            return calendar.date(byAdding: .minute, value: -15, to: time)!
        case .thirtyMinutes:
            return calendar.date(byAdding: .minute, value: -30, to: time)!
        case .hourly:
            return calendar.date(byAdding: .hour, value: -1, to: time)!
        case .twoHourly:
            return calendar.date(byAdding: .hour, value: -2, to: time)!
        case .fourHourly:
            return calendar.date(byAdding: .hour, value: -4, to: time)!
        case .twelveHourly:
            return calendar.date(byAdding: .hour, value: -12, to: time)!
        case .daily:
            return calendar.date(byAdding: .day, value: -1, to: time)!
        case .weekly:
            return calendar.date(byAdding: .day, value: -7, to: time)!
        case .monthly:
            return calendar.date(byAdding: .month, value: -1, to: time)!
        }
    }

    /// date should be exact second
    func nextOpenTime(timeframe: Timeframe) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = calendar.timeZone
        let openTime = self.localToUTC()
        let minute = calendar.component(.minute, from: openTime)
        let hour = calendar.component(.hour, from: openTime)
        
        
        
        switch timeframe {
        case .oneMinute:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .fiveMinutes:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: ((minute / 5) * 5 + 5) % 60, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .fifteenMinutes:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: ((minute / 15) * 15 + 15) % 60, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .thirtyMinutes:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: ((minute / 30) * 30 + 30) % 60, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .hourly:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .twoHourly:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: ((hour / 2) * 2 + 2) % 24, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .fourHourly:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: ((hour / 4) * 4 + 4) % 24, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .twelveHourly:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: ((hour / 12) * 12 + 12) % 24, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .daily:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .weekly:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: nil, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: 2, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        case .monthly:
            return calendar.nextDate(after: openTime, matching: DateComponents(calendar: calendar, timeZone: timeZone, era: nil, year: nil, month: nil, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)?.utcToLocal()
        }
    }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
    var cgFloatValue: CGFloat {
        return CGFloat(doubleValue)
    }
    var stringValue: String {
        return NSDecimalNumber(decimal: self).stringValue
    }
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
    func formattedWith(fractionDigitCount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigitCount
        formatter.numberStyle = .decimal
        formatter.currencyGroupingSeparator = ""
        formatter.maximumFractionDigits = fractionDigitCount
        formatter.currencySymbol = ""
        let str = formatter.string(from: self as NSNumber)!
        return str
    }
}


extension UIView {
    func takeScreenshot() -> UIImage? {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIColor {
    static func fromHex(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK: - Initialization

    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    
    // MARK: - From UIColor to String

    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func asNavBarShadowImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(self.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
}



extension Collection {
    
    /**
     * Returns a random element of the Array or nil if the Array is empty.
     */
    var sample : Element? {
        guard !isEmpty else { return nil }
        let offset = arc4random_uniform(numericCast(self.count))
        let idx = self.index(self.startIndex, offsetBy: numericCast(offset))
        return self[idx]
    }
    
    /**
     * Returns `count` random elements from the array.
     * If there are not enough elements in the Array, a smaller Array is returned.
     * Elements will not be returned twice except when there are duplicate elements in the original Array.
     */
    func sample(_ count : UInt) -> [Element] {
        let sampleCount = Swift.min(numericCast(count), self.count)
        
        var elements = Array(self)
        var samples : [Element] = []
        
        while samples.count < sampleCount {
            let idx = (0..<elements.count).sample!
            samples.append(elements.remove(at: idx))
        }
        
        return samples
    }
    
}

extension Array {
    
    /**
     * Shuffles the elements in the Array in-place using the
     * [Fisher-Yates shuffle](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle).
     */
    mutating func shuffle() {
        guard self.count >= 1 else { return }
        
        for i in (1..<self.count).reversed() {
            let j = (0...i).sample!
            self.swapAt(j, i)
        }
    }
    
    /**
     * Returns a new Array with the elements in random order.
     */
    var shuffled : [Element] {
        var elements = self
        elements.shuffle()
        return elements
    }
    
}



extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate()
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash).lowercased()
    }
    
    
    
    
}



extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


extension Double {
    var decimalValue: Decimal {
        return Decimal(self)
    }
}



extension UIView {
    
    func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = 1.0) {
       
        func createBorder() -> UIView {
            let borderView = UIView(frame: CGRect.zero)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            borderView.backgroundColor = color
            return borderView
        }

        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder()
            self.addSubview(topBorder)
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                topBorder.heightAnchor.constraint(equalToConstant: width)
            ])
        }
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder()
            self.addSubview(leftBorder)
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder()
            self.addSubview(rightBorder)
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder()
            self.addSubview(bottomBorder)
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
            ])
        }
    }
}



extension String {
    func asAttributedString(color: UIColor = .black, font: UIFont = .systemFont(ofSize: 11.0), textAlignment: NSTextAlignment? = nil) -> NSAttributedString {
        var attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]

        if let a = textAlignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = a
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func asMutableAttributedString(color: UIColor = .black, font: UIFont = .systemFont(ofSize: 11.0), textAlignment: NSTextAlignment? = nil) -> NSMutableAttributedString {
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        if let a = textAlignment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = a
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    
}

extension UIView {
    func y(price: Double, highestPrice: Double, lowestPrice: Double, topMargin: Double, bottomMargin: Double, logScale: Bool) -> CGFloat {
        if logScale {
            let h = log2(highestPrice)
            let l = log2(lowestPrice)
            let p = log2(price)
            let ratio = CGFloat((h - p) / (h - l))
            let frameHeight = frame.height * CGFloat(1.0 - (topMargin + bottomMargin) / 100.0)
            return frameHeight * ratio + CGFloat(topMargin) * frame.height / 100
        } else {
            let ratio = CGFloat((highestPrice - price) / (highestPrice - lowestPrice))
            let frameHeight = frame.height * CGFloat(1.0 - (topMargin + bottomMargin) / 100.0)
            return frameHeight * ratio + CGFloat(topMargin) * frame.height / 100
        }
        
    }
    
    
}


extension Int {
    var cgFloat: CGFloat  {
        return CGFloat(self)
    }
}

extension Double {
    func toCGFLoat() -> CGFloat {
        return CGFloat(self)
    }
    
    func formattedWith(fractionDigitCount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigitCount
        formatter.numberStyle = .decimal
        formatter.currencyGroupingSeparator = ""
        formatter.maximumFractionDigits = fractionDigitCount
        formatter.currencySymbol = ""
        let str = formatter.string(from: self as NSNumber)!
        return str
    }
}


extension Instrument {
    func priceFormatted(_ p: Double) -> String {
        if tickSize == nil {
            return String(p)
        }
        let formatter = NumberFormatter()
        let tickSize = Decimal(self.tickSize!)
        formatter.minimumFractionDigits = tickSize.significantFractionalDecimalDigits
        formatter.numberStyle = .currency
        formatter.currencyGroupingSeparator = ""
        formatter.maximumFractionDigits = tickSize.significantFractionalDecimalDigits
        formatter.currencySymbol = ""
        let str = formatter.string(from: p as NSNumber)!
        return str
    }
    
    func priceFormatted(_ p: Decimal) -> String {
        return priceFormatted(p.doubleValue)
    }
}


extension UIView {
    var tlLocationInWindow: CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    var trLocationInWindow: CGPoint? {
        return self.superview?.convert(self.frame.origin.applying(CGAffineTransform.init(translationX: self.frame.width, y: 0)), to: nil)
    }
}


extension UIView {
    func addRoundedShadow(cornerRadius: CGFloat = 0.0, color: UIColor = .gray, opacity: Float = 1.0, shadowRadius: CGFloat = 10.0, offset: CGSize = .zero) {

        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func addShadow(color: UIColor = .gray, opacity: Float = 1.0, shadowRadius: CGFloat = 10.0, offset: CGSize = .zero) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
}


extension IndexPath {
    init(_ row: Int, _ section: Int) {
        self.init(row: row, section: section)
    }
}

extension UIBarButtonItem {
    func xPositionInBar() -> CGFloat {
        return self.asView()!.frame.origin.x + self.asView()!.superview!.frame.origin.x
    }
    
    func asView() -> UIView? {
        return self.value(forKey: "view") as? UIView
    }
    
}


extension Formatter {
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E+0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
}

extension Numeric {
    var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    func alertDialog(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


extension UILabel {
    func flashPrice(newText: String, previousText: String? = nil) {
        var _prevText: String?
        if previousText == nil {
            _prevText = self.text
        } else {
            _prevText = previousText
        }
        
        guard let prevText = _prevText else {
            self.text = newText
            return
        }
        
        guard newText != prevText else {
            self.text = newText
            return
        }
        
        guard let prevPrice = Double(prevText) else {
            self.text = newText
            return
        }
        
        guard let newPrice = Double(newText) else {
            self.text = newText
            return
        }
        
        let isGreen = newPrice > prevPrice
        
        let prevTextColor = textColor
        
        UIView.animate(withDuration: 1.0) {
            self.text = newText
            self.textColor = isGreen ? UIColor.systemGreen : UIColor.systemRed
        } completion: { (_) in
            self.textColor = prevTextColor
        }
    }
}
