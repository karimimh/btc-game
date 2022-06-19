//
//  ViewController.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/19/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var app: App = App()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.app = app
        }
        
        app.viewController = self
        
        self.app.downloadInstruments { (optionalInstruments) in
            if let instruments = optionalInstruments {
                self.app.activeInstruments = instruments
                self.presentTheViewController()
            }
        }
    }

    
    
    private func presentTheViewController() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showTabbarVCSegue", sender: self)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //-------------------
    
    
    
    
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

