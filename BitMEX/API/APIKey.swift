//
//  APIKey.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/24/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class APIKey {
    
    //MARK: Constants
    static let endpoint = "/apiKey"
    
    //MARK: Properties
    var id: String
    var secret: String
    var name: String
    var nonce: Double
    var cidr: String?
    var permissions: [Any]?
    var enabled: Bool?
    var userId: Double
    var created: String?
    
    
    //MARK: Initialization
    private init(id: String, secret: String, name: String, nonce: Double, cidr: String?, permissions: [Any]?, enabled: Bool?, userId: Double, created: String?) {
        self.id = id
        self.secret = secret
        self.name = name
        self.nonce = nonce
        self.cidr = cidr
        self.permissions = permissions
        self.enabled = enabled
        self.userId = userId
        self.created = created
    }
    
    //MARK: Types
    struct Columns {
        static let id = "id"
        static let secret = "secret"
        static let name = "name"
        static let nonce = "nonce"
        static let cidr = "cidr"
        static let permissions = "permissions"
        static let enabled = "enabled"
        static let userId = "userId"
        static let created = "created"
    }
    
    
    
    //MARK: Static Methods
    static func GET(authentication: Authentication, reverse: Bool? = nil, completion: @escaping ([APIKey]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        if let reverse = reverse {
            queryItems.append(URLQueryItem(name: "reverse", value: String(reverse)))
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [APIKey]()
                    for item in json {
                        let id: String = item["id"] as! String
                        let secret: String = (item["secret"] as? String) ?? ""
                        let name: String = item["name"] as! String
                        let nonce: Double = item["nonce"] as! Double
                        let cidr: String? = item["cidr"] as? String
                        let permissions: [Any]? = item["permissions"] as? [Any]
                        let enabled: Bool? = item["enabled"] as? Bool
                        let userId: Double = item["userId"] as! Double
                        let created: String? = item["created"] as? String
                        let apiKey = APIKey(id: id, secret: secret, name: name, nonce: nonce, cidr: cidr, permissions: permissions, enabled: enabled, userId: userId, created: created)
                        result.append(apiKey)
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
