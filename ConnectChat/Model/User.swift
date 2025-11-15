//
//  User.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import Foundation

struct User {
    var name: String?
    var email: String?
    var photoURL: String?
    
    init(dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        let photoValue = dictionary["photoURL"] as? String
        self.photoURL = (photoValue?.isEmpty ?? true) ? nil : photoValue
    }
}
