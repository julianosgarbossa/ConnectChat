//
//  ChatViewController.swift
//  ConnectChat
//
//  Created by Juliano Sgarbossa on 13/11/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    private var chatScreen: ChatScreen?
    private var alert: Alert?
    private var listMessage:[Message] = []
    private var idUserLogged: String?
    private var contact: Contact?
    private var messageListener: ListenerRegistration?
    private var auth: Auth?
    private var firestore: Firestore?
    private var nameContact: String?
    private var nameUserLogged: String?
    
    override func loadView() {
        chatScreen = ChatScreen()
        self.view = chatScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert = Alert(controller: self)
        self.setProtocols()
        self.configDataFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addListenerRecoveryMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.messageListener?.remove()
    }
    
    private func setProtocols() {
        chatScreen?.delegate(delegate: self)
        chatScreen?.chatNavScreenDelegate(delegate: self)
        chatScreen?.configTableViewProtocols(delegate: self, dataSource: self)
    }
    
    private func configDataFirebase() {
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        // recuperar id do usuario logado
        if let id = auth?.currentUser?.uid {
            idUserLogged = id
            self.recoveryDataUserLogged()
        }
        
        if let name = contact?.name {
            nameContact = name
        }
    }

    public func configure(contact: Contact) {
        self.contact = contact
        self.nameContact = contact.name
    }
    
    private func addListenerRecoveryMessages() {
        if let idDestination = contact?.id {
            messageListener = firestore?.collection("messages").document(idUserLogged ?? "").collection(idDestination).order(by: "date", descending: true).addSnapshotListener({ snapshotResult, error in
                // limpar todas as mensagens
                self.listMessage.removeAll()
                
                // recuperar dados
                if let snaphot = snapshotResult?.documents {
                    for document in snaphot {
                        let dados = document.data()
                        self.listMessage.append(Message(dictionary: dados))
                    }
                    self.chatScreen?.reloadTableView()
                }
            })
        }
    }
    
    private func recoveryDataUserLogged() {
        let users = firestore?.collection("users").document(idUserLogged ?? "")
        users?.getDocument() { documentSnapshot, error in
            if error == nil {
                let data: Contact = Contact(dictionary: documentSnapshot?.data() ?? [:])
                self.nameUserLogged = data.name ?? ""
            }
        }
    }
    
    private func saveMessage(idRemetente: String, idDestinatario: String, message: [String:Any]) {
        firestore?.collection("messages").document(idRemetente).collection(idDestinatario).addDocument(data: message)
        
        chatScreen?.clearInputMessage()
    }
    
    private func saveConversation(idRemetente: String, idDestinatario: String, conversation: [String:Any]) {
        firestore?.collection("conversation").document(idRemetente).collection("lastConversation").document(idDestinatario).setData(conversation)
    }
}

extension ChatViewController: ChatNavScreenProtocol {
    func actionBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func actionSearchButton() {
        alert?.getAlert(title: "Atenção", message: "A funcionalidade de pesquisa ainda não foi implementada, tente novamente mais tarde!")
    }
}

extension ChatViewController: ChatScreenProtocol {
    func actionSendButton() {
        let inputMessage = (chatScreen?.getInputMessageText() ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !inputMessage.isEmpty,
              let idUserLogged = idUserLogged,
              let idUserDestination = contact?.id else {
            return
        }
        
        let message: [String: Any] = [
            "idUser": idUserLogged,
            "text": inputMessage,
            "date": FieldValue.serverTimestamp()
        ]
        
        // mensagem para remetente
        self.saveMessage(idRemetente: idUserLogged, idDestinatario: idUserDestination, message: message)
        
        // mensagem para destinatario
        self.saveMessage(idRemetente: idUserDestination, idDestinatario: idUserLogged, message: message)
        
        let conversationForSender: [String: Any] = [
            "idRemetente": idUserLogged,
            "idUserDestination": idUserDestination,
            "nameUser": nameContact ?? "",
            "lastMessage": inputMessage
        ]
        self.saveConversation(idRemetente: idUserLogged, idDestinatario: idUserDestination, conversation: conversationForSender)
        
        let conversationForRecipient: [String: Any] = [
            "idRemetente": idUserDestination,
            "idUserDestination": idUserLogged,
            "nameUser": nameUserLogged ?? "",
            "lastMessage": inputMessage
        ]
        self.saveConversation(idRemetente: idUserDestination, idDestinatario: idUserLogged, conversation: conversationForRecipient)
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let dados = listMessage[index]
        let idUser = dados.idUser ?? ""
        
        if self.idUserLogged != idUser {
            // lado esquerdo
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IncomingTextMessageTableViewCell.identifier, for: indexPath) as? IncomingTextMessageTableViewCell else {
                return UITableViewCell()
            }
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.setupCell(message: dados)
            cell.selectionStyle = .none
            return cell
        } else {
            // lado direito
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingTextMessageTableViewCell.identifier, for: indexPath) as? OutgoingTextMessageTableViewCell else {
                return UITableViewCell()
            }
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.setupCell(message: dados)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text: String = listMessage[indexPath.row].text ?? ""
        let font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let estimateHeight = text.heightWithConstrainedWidth(width: 220, font: font)
        return CGFloat(65 + estimateHeight)
    }
}


