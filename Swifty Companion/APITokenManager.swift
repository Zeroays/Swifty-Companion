//
//  APITokenManager.swift
//  Swifty Companion
//
//  Created by Vasu Rabaib on 11/28/19.
//  Copyright © 2019 Vasu Rabaib. All rights reserved.
//

import Foundation

protocol APITokenManagerDelegate {
    func getToken(token: APITokenData)
}

struct APITokenManager {
    
    let UID = "67f5bd76a329ab73f9340bce39fb826ecd8edbd49a16bcaa81b7def4c42d810c"
    let SECRET = "f2f2711443dc0516aa2a1eab8eea8a3a5cde09ac889df3ea260262abfe04bcbb"
    let tokenURL = "https://api.intra.42.fr/oauth/token"
    
    var delegate: APITokenManagerDelegate?
    
    func retrieveToken() {
        self.obtainAccessToken(urlString: tokenURL)
    }
    
    func encodedString(username: String, password: String) -> String {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
    
    func obtainAccessToken(urlString: String) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            let authentication = encodedString(username: UID, password: SECRET)
            
            request.httpMethod = "POST"
            request.setValue("Basic \(authentication)", forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)

            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: request, completionHandler: handle(data:response:error:))

            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data {
            if let token = self.parseJSON(tokenData: safeData) {
                self.delegate?.getToken(token: token)
            }
        }
    }
    
    func parseJSON(tokenData: Data) -> APITokenData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(APITokenData.self, from: tokenData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
}
