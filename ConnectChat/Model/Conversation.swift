//
//  Conversation.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import Foundation

struct Conversation {
    var name: String?
    var lastMessage: String?
    var idUserDestination: String?
    var photoURL: String?
    
    init(dictionary: [String:Any]) {
        self.name = dictionary["nameUser"] as? String
        self.lastMessage = dictionary["lastMessage"] as? String
        self.idUserDestination = dictionary["idUserDestination"] as? String
        let photoValue = dictionary["photoURL"] as? String
        self.photoURL = (photoValue?.isEmpty ?? true) ? nil : photoValue
    }
}
