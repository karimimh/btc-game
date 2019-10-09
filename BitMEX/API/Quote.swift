//
//  Quote.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Quote {
    //MARK: Constants
    static let endpoint = "/quote"
    static let endpoint_bucketed = "/quote/bucketed"
    
    
    //MARK: Properties
    var timestamp: String
    var symbol: String
    var bidSize: Double?
    var bidPrice: Double?
    var askPrice: Double?
    var askSize: Double?
    
    //MARK: Initialization
    private init(timestamp: String, symbol: String, bidSize: Double?, bidPrice: Double?, askPrice: Double?, askSize: Double?) {
        self.timestamp = timestamp
        self.symbol = symbol
        self.bidSize = bidSize
        self.bidPrice = bidPrice
        self.askPrice = askPrice
        self.askSize = askSize
    }
    
    //MARK: Types
    struct Columns {
        static let timestamp = "timestamp"
        static let symbol = "symbol"
        static let bidSize = "bidSize"
        static let bidPrice = "bidPrice"
        static let askPrice = "askPrice"
        static let askSize = "askSize"
    }
    
    
    //MARK: Static Methods
    
    static func GET(symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Quote]?, URLResponse?, Error?) -> Void) {
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
                return
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
                    var result = [Quote]()
                    for item in json {
                        let timestamp: String = item["timestamp"] as! String
                        let symbol: String = item["symbol"] as! String
                        let bidSize: Double? = item["bidSize"] as? Double
                        let bidPrice: Double? = item["bidPrice"] as? Double
                        let askPrice: Double? = item["askPrice"] as? Double
                        let askSize: Double? = item["askSize"] as? Double
                        let quote = Quote(timestamp: timestamp, symbol: symbol, bidSize: bidSize, bidPrice: bidPrice, askPrice: askPrice, askSize: askSize)
                        result.append(quote)
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
    
    
    /// Timestamps returned by our bucketed endpoints are the end of the period, indicating when the bucket was written to disk. Some other common systems use the timestamp as the beginning of the period. Please be aware of this when using this endpoint.
    static func GET_Bucketed(binSize: String, partial: Bool? = nil, symbol: String? = nil, count: Int? = nil, reverse: Bool? = nil, start: Int? = nil, startTime: String? = nil, endTime: String? = nil, filter: [String: Any]? = nil, columns: [String]? = nil, completion: @escaping ([Quote]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_bucketed
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "binSize", value: binSize))
        
        if let partial = partial {
            queryItems.append(URLQueryItem(name: "partial", value: String(partial)))
        }
        
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
                return
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
                    var result = [Quote]()
                    for item in json {
                        let timestamp: String = item["timestamp"] as! String
                        let symbol: String = item["symbol"] as! String
                        let bidSize: Double? = item["bidSize"] as? Double
                        let bidPrice: Double? = item["bidPrice"] as? Double
                        let askPrice: Double? = item["askPrice"] as? Double
                        let askSize: Double? = item["askSize"] as? Double
                        let quote = Quote(timestamp: timestamp, symbol: symbol, bidSize: bidSize, bidPrice: bidPrice, askPrice: askPrice, askSize: askSize)
                        result.append(quote)
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
