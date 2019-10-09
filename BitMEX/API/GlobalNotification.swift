//
//  GlobalNotification.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

// Upcoming Feature, Still not working!
class GlobalNotification {
    //MARK: Constants
    static let endpoint = "/globalNotification"
    
    //MARK: Properties
    var id: Int?
    var date: String
    var title: String
    var body: String
    var ttl: Double
    var type: String?
    var closable: Bool?
    var persist: Bool?
    var waitForVisibility: Bool?
    var sound: String?
    
    //MARK: Initialization
    private init(id: Int?, date: String, title: String, body: String, ttl: Double, type: String?, closable: Bool?, persist: Bool?, waitForVisibility: Bool?, sound: String?) {
        self.id = id
        self.date = date
        self.title = title
        self.body = body
        self.ttl = ttl
        self.type = type
        self.closable = closable
        self.persist = persist
        self.waitForVisibility = waitForVisibility
        self.sound = sound
    }
    
    //MARK: Types
    struct Columns {
        static let id = "id"
        static let date = "date"
        static let title = "title"
        static let body = "body"
        static let ttl = "ttl"
        static let type = "type"
        static let closable = "closable"
        static let persist = "persist"
        static let waitForVisibility = "waitForVisibility"
        static let sound = "sound"
    }
    
    
    //MARK: Static Methods
    
    static func GET(authentication: Authentication, completion: @escaping ([GlobalNotification]?, URLResponse?, Error?) -> Void) {
        
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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [GlobalNotification]()
                    print(json)
                    for item in json {
                        let id: Int? = item["id"] as? Int
                        let date: String = item["date"] as! String
                        let title: String = item["title"] as! String
                        let body: String = item["body"] as! String
                        let ttl: Double = item["ttl"] as! Double
                        let type: String? = item["type"] as? String
                        let closable: Bool? = item["closable"] as? Bool
                        let persist: Bool? = item["persist"] as? Bool
                        let waitForVisibility: Bool? = item["waitForVisibility"] as? Bool
                        let sound: String? = item["sound"] as? String
                        let gn = GlobalNotification(id: id, date: date, title: title, body: body, ttl: ttl, type: type, closable: closable, persist: persist, waitForVisibility: waitForVisibility, sound: sound)
                        result.append(gn)
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
