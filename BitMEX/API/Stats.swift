//
//  Stats.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Stats {
    
    //MARK: Constants
    static let endpoint = "/stats"
    // I will implement these later:
    static let endpoint_history = "/stats/history"
    static let endpoint_historyUSD = "/stats/historyUSD"
    
    //MARK: Properties
    var rootSymbol: String
    var currency: String?
    var volume24h: Double?
    var openInterest: Double?
    var openValue: Double?
    
    
    //MARK: Initialization
    private init(rootSymbol: String, currency: String?, volume24h: Double?, openInterest: Double?, openValue: Double?) {
        self.rootSymbol = rootSymbol
        self.currency = currency
        self.volume24h = volume24h
        self.openInterest = openInterest
        self.openValue = openValue
    }
    
    //MARK: Types
    struct Columns {
        static let rootSymbol = "rootSymbol"
        static let currency = "currency"
        static let volume24h = "volume24h"
        static let openInterest = "openInterest"
        static let openValue = "openValue"
    }
    
    
    //MARK: Static Methods
    static func GET(completion: @escaping ([Stats]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [Stats]()
                    for item in json {
                        let rootSymbol: String = item["rootSymbol"] as! String
                        let currency: String? = item["currency"] as? String
                        let volume24h: Double? = item["volume24h"] as? Double
                        let openInterest: Double? = item["openInterest"] as? Double
                        let openValue: Double? = item["openValue"] as? Double
                        let s = Stats(rootSymbol: rootSymbol, currency: currency, volume24h: volume24h, openInterest: openInterest, openValue: openValue)
                        result.append(s)
                    }
                    completion(result, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    
    static func GET_History(completion: @escaping ([Stats]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_history
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [Stats]()
                    for item in json {
                        let rootSymbol: String = item["rootSymbol"] as! String
                        let currency: String? = item["currency"] as? String
                        let volume24h: Double? = item["volume24h"] as? Double
                        let openInterest: Double? = item["openInterest"] as? Double
                        let openValue: Double? = item["openValue"] as? Double
                        let s = Stats(rootSymbol: rootSymbol, currency: currency, volume24h: volume24h, openInterest: openInterest, openValue: openValue)
                        result.append(s)
                    }
                    completion(result, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
}
