//
//  ContactController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol ContactControllerProtocol: AnyObject {
    func alertStateError(title: String, message: String)
    func successContact()
}

class ContactController {
    
    private weak var delegate: ContactControllerProtocol?
    
    private func saveContact(dataContact: Dictionary<String,Any>, idUser: String) {
        
        let contact: Contact = Contact(dictionary: dataContact)
        let firestore: Firestore = Firestore.firestore()
        firestore.collection("users").document(idUser).collection("contacts").document(contact.id ?? "").setData(dataContact) { error in
            if error == nil {
                self.delegate?.successContact()
            }
        }
    }
    
    public func addContact(email: String, emailUserLogged: String, idUser: String) {
        
        if email == emailUserLogged {
            self.delegate?.alertStateError(title: "Atenção", message: "Você não pode adicionar o seu próprio email!")
            return
        }
        
        // verificar se existe o usuario no firebase
        let firestore = Firestore.firestore()
        firestore.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshotResult, error in
            
            if let allItens = snapshotResult?.count {
                if allItens == 0 {
                    self.delegate?.alertStateError(title: "Atenção", message: "Usuário não cadastrado, verifique o e-mail e tente novamente!")
                    return
                }
            }
            
            // salvar contato
            if let snapshot = snapshotResult {
                for document in snapshot.documents {
                    let data = document.data()
                    self.saveContact(dataContact: data, idUser: idUser)
                }
            }
        }
    }
    
    public func delegate(delegate: ContactControllerProtocol?) {
        self.delegate = delegate
    }
    
}
