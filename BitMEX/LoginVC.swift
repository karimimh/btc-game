//
//  LoginVC.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/22/1399 AP.
//  Copyright © 1399 AP Behnam Karimi. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var apiKeyTF: UITextField!
    @IBOutlet weak var apiSecretTF: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    var dissmissCompletion: (() -> Void)?
    
    
    //MARK: Properties
    var app: App!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }

        apiKeyTF.text = app.settings.accountApiKey
        apiSecretTF.text = app.settings.accountApiSecret
        setButtonText()
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if let t = loginButton.titleLabel?.text {
            if t == "Login" {
                if let apiKeyStr = apiKeyTF.text, let apiSecretStr = apiSecretTF.text {
                    let auth = Authentication(apiKey: apiKeyStr, apiSecret: apiSecretStr)
                    User.GET(authentication: auth) { (optionalUser, optionalResponse, optionalError) in
                        guard optionalError == nil else {
                            self.showAlert(message: "Failed")
                            print(optionalError!.localizedDescription)
                            return
                        }
                        guard optionalResponse != nil else {
                            self.showAlert(message: "Failed")
                            print("No Response!")
                            return
                        }
                        if let response = optionalResponse as? HTTPURLResponse {
                            if response.statusCode == 200 {
                                self.app.settings.accountApiKey = apiKeyStr
                                self.app.settings.accountApiSecret = apiSecretStr
                                self.app.authentication = auth
                                self.app.saveSettings()
                                DispatchQueue.main.async {
                                    self.setButtonText()
                                    self.dismiss(animated: true) {
                                        self.dissmissCompletion?()
                                    }
                                }
                            } else {
                                self.showAlert(message: "Failed")
                                print(response.description)
                                return
                            }
                        } else {
                            self.showAlert(message: "Failed")
                            print("Bad Response!")
                            return
                        }
                    }
                }
            } else {
                app.authentication = nil
                self.app.settings.accountApiKey = ""
                self.app.settings.accountApiSecret = ""
                self.setButtonText()
                self.app.saveSettings()
                DispatchQueue.main.async {
                    self.setButtonText()
                    self.dismiss(animated: true) {
                        self.app.viewController?.downloadData()
                        
                    }
                }
            }
        }
    }
    
    private func setButtonText() {
        if app.settings.accountApiKey.isEmpty {
            loginButton.setTitle("Login", for: .normal)
        } else {
            loginButton.setTitle("Logout", for: .normal)
        }
    }
    
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    

}
