//
//  Leaderboard.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Leaderboard {
    //MARK: Constants
    static let endpoint = "/leaderboard"
    static let endpoint_name = "/leaderboard/name"
    
    //MARK: Properties
    var name: String
    var isRealName: Bool?
    var profit: Double?
    
    //MARK: Initialization
    private init(name: String, isRealName: Bool?, profit: Double?) {
        self.name = name
        self.isRealName = isRealName
        self.profit = profit
    }
    
    //MARK: Types
    struct Columns {
        static let name = "name"
        static let isRealName = "isRealName"
        static let profit = "profit"
    }
    
    struct Method {
        static let notional = "notional"
        static let roe = "ROE"
    }
    
   
    
    //MARK: Static Methods
    static func GET(method: String? = nil, completion: @escaping ([Leaderboard]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        if let method = method {
            queryItems.append(URLQueryItem(name: "method", value: method))
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
                    var result = [Leaderboard]()
                    for item in json {
                        let name: String = item["name"] as! String
                        let isRealName: Bool? = item["isRealName"] as? Bool
                        let profit: Double? = item["profit"] as? Double
                        let l = Leaderboard(name: name, isRealName: isRealName, profit: profit)
                        result.append(l)
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
    
    static func GET_Name(authentication: Authentication, completion: @escaping (String?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let n = json["name"] as? String
                    completion(n, response, nil)
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
