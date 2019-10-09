//
//  ViewController.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/19/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let bitmex_address = "3BMEXBFzETdyet2yGkTzUPSh4jNGLEyDZT"
        
//        let api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOnsiaWQiOjI3MjksImVtYWlsIjoiYm1oa2FyaW1pQGdtYWlsLmNvbSJ9LCJzY29wZXMiOlsidXNlciIsImJvdCJdLCJpc3MiOiJleGlyLnRlY2giLCJpYXQiOjE1Njg0NzE1MTV9.OQrtvklbbeNQk3vs5mehZWKWbxFgHFdkxqQ0BcfcZh8"
        
//        let account = Authentication(apiKey: "_DaiWo0EvxCs2MoOqHpu74BY", apiSecret: "JqKATUG0tqRFBubQW05QNbdEXsxJOMPQiAuVXtqXQpmmfwNp")
//        APIKey.GET(authentication: account) { (optionalAPIKeys, optionalResponse, optionalError) in
//            guard optionalError == nil else {
//                print(optionalError!.localizedDescription)
//                return
//            }
//            guard optionalResponse != nil else {
//                print("No Response!")
//                return
//            }
//            if let response = optionalResponse as? HTTPURLResponse {
//                if response.statusCode == 200 {
//                    if let apiKeys = optionalAPIKeys {
//                        for apiKey in apiKeys {
//                            print(apiKey.id)
//                            print(apiKey.name)
//                            print(apiKey.nonce)
//                            print(apiKey.secret)
//                            print(apiKey.userId)
//                            if let t = apiKey.created {
//                                print(t)
//                            }
//                            if let t = apiKey.enabled {
//                                print(t)
//                            }
//                            if let t = apiKey.cidr {
//                                print(t)
//                            }
//                        }
//                    }
//                } else {
//                    print(response.description)
//                }
//            } else {
//                print("Bad Response!")
//            }
//        }
        
        
//        POST_RequestWithdrawal(api_key: api_key, currency: "btc", amount: 0.001, address: bitmex_address) { (json, optionalResponse, optionalError) in
//            guard optionalError == nil else {
//                print(optionalError!.localizedDescription)
//                return
//            }
//            guard optionalResponse != nil else {
//                print("No Response!")
//                return
//            }
//            if let response = optionalResponse as? HTTPURLResponse {
//                if response.statusCode == 200 {
//                    if let json = json {
//                        print(json)
//                    }
//                } else {
//                    print(response.description)
//                }
//            } else {
//                print("Bad Response!")
//            }
//        }
        
        let app = App()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.app = app
        }
        
        Instrument.GET_Active() { (optionalInstruments, optionalResponse, optionalError) in
            guard optionalError == nil else {
                print(optionalError!.localizedDescription)
                return
            }
            guard optionalResponse != nil else {
                print("No Response!")
                return
            }
            if let response = optionalResponse as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let instruments = optionalInstruments {
                        app.activeInstruments = instruments
                        self.presentTheViewController()
                    }
                } else {
                    print(response.description)
                }
            } else {
                print("Bad Response!")
            }
        }
        
        
        
        
        
//        Announcement.GETUrgent(authentication: account, columns: [Announcement.Columns.title, Announcement.Columns.content, Announcement.Columns.date]) { (optionalAnnouncements, optionalResponse, optionalError) in
//            guard optionalError == nil else {
//                print(optionalError!.localizedDescription)
//                return
//            }
//            guard optionalResponse != nil else {
//                print("No Response!")
//                return
//            }
//            if let response = optionalResponse as? HTTPURLResponse {
//                if response.statusCode == 200 {
//                    if let announcements = optionalAnnouncements {
//                        for announcement in announcements {
//                            print(announcement.title!, ": ", announcement.content!)
//                        }
//                    }
//                } else {
//                    print(response.description)
//                }
//            } else {
//                print("Bad Response!")
//            }
//        }
        
