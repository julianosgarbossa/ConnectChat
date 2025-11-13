//
//  Contact.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import Foundation

struct Contact {
    var id: String?
    var name: String?
    
    init(dictionary: [String:Any]?) {
        self.id = dictionary?["id"] as? String
        self.name = dictionary?["name"] as? String
    }
    
    init(id: String?, name: String?) {
        self.init(dictionary: ["id": id as Any, "name": name as Any])
    }
}
