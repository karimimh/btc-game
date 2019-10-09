//
//  UserEvent.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class UserEvent {
    //MARK: Constants
    static let endpoint = "/userEvent"
    
    //MARK: Properties
    var id: Double?
    var type: String /* = ['apiKeyCreated', 'deleverageExecution', 'depositConfirmed', 'depositPending', 'banZeroVolumeApiUser', 'liquidationOrderPlaced', 'login', 'pgpMaskedEmail', 'pgpTestEmail', 'passwordChanged', 'positionStateLiquidated', 'positionStateWarning', 'resetPasswordConfirmed', 'resetPasswordRequest', 'transferCanceled', 'transferCompleted', 'transferReceived', 'transferRequested', 'twoFactorDisabled', 'twoFactorEnabled', 'withdrawalCanceled', 'withdrawalCompleted', 'withdrawalConfirmed', 'withdrawalRequested', 'verify']*/
    var status: String/* = ['success', 'failure']*/
    var userId: Double
    var createdById: Double
    var ip: String?
    var geoipCountry: String?
    var geoipRegion: String?
    var geoipSubRegion: String?
    var eventMeta: Any?
    var created: String
    
    
    //MARK: Initialization
    private init(id: Double?, type: String, status: String, userId: Double, createdById: Double, ip: String?, geoipCountry: String?, geoipRegion: String?, geoipSubRegion: String?, eventMeta: Any?, created: String) {
        self.id = id
        self.type = type
        self.status = status
        self.userId = userId
        self.createdById = createdById
        self.ip = ip
        self.geoipCountry = geoipCountry
        self.geoipRegion = geoipRegion
        self.geoipSubRegion = geoipSubRegion
        self.eventMeta = eventMeta
        self.created = created
    }
    
    //MARK: Static Methods
    static func GET(authentication: Authentication, count: Double? = nil, startId: Double? = nil, completion: @escaping ([UserEvent]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        if let count = count {
            queryItems.append(URLQueryItem(name: "count", value: String(count)))
        }
        
        if let startId = startId {
            queryItems.append(URLQueryItem(name: "startId", value: String(startId)))
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
                    var result = [UserEvent]()
                    for item in json {
                        let id: Double? = item["id"] as? Double
                        let type: String = item["type"] as! String
                        let status: String = item["status"] as! String
                        let userId: Double = item["userId"] as! Double
                        let createdById: Double = item["createdById"] as! Double
                        let ip: String? = item["ip"] as? String
                        let geoipCountry: String? = item["geoipCountry"] as? String
                        let geoipRegion: String? = item["geoipRegion"] as? String
                        let geoipSubRegion: String? = item["geoipSubRegion"] as? String
                        let eventMeta: Any? = item["eventMeta"]
                        let created: String = item["created"] as! String
                        let userEvent = UserEvent(id: id, type: type, status: status, userId: userId, createdById: createdById, ip: ip, geoipCountry: geoipCountry, geoipRegion: geoipRegion, geoipSubRegion: geoipSubRegion, eventMeta: eventMeta, created: created)
                        result.append(userEvent)
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