//        let filter: [String: Any] = ["execType": ["Settlement", "Trade"]]
//        Execution.GETTradeHistory(authentication: account, symbol: "XBTUSD", count: 100, reverse: true, startTime: "2014-12-26 11:00", endTime: "2018-12-20 13:00", filter: filter, columns: [Execution.Columns.account, Execution.Columns.execType]) { (optionalExecution, optionalResponse, optionalError) in
//            guard optionalError == nil else {
//                print(optionalError!.localizedDescription)
//                return
//            }
//            guard optionalResponse != nil else {
//                print("No Response!")
//                return
//            }
//            if let response = optionalResponse as? HTTPURLResponse {
//                print(response.statusCode)
//                if response.statusCode == 200 {
//                    if let executions = optionalExecution {
//                        for execution in executions {
//                            print(execution.execID)
//                        }
//                    }
//                } else {
//                    print(response.description)
//                }
//            } else {
//                print("Bad Response!")
//            }
//        }
        
//        let filter: [String: Any] = ["symbol": "XBTUSD"]
//        Funding.GET(count: 100, reverse: true, start: 5, startTime: "2014-12-26 11:00", endTime: "2018-12-20 13:00", filter: filter) { (optionalFunding, optionalResponse, optionalError) in
//            guard optionalError == nil else {
//                print(optionalError!.localizedDescription)
//                return
//            }
//            guard optionalResponse != nil else {
//                print("No Response!")
//                return
//            }
//            if let response = optionalResponse as? HTTPURLResponse {
//                print(response.statusCode)
//                if response.statusCode == 200 {
//                    if let fundings = optionalFunding {
//                        for funding in fundings {
//                            print(funding.symbol, ": ", funding.fundingRate ?? "", "\t\t", funding.timestamp)
//                        }
//                    }
//                } else {
//                    print(response.description)
//                }
//            } else {
//                print("Bad Response!")
//            }
//        }
        
        
        

    }


    private func presentTheViewController() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showTabbarVCSegue", sender: self)
        }
    }
    
    
    
    
    func POST_RequestWithdrawal(api_key: String, currency: String, amount: Double, address: String,  completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "api.exir.io"
        let path = "/v0/user/request-withdrawal"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + api_key, forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "currency": currency,
            "amount": amount,
            "fee": 0.0003,
            "address": address
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch {
            completion(nil, nil, nil)
        }
        print(request.description)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let data = data {
                if let ss = String(data: data, encoding: .utf8) {
                    print("\nData:\n" + ss + "\n\n")
                }
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("StatusCode = ", httpResponse.statusCode)
                    completion(nil, response, nil)
                    return
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(item, response, nil)
                    return
                } else {
                    completion(nil, response, nil)
                    return
                }
            } catch {
                completion(nil, response, nil)
                return
            }
            
        }
        task.resume()
    }
    
    
    
    func GET_Fee(api_key: String, currency: String, completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "api.exir.io"
        let path = "/v0/user/withdraw/" + currency + "/fee"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
//        var queryItems = [URLQueryItem]()
//        queryItems.append(URLQueryItem(name: "currency", value: currency))
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        request.setValue("Bearer " + api_key, forHTTPHeaderField: "Authorization")
        
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(item, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    func GET_STH(completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void) {
        
//        let url = "https://api.exir.io/v0/trades?symbol=btc-tmn and 0=1"
        
        let scheme = "https"
        let host = "api.exir.io"
        let path = "/v0/trades"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "symbol", value: "btc-tmn ORDER"))
        urlComponents.queryItems = queryItems
        
        print(urlComponents.url!)
        
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
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(item, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }


    //https://pro.exir.io/confirm-withdraw/35cc926d665f8ab347e6488787f0fbb87d274d3ba253b2443fa19178e975063efaf65de7f99c25a40ccaf2fe86ebf4ac078224dd2ce751c76b12e5b5
}

