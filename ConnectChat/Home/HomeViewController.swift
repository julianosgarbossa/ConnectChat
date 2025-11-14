//
//  HomeViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 12/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {

    private var homeScreen: HomeScreen?
    private var alert: Alert?
    private var auth: Auth?
    private var firestore: Firestore?
    private var idUserLogged: String?
    private var emailUserLogged: String?
    private var contactScreen: Bool?
    private var conect: ContactController?
    private var listContact:[Contact] = []
    private var listConversation: [Conversation] = []
    private var conversationListener: ListenerRegistration?

    override func loadView() {
        homeScreen = HomeScreen()
        self.view = homeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alert = Alert(controller: self)
        self.setProtocols()
        self.configIdentifierFirebase()
        self.configContact()
        self.addListenerRecoveryConversation()
    }
    
    private func setProtocols() {
        homeScreen?.configNavScreenProtocol(delegate: self)
        homeScreen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
    
    private func configIdentifierFirebase() {
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        // recuperar id do usuário logado
        if let currentUser = auth?.currentUser {
            self.idUserLogged = currentUser.uid
            self.emailUserLogged = currentUser.email
        }
    }
    
    private func configContact() {
        conect = ContactController()
        conect?.delegate(delegate: self)
    }
    
    private func addListenerRecoveryConversation() {
        if let idUserLogged = auth?.currentUser?.uid {
            conversationListener = firestore?.collection("conversation").document(idUserLogged).collection("lastConversation").addSnapshotListener({ snapshotResult, error in
                if error == nil {
                    self.listConversation.removeAll()
                    
                    if let snapshot = snapshotResult {
                        for document in snapshot.documents {
                            let dataConversation = document.data()
                            self.listConversation.append(Conversation(dictionary: dataConversation))
                        }
                        self.homeScreen?.reloadTableView()
                    }
                }
            })
        }
    }
    
    private func getContact() {
        listContact.removeAll()
        firestore?.collection("users").document(idUserLogged ?? "").collection("contacts").getDocuments { snapshotResult, error in
            
            if error != nil {
                print("error getContant")
                return
            }
            
            if let snapshot = snapshotResult {
                for document in snapshot.documents {
                    let dataContact = document.data()
                    self.listContact.append(Contact(dictionary: dataContact))
                }
                self.homeScreen?.reloadTableView()
            }
        }
    }
}

extension HomeViewController: NavScreenProtocol {
    func typeAction(type: TypeAction) {
        switch type {
        case .search:
            alert?.getAlert(title: "Atenção", message: "A funcionalidade de pesquisar ainda não foi implementada, tente novamente mais tarde!")
        case .conversations:
            contactScreen = false
            self.addListenerRecoveryConversation()
            self.homeScreen?.reloadTableView()
        case .contacts:
            contactScreen = true
            self.getContact()
            self.conversationListener?.remove()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if contactScreen ?? false {
            
            if indexPath.row == listContact.count {
                alert?.addContact { value in
                    self.conect?.addContact(email: value, emailUserLogged: self.emailUserLogged ?? "", idUser: self.idUserLogged ?? "")
                }
            } else {
                let chatViewController = ChatViewController()
                chatViewController.configure(contact: listContact[indexPath.row])
                navigationController?.pushViewController(chatViewController, animated: true)
            }
        } else {
            let conversation = listConversation[indexPath.row]
            let contact = Contact(id: conversation.idUserDestination, name: conversation.name)
            let chatViewController = ChatViewController()
            chatViewController.configure(contact: contact)
            navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if contactScreen ?? false {
            return listContact.count + 1
        } else {
            return self.listConversation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if contactScreen ?? false {
            
            if indexPath.row == listContact.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageLastTableViewCell.identifier, for: indexPath) as? MessageLastTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageDetailTableViewCell.identifier, for: indexPath) as? MessageDetailTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.setupMessageDetailTableViewCell(contact: listContact[indexPath.row])
                return cell
            }
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageDetailTableViewCell.identifier, for: indexPath) as? MessageDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.setupMessageDetailTableViewCell(conversation: listConversation[indexPath.row])
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

extension HomeViewController: ContactControllerProtocol {
    
    func alertStateError(title: String, message: String) {
        alert?.getAlert(title: title, message: message)
    }
    
    func successContact() {
        alert?.getAlert(title: "Parabens", message: "Usuário adicionado com sucesso!") {
            self.getContact()
        }
    }
}




