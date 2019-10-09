//
//  Authentication.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class Authentication: Equatable {
    
    //MARK: Properties
    var apiKey: String
    var apiSecret: String
    
    var user: User?
    
    
    //MARK: - Initialization
    init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    init() {
        apiKey = ""
        apiSecret = ""
    }
    
    
    //MARK: - Methods
    func getHeaders(for request: URLRequest) -> [String: String] {
        let urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!
        let api_expires = String(Int(Date().timeIntervalSince1970.rounded()) + 5)
        let api_key = String(apiKey)
        let verb = request.httpMethod!
        let path = urlComponents.percentEncodedPath
        let query = (urlComponents.percentEncodedQuery == nil) ? ("") : ("?" + urlComponents.percentEncodedQuery!)
        let data: String = (request.httpBody == nil) ? "" : String(data: request.httpBody!, encoding: .utf8)!
        let api_signature: String = verb + path + query + api_expires + data
        let headers = ["api-expires": api_expires, "api-key": api_key, "api-signature": api_signature.hmac(algorithm: .SHA256, key: apiSecret)]
        return headers
    }
    

    //MARK: - Equatable
    static func == (lhs: Authentication, rhs: Authentication) -> Bool {
        return lhs.apiKey == rhs.apiKey && lhs.apiSecret == rhs.apiSecret
    }
    
    
}
