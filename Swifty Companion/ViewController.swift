//
//  ViewController.swift
//  Swifty Companion
//
//  Created by Vasu Rabaib on 11/28/19.
//  Copyright © 2019 Vasu Rabaib. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, QuotesManagerDelegate, APITokenManagerDelegate, APIUserManagerDelegate {
    
    var apiToken: String?
    var userInfo: APIUserData?
    var quotesManager = QuotesManager()
    var apiTokenManager = APITokenManager()
    var apiUserManager = APIUserManager()
    
    let dispatchGroup = DispatchGroup()
    
    @IBOutlet weak var enterIntraField: UITextField!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        quotesManager.delegate = self
        quotesManager.fetchRandomQuote()
        
        apiTokenManager.delegate = self
        apiTokenManager.retrieveToken()
        
        apiUserManager.delegate = self
        
        enterIntraField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchUser(_ sender: UIButton) {
        if enterIntraField.text != "" {
            apiUserManager.retrieveUser(token: apiToken!, intra: enterIntraField.text!)
        }
        if userInfo != nil {
            self.performSegue(withIdentifier: "goToResult", sender: self)
        }
    }
    
    func userNotFound() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.enterIntraField.text = "User Not Found"
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.enterIntraField.text = ""
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! IntraViewController
            destinationVC.userData = self.userInfo
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterIntraField.endEditing(true)
        return true
    }
    
    func displayQuote(quote: QuotesData) {
        DispatchQueue.main.async {
            self.quoteLabel.text = "\"\(quote.en)\""
        }
    }
    
    func displayAuthor(quote: QuotesData) {
        DispatchQueue.main.async {
            self.authorLabel.text = "- \(quote.author)"
        }
    }
    
    func getToken(token: APITokenData) {
        self.apiToken = token.access_token
    }
    
    func getUser(user: APIUserData) {
        self.userInfo = user
    }
        
        
        
}

