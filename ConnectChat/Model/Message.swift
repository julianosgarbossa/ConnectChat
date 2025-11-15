//
//  Message.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 12/11/25.
//

import Foundation
import FirebaseFirestore

struct Message {
    let id: String
    var text: String?
    var idUser: String?
    var isEdited: Bool
    var date: Timestamp?
    
    var displayText: String {
        let baseText = text ?? ""
        guard isEdited else {
            return baseText
        }
        
        if baseText.isEmpty {
            return "(editado)"
        }
        
        return "\(baseText) (editado)"
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.text = dictionary["text"] as? String
        self.idUser = dictionary["idUser"] as? String
        self.isEdited = dictionary["isEdited"] as? Bool ?? false
        self.date = dictionary["date"] as? Timestamp
    }
}
