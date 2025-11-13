//
//  Message.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 12/11/25.
//

import Foundation

struct Message {
    var text: String?
    var idUser: String?
    
    init(dictionary: [String:Any]) {
        self.text = dictionary["text"] as? String
        self.idUser = dictionary["idUser"] as? String
    }
}
