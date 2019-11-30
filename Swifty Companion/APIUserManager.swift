//
//  APIUserManager.swift
//  Swifty Companion
//
//  Created by Vasu Rabaib on 11/28/19.
//  Copyright © 2019 Vasu Rabaib. All rights reserved.
//

import Foundation

protocol APIUserManagerDelegate {
    func getUser(user: APIUserData)
    func userNotFound()
}

struct APIUserManager {
    
    let apiURL = "https://api.intra.42.fr/v2/users/"
    
    var delegate: APIUserManagerDelegate?
    
    func retrieveUser(token: String, intra: String) {
        obtainUserInfo(token: token, intra: intra)
    }
    
    func obtainUserInfo(token: String, intra: String) {
        let query = apiURL + intra
        print(query)
        if let queryURL = URL(string: query) {
            var request = URLRequest(url: queryURL)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request, completionHandler: handle(data:response:error:))
            
            task.resume()
        } else {
            print("Not a valid intra")
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data {
            if let user = self.parseJSON(userData: safeData) {
                self.delegate?.getUser(user: user)
            } else {
               
            }
        }
    }
    
    func parseJSON(userData: Data) -> APIUserData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(APIUserData.self, from: userData)
            return decodedData
        } catch {
            print(error)
            self.delegate?.userNotFound()
            return nil
        }
    }
    
}
