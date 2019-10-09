//
//  Sort.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/5/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

enum SortBy: Int {
    case DEFAULT
    case SYMBOL
    case VOLUME
    case PRICE
    case PERCENT_CHANGE
    
    static func all() -> [String] {
        return ["Defaul", "Symbol", "Volume", "Price", "% Change"]
    }
}

enum SortDirection: Int {
    case ASCENDING
    case DESCENDING
    
    static func all() -> [String] {
        return ["ASCENDING", "DESCENDING"]
    }
    
    mutating func negate() {
        if self == .ASCENDING {
            self = .DESCENDING
        } else {
            self = .ASCENDING
        }
    }
}
