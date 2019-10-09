//
//  Announcement.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Announcement {
    //MARK: Constants
    static let endpoint = "/announcement"
    static let endpoint_urgent = "/announcement/urgent"
    
    //MARK: Properties
    var id: Int
    var link: String?
    var title: String?
    var content: String?
    var date: String?
    var isUrgent: Bool?
    
    
    //MARK: Initialization
    private init(id: Int, link: String?, title: String?, content: String?, date: String?, isUrgent: Bool? = false) {
        self.id = id
        self.link = link
        self.title = title
        self.content = content
        self.date = date
        self.isUrgent = isUrgent
    }
    
    //MARK: Types
    struct Columns {
        static let id = "id"
        static let link = "link"
        static let title = "title"
        static let content = "content"
        static let date = "date"
    }
    
    
    
    //MARK: Static Methods
    static func GET(columns: [String]? = nil, completion: @escaping ([Announcement]?, URLResponse?, Error?) -> Void) {
        _GET(columns: columns, completion: completion)
    }
    
    static func GET_Urgent(authentication: Authentication, columns: [String]? = nil, completion: @escaping ([Announcement]?, URLResponse?, Error?) -> Void) {
        _GET(authentication: authentication, columns: columns, completion: completion)
    }
    
    
    private static func _GET(authentication: Authentication? = nil, columns: [String]? = nil, completion: @escaping ([Announcement]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + (authentication == nil ?  endpoint : endpoint_urgent)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path

        if let columns = columns {
            urlComponents.queryItems = [URLQueryItem(name: "columns", value: columns.description)]
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        if let auth = authentication {
            let headers = auth.getHeaders(for: request)
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
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
                    var result = [Announcement]()
                    for item in json {
                        let id: Int = item["id"] as! Int
                        let link: String? = item["link"] as? String
                        let title: String? = item["title"] as? String
                        let content: String? = item["content"] as? String
                        let date: String? = item["date"] as? String
                        let isUrgent: Bool? = item["isUrgent"] as? Bool
                        let announcement = Announcement(id: id, link: link, title: title, content: content, date: date, isUrgent: isUrgent)
                        result.append(announcement)
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
