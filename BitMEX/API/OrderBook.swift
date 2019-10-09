//
//  OrderBook.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class OrderBook {
    //MARK: Constants
    static let endpoint = "/orderBook/L2"
    
    //MARK: Properties
    var symbol: String
    var id: Double
    var side: String
    var size: Double?
    var price: Double?
    
    //MARK: Initialization
    private init(symbol: String, id: Double, side: String, size: Double?, price: Double?) {
        self.symbol = symbol
        self.id = id
        self.side = side
        self.size = size
        self.price = price
    }
    
    //MARK: Types
    struct Columns {
        static let symbol = "symbol"
        static let id = "id"
        static let side = "side"
        static let size = "size"
        static let price = "price"
    }
    
    
    //MARK: Static Methods
    
    /// send 0 for full depth
    static func GET(symbol: String, depth: Int? = nil, completion: @escaping ([OrderBook]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "symbol", value: symbol))
        
        if let depth = depth {
            queryItems.append(URLQueryItem(name: "depth", value: String(depth)))
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
                    var result = [OrderBook]()
                    for item in json {
                        let symbol: String = item["symbol"] as! String
                        let id: Double = item["id"] as! Double
                        let side: String = item["side"] as! String
                        let size: Double? = item["size"] as? Double
                        let price: Double? = item["price"] as? Double
                        let ob = OrderBook(symbol: symbol, id: id, side: side, size: size, price: price)
                        result.append(ob)
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
