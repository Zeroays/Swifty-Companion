//
//  APIUserData.swift
//  Swifty Companion
//
//  Created by Vasu Rabaib on 11/28/19.
//  Copyright © 2019 Vasu Rabaib. All rights reserved.
//

import Foundation

struct APIUserData: Codable {
     
     let email: String
     let login: String
     let first_name: String
     let last_name: String
     let displayname: String
     let location: String?
     let image_url: String
    
     //let cursus_users: [Stats]
}

//struct Stats: Codable {
//     let
//}
