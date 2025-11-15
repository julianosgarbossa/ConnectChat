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
    var photoURL: String?
    
    init(dictionary: [String:Any]?) {
        self.id = dictionary?["id"] as? String
        self.name = dictionary?["name"] as? String
        let photoValue = dictionary?["photoURL"] as? String
        self.photoURL = (photoValue?.isEmpty ?? true) ? nil : photoValue
    }
    
    init(id: String?, name: String?, photoURL: String? = nil) {
        var dictionary: [String: Any] = [:]
        if let id = id { dictionary["id"] = id }
        if let name = name { dictionary["name"] = name }
        if let photoURL = photoURL { dictionary["photoURL"] = photoURL }
        self.init(dictionary: dictionary)
    }
}
