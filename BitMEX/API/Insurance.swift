//
//  Insurance.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Insurance {
    //MARK: Constants
    static let endpoint = "/insurance"
    
    //MARK: Properties
    var currency: String
    var timestamp: String
    var walletBalance: Double?
    
    
    //MARK: Initialization
    private init(currency: String, timestamp: String, walletBalance: Double?) {
        self.currency = currency
        self.timestamp = timestamp
        self.walletBalance = walletBalance
    }
    
    //MARK: Types
    struct Columns {
        static let currency = "currency"
        static let timestamp = "timestamp"
        static let walletBalance = "walletBalance"
    }
    
    
    //MARK: Static Methods
    static func GET(symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Insurance]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        if let symbol = symbol {
            queryItems.append(URLQueryItem(name: "symbol", value: symbol))
        }
        
        if let count = count {
            queryItems.append(URLQueryItem(name: "count", value: String(count)))
        }
        
        if let reverse = reverse {
            queryItems.append(URLQueryItem(name: "reverse", value: String(reverse)))
        }
        
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: String(start)))
        }
        
        if let startTime = startTime {
            queryItems.append(URLQueryItem(name: "startTime", value: startTime))
        }
        
        if let endTime = endTime {
            queryItems.append(URLQueryItem(name: "endTime", value: endTime))
        }
        
        if let filter = filter {
            do {
                let d = try JSONSerialization.data(withJSONObject: filter, options: .prettyPrinted)
                let s = String(data: d, encoding: .utf8)!
                queryItems.append(URLQueryItem(name: "filter", value: s))
            } catch let err {
                completion(nil, nil, err)
            }
        }
        
        if let columns = columns {
            queryItems.append(URLQueryItem(name: "columns", value: columns.description))
        }
        
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
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
                    var result = [Insurance]()
                    for item in json {
                        let currency: String = item["currency"] as! String
                        let timestamp: String = item["timestamp"] as! String
                        let walletBalance: Double? = item["walletBalance"] as? Double
                        let insurance = Insurance(currency: currency, timestamp: timestamp, walletBalance: walletBalance)
                        result.append(insurance)
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
